source ./common.tcl

# synthesis settings
set SYNTH_ARGS ""
append SYNTH_ARGS " " -flatten_hierarchy " " rebuilt " "
append SYNTH_ARGS " " -gated_clock_conversion " " off " "
append SYNTH_ARGS " " -bufg " {" 12 "} "
append SYNTH_ARGS " " -fanout_limit " {" 10000 "} "
append SYNTH_ARGS " " -directive " " Default " "
append SYNTH_ARGS " " -fsm_extraction " " auto " "
#append SYNTH_ARGS " " -keep_equivalent_registers " "
append SYNTH_ARGS " " -resource_sharing " " auto " "
append SYNTH_ARGS " " -control_set_opt_threshold " " auto " "
#append SYNTH_ARGS " " -no_lc " "
#append SYNTH_ARGS " " -shreg_min_size " {" 3 "} "
append SYNTH_ARGS " " -shreg_min_size " {" 5 "} "
append SYNTH_ARGS " " -max_bram " {" -1 "} "
append SYNTH_ARGS " " -max_dsp " {" -1 "} "
append SYNTH_ARGS " " -cascade_dsp " " auto " "
append SYNTH_ARGS " " -verbose

set DEFINES ""
append DEFINES -verilog_define " " USE_DEBUG " "

set TOP_MODULE "top_level"


# build design 
set_part $PART_NAME
set_property target_language VHDL [current_project]
# in case of bare minimum project
read_vhdl -library work [ glob ../hdl/*.vhd ] 
read_xdc [ glob ../xdc/*.xdc ] 

source ../bd/base_system_ps_only.tcl 

make_wrapper -files [get_files ./.srcs/sources_1/bd/base_system_ps_only/base_system_ps_only.bd] -top
generate_target all [get_files ./.srcs/sources_1/bd/base_system_ps_only/base_system_ps_only.bd]
#read_vhdl -library work [glob ./.srcs/sources_1/bd/base_system/hdl/*.vhd]


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

