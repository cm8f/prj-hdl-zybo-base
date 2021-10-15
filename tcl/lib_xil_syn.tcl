namespace eval xilinx {

  # ######################################
  # synthesize xilinx design
  # ######################################
  proc synth {PROJ_DIR PROJ_NAME TOP_MODULE DEFINES SYNTH_ARGS PART} {
    eval "synth_design $DEFINES $SYNTH_ARGS -top $TOP_MODULE -part $PART"
    report_timing_summary -file $PROJ_DIR/${PROJ_NAME}_post_synth_tim.rpt
    report_utilization -file $PROJ_DIR/${PROJ_NAME}_post_synth_util.rpt
    write_checkpoint -force $PROJ_DIR/${PROJ_NAME}_post_synth.dcp
  }

  proc opt {PROJ_DIR PROJ_NAME {DIRECTIVE Explore}} {
    # Opt Design 
    opt_design -directive Explore
    report_timing_summary -file $PROJ_DIR/${PROJ_NAME}_post_opt_tim.rpt
    report_utilization -file $PROJ_DIR/${PROJ_NAME}_post_opt_util.rpt
    write_checkpoint -force $PROJ_DIR/${PROJ_NAME}_post_opt.dcp
    # Upgrade DSP connection warnings (like "Invalid PCIN Connection for OPMODE value") to
    # an error because this is an error post route
    set_property SEVERITY {ERROR} [get_drc_checks DSPS-*]
    # Run DRC on opt design to catch early issues like comb loops
    report_drc -file $PROJ_DIR/${PROJ_NAME}_post_opt_drc.rpt
  }
  
  proc place {PROJ_DIR PROJ_NAME {DIRECTIVE Explore} } {
    # Place Design
    place_design -directive Explore 
    report_timing_summary -file $PROJ_DIR/${PROJ_NAME}_post_place_tim.rpt
    report_utilization -file $PROJ_DIR/${PROJ_NAME}_post_place_util.rpt
    write_checkpoint -force $PROJ_DIR/${PROJ_NAME}_post_place.dcp
  }

  proc phys_opt {PROJ_DIR PROJ_NAME {DIRECTIVE AggressiveExplore} } {
    # Post Place Phys Opt
    phys_opt_design -directive AggressiveExplore
    report_timing_summary -file $PROJ_DIR/${PROJ_NAME}_post_place_physopt_tim.rpt
    report_utilization -file $PROJ_DIR/${PROJ_NAME}_post_place_physopt_util.rpt
    write_checkpoint -force $PROJ_DIR/${PROJ_NAME}_post_place_physopt.dcp
  }

  proc route {PROJ_DIR PROJ_NAME {DIRECTIVE Explore} } {
    # Route Design
    route_design -directive Explore
    report_timing_summary -file $PROJ_DIR/${PROJ_NAME}_post_route_tim.rpt
    report_utilization -hierarchical -file $PROJ_DIR/${PROJ_NAME}_post_route_util.rpt
    report_route_status -file $PROJ_DIR/${PROJ_NAME}_post_route_status.rpt
    report_io -file $PROJ_DIR/${PROJ_NAME}_post_route_io.rpt
    report_power -file $PROJ_DIR/${PROJ_NAME}_post_route_power.rpt
    report_design_analysis -logic_level_distribution \
     -of_timing_paths [get_timing_paths -max_paths 10000 \
     -slack_lesser_than 0] \
     -file $PROJ_DIR/${PROJ_NAME}_post_route_vios.rpt
    write_checkpoint -force $PROJ_DIR/${PROJ_NAME}_post_route.dcp
  }

  proc export_bitfile { PROJ_DIR PROJ_NAME BUILD_DATE BUILD_TIME {rd_dcp 0} {deploy 1} {deploy_dir "../deploy/"}} {
    if { $rd_dcp } {
      puts "reading dcp"
      read_checkpoint $PROJ_DIR/${PROJ_NAME}_post_route.dcp
      open_checkpoint $PROJ_DIR/${PROJ_NAME}_post_route.dcp
    }
    set WNS 0.000
    catch {set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]}
    puts "Post Route WNS = $WNS"
    set name  "${PROJ_NAME}_${BUILD_DATE}_${BUILD_TIME}_${WNS}ns"
    # Write out bitfile
    write_debug_probes -force ${PROJ_DIR}/${name}.ltx
    write_bitstream -force ${PROJ_DIR}/${name}.bit -bin_file

    if { $deploy } {
      catch { file copy -force ${PROJ_DIR}/${name}.ltx ${deploy_dir} } 
      file copy -force ${PROJ_DIR}/${name}.bit ${deploy_dir}
      file copy -force ${PROJ_DIR}/${name}.bin ${deploy_dir}

      catch {exec ln -sf "$deploy_dir/$name.ltx" "$deploy_dir/latest-${PROJ_NAME}.ltx"}
      exec ln -sf "$deploy_dir/$name.bit" "$deploy_dir/latest-${PROJ_NAME}.bit"
      exec ln -sf "$deploy_dir/$name.bin" "$deploy_dir/latest-${PROJ_NAME}.bin"
    }
  }

  proc export_platform { PROJ_DIR PROJ_NAME BUILD_DATE BUILD_TIME {deploy 1} {deploy_dir "../deploy/"}} {
    puts "reading dcp"
    read_checkpoint $PROJ_DIR/${PROJ_NAME}_post_route.dcp
    open_checkpoint $PROJ_DIR/${PROJ_NAME}_post_route.dcp

    set WNS 0.000
    catch {set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]}
    puts "Post Route WNS = $WNS"
    set name  "${PROJ_NAME}_${BUILD_DATE}_${BUILD_TIME}_${WNS}ns"

    write_hw_platform -fixed -include_bit -force -file ${PROJ_DIR}/${name}.xsa

    if { $deploy } {
      file copy -force ${PROJ_DIR}/${name}.xsa ${deploy_dir}
      exec ln -sf "$deploy_dir/$name.xsa" "$deploy_dir/latest-${PROJ_NAME}.xsa"
    }
  }

  proc syn2bit {PROJ_DIR PROJ_NAME BUILD_DATE BUILD_TIME TOP_MODULE DEFINES SYNTH_ARGS PART_NAME} {
    synth $PROJ_DIR $PROJ_NAME $TOP_MODULE $DEFINES $SYNTH_ARGS $PART_NAME
    opt $PROJ_DIR $PROJ_NAME
    place $PROJ_DIR $PROJ_NAME
    phys_opt $PROJ_DIR $PROJ_NAME
    route $PROJ_DIR $PROJ_NAME
    export_bitfile $PROJ_DIR $PROJ_NAME $BUILD_DATE $BUILD_TIME
    export_platform $PROJ_DIR $PROJ_NAME 
  }

  proc opt2bit {PROJ_DIR PROJ_NAME BUILD_DATE BUILD_TIME TOP_MODULE DEFINES SYNTH_ARGS PART_NAME} {
    puts "reading dcp"
    read_checkpoint $PROJ_DIR/${PROJ_NAME}_post_synth.dcp
    open_checkpoint $PROJ_DIR/${PROJ_NAME}_post_synth.dcp
    opt $PROJ_DIR $PROJ_NAME
    place $PROJ_DIR $PROJ_NAME
    phys_opt $PROJ_DIR $PROJ_NAME
    route $PROJ_DIR $PROJ_NAME
    export_bitfile $PROJ_DIR $PROJ_NAME $BUILD_DATE $BUILD_TIME
    export_platform $PROJ_DIR $PROJ_NAME $BUILD_DATE $BUILD_TIME
  }

  proc load_post_route { PROJ_DIR PROJ_NAME } {
    puts "reading dcp"
    read_checkpoint $PROJ_DIR/${PROJ_NAME}_post_route.dcp
    open_checkpoint $PROJ_DIR/${PROJ_NAME}_post_route.dcp
  }

  proc load_post_synth { PROJ_DIR PROJ_NAME } {
    puts "reading dcp"
    read_checkpoint $PROJ_DIR/${PROJ_NAME}_post_synth.dcp
    open_checkpoint $PROJ_DIR/${PROJ_NAME}_post_synth.dcp
  }


}
