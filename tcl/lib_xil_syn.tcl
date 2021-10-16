namespace eval xilinx {

  proc read_sources {lhdl lxdc lrepos lbd } {
    set_property target_language VHDL [current_project]

    foreach f $lhdl {
      puts "hdl: $f"
      read_vhdl -library work -vhdl2008 $f
    }
    foreach f $lxdc {
      puts "xdc: $f"
      read_xdc $f
    }
    foreach f $lrepos {
      puts "repo: $f"
      set_property ip_repo_paths  $f  [current_project]
      update_ip_catalog
    }
    foreach f $lbd {
      puts "bd: $f"
      source $f
      set base_name [file rootname [file tail $f]]
      generate_target all [get_files ./.srcs/sources_1/bd/${base_name}/${base_name}.bd] 
      make_wrapper -files [get_files ./.srcs/sources_1/bd/${base_name}/${base_name}.bd] -top
    }
  }

  proc archive {proj_dir proj_name build_date build_time {deploy_dir ../deploy/ } } {
    if { ![file exists $proj_dir/../.temp ]} {
      file mkdir $proj_dir/../.temp
    }
    set archive_name "${proj_name}_${build_date}_${build_time}"
    save_project_as -force $proj_dir/../.temp/${proj_name}_prj
    archive_project -force ${deploy_dir}/${archive_name}_prj.zip
    exec ln -sf "$deploy_dir/${archive_name}_prj.zip" "$deploy_dir/latest-${proj_name}_prj.zip"
  }

  # ######################################
  # synthesize xilinx design
  # ######################################
  proc synth {proj_dir proj_name TOP_MODULE DEFINES SYNTH_ARGS PART} {
    eval "synth_design $DEFINES $SYNTH_ARGS -top $TOP_MODULE -part $PART"
    report_timing_summary -file $proj_dir/${proj_name}_post_synth_tim.rpt
    report_utilization -file $proj_dir/${proj_name}_post_synth_util.rpt
    write_checkpoint -force $proj_dir/${proj_name}_post_synth.dcp
  }

  proc opt {proj_dir proj_name {DIRECTIVE Explore}} {
    # Opt Design 
    opt_design -directive Explore
    report_timing_summary -file $proj_dir/${proj_name}_post_opt_tim.rpt
    report_utilization -file $proj_dir/${proj_name}_post_opt_util.rpt
    write_checkpoint -force $proj_dir/${proj_name}_post_opt.dcp
    # Upgrade DSP connection warnings (like "Invalid PCIN Connection for OPMODE value") to
    # an error because this is an error post route
    set_property SEVERITY {ERROR} [get_drc_checks DSPS-*]
    # Run DRC on opt design to catch early issues like comb loops
    report_drc -file $proj_dir/${proj_name}_post_opt_drc.rpt
  }
  
  proc place {proj_dir proj_name {DIRECTIVE Explore} } {
    # Place Design
    place_design -directive Explore 
    report_timing_summary -file $proj_dir/${proj_name}_post_place_tim.rpt
    report_utilization -file $proj_dir/${proj_name}_post_place_util.rpt
    write_checkpoint -force $proj_dir/${proj_name}_post_place.dcp
  }

  proc phys_opt {proj_dir proj_name {DIRECTIVE AggressiveExplore} } {
    # Post Place Phys Opt
    phys_opt_design -directive AggressiveExplore
    report_timing_summary -file $proj_dir/${proj_name}_post_place_physopt_tim.rpt
    report_utilization -file $proj_dir/${proj_name}_post_place_physopt_util.rpt
    write_checkpoint -force $proj_dir/${proj_name}_post_place_physopt.dcp
  }

  proc route {proj_dir proj_name {DIRECTIVE Explore} } {
    # Route Design
    route_design -directive Explore
    report_timing_summary -file $proj_dir/${proj_name}_post_route_tim.rpt
    report_utilization -hierarchical -file $proj_dir/${proj_name}_post_route_util.rpt
    report_route_status -file $proj_dir/${proj_name}_post_route_status.rpt
    report_io -file $proj_dir/${proj_name}_post_route_io.rpt
    report_power -file $proj_dir/${proj_name}_post_route_power.rpt
    report_design_analysis -logic_level_distribution \
     -of_timing_paths [get_timing_paths -max_paths 10000 \
     -slack_lesser_than 0] \
     -file $proj_dir/${proj_name}_post_route_vios.rpt
    write_checkpoint -force $proj_dir/${proj_name}_post_route.dcp
  }

  proc export_bitfile { proj_dir proj_name build_date build_time {rd_dcp 0} {deploy 1} {deploy_dir "../deploy/"}} {
    if { $rd_dcp } {
      puts "reading dcp"
      read_checkpoint $proj_dir/${proj_name}_post_route.dcp
      open_checkpoint $proj_dir/${proj_name}_post_route.dcp
    }
    set WNS 0.000
    catch {set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]}
    puts "Post Route WNS = $WNS"
    set name  "${proj_name}_${build_date}_${build_time}_${WNS}ns"
    # Write out bitfile
    write_debug_probes -force ${proj_dir}/${name}.ltx
    write_bitstream -force ${proj_dir}/${name}.bit -bin_file

    if { $deploy } {
      catch { file copy -force ${proj_dir}/${name}.ltx ${deploy_dir} } 
      file copy -force ${proj_dir}/${name}.bit ${deploy_dir}
      file copy -force ${proj_dir}/${name}.bin ${deploy_dir}

      catch {exec ln -sf "$deploy_dir/$name.ltx" "$deploy_dir/latest-${proj_name}.ltx"}
      exec ln -sf "$deploy_dir/$name.bit" "$deploy_dir/latest-${proj_name}.bit"
      exec ln -sf "$deploy_dir/$name.bin" "$deploy_dir/latest-${proj_name}.bin"
    }
  }

  proc export_platform { proj_dir proj_name build_date build_time {deploy 1} {deploy_dir "../deploy/"}} {
    puts "reading dcp"
    read_checkpoint $proj_dir/${proj_name}_post_route.dcp
    open_checkpoint $proj_dir/${proj_name}_post_route.dcp

    set WNS 0.000
    catch {set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]}
    puts "Post Route WNS = $WNS"
    set name  "${proj_name}_${build_date}_${build_time}_${WNS}ns"

    write_hw_platform -fixed -include_bit -force -file ${proj_dir}/${name}.xsa

    if { $deploy } {
      file copy -force ${proj_dir}/${name}.xsa ${deploy_dir}
      exec ln -sf "$deploy_dir/$name.xsa" "$deploy_dir/latest-${proj_name}.xsa"
    }
  }

  proc syn2bit {proj_dir proj_name build_date build_time TOP_MODULE DEFINES SYNTH_ARGS PART_NAME} {
    synth $proj_dir $proj_name $TOP_MODULE $DEFINES $SYNTH_ARGS $PART_NAME
    opt $proj_dir $proj_name
    place $proj_dir $proj_name
    phys_opt $proj_dir $proj_name
    route $proj_dir $proj_name
    export_bitfile $proj_dir $proj_name $build_date $build_time
    export_platform $proj_dir $proj_name $build_date $build_time
  }

  proc opt2bit {proj_dir proj_name build_date build_time TOP_MODULE DEFINES SYNTH_ARGS PART_NAME} {
    puts "reading dcp"
    read_checkpoint $proj_dir/${proj_name}_post_synth.dcp
    open_checkpoint $proj_dir/${proj_name}_post_synth.dcp
    opt $proj_dir $proj_name
    place $proj_dir $proj_name
    phys_opt $proj_dir $proj_name
    route $proj_dir $proj_name
    export_bitfile $proj_dir $proj_name $build_date $build_time
    export_platform $proj_dir $proj_name $build_date $build_time
  }

  proc load_post_route { proj_dir proj_name } {
    puts "reading dcp"
    read_checkpoint $proj_dir/${proj_name}_post_route.dcp
    open_checkpoint $proj_dir/${proj_name}_post_route.dcp
  }

  proc load_post_synth { proj_dir proj_name } {
    puts "reading dcp"
    read_checkpoint $proj_dir/${proj_name}_post_synth.dcp
    open_checkpoint $proj_dir/${proj_name}_post_synth.dcp
  }


}
