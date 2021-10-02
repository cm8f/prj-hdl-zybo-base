# Synthesize Design
eval "synth_design $DEFINES $SYNTH_ARGS -top $TOP_MODULE -part $PART_NAME"
report_timing_summary -file $PROJ_DIR/${PROJ_NAME}_post_synth_tim.rpt
report_utilization -file $PROJ_DIR/${PROJ_NAME}_post_synth_util.rpt
write_checkpoint -force $PROJ_DIR/${PROJ_NAME}_post_synth.dcp

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

# Place Design
place_design -directive Explore 
report_timing_summary -file $PROJ_DIR/${PROJ_NAME}_post_place_tim.rpt
report_utilization -file $PROJ_DIR/${PROJ_NAME}_post_place_util.rpt
write_checkpoint -force $PROJ_DIR/${PROJ_NAME}_post_place.dcp

# Post Place Phys Opt
phys_opt_design -directive AggressiveExplore
report_timing_summary -file $PROJ_DIR/${PROJ_NAME}_post_place_physopt_tim.rpt
report_utilization -file $PROJ_DIR/${PROJ_NAME}_post_place_physopt_util.rpt
write_checkpoint -force $PROJ_DIR/${PROJ_NAME}_post_place_physopt.dcp

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

set WNS 0.000
catch {set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]}
puts "Post Route WNS = $WNS"

# Write out bitfile
write_debug_probes -force $PROJ_DIR/${PROJ_NAME}_${BUILD_DATE}_${BUILD_TIME}_${WNS}ns.ltx
write_bitstream -force $PROJ_DIR/${PROJ_NAME}_${BUILD_DATE}_${BUILD_TIME}_${WNS}ns.bit -bin_file
