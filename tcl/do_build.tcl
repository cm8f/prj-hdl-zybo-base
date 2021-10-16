source ../tcl/build_lib.tcl 
set revisions   [ list "system_base" "system_grd" ]
set strategies  [ list "syn" "syn2bit" "opt2bit" "export_bitfile" "export_platform" "load_post_synth" "load_post_route" ]

if { $argc < 1 } {
  puts "No revision specified. "
  puts "Usage: vivado -mode batch -source ./do_build.tcl -tclargs revision_name (strategy)"
  puts "Revision names are: $revisions" 
  puts "strategies are: $strategies"
  exit
}

set strategy "syn2bit"
if { $argc > 1 } {
  set strategy [lindex $argv 1]
}
set archive ""
if { $argc > 2} {
  set archive [lindex $argv 2]
}
puts $argc
puts $strategy

# Global Settings
set PROJ_NAME [lindex $argv 0]
set PROJ_DIR  "../workspace/$PROJ_NAME"
set PART_NAME "xc7z010clg400-1"
set TOP_MODULE "top_level"


set_part $PART_NAME
set_property target_language VHDL [current_project]

if { ![file exists $PROJ_DIR ]} {
  file mkdir $PROJ_DIR
}

#if { ![file exists $PROJ_DIR/../.temp ]} {
#  file mkdir $PROJ_DIR/../.temp
#}

set DEFINES ""
append DEFINES -verilog_define " " USE_DEBUG " "

set  SYNTH_ARGS ""
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

set build_date      [ build_lib::misc::build_date_ymd ]
set build_time      [ build_lib::misc::build_time_hms ]
set git_rev         [ build_lib::misc::git_revision ]

if { [string compare $strategy "load_post_synth"]==0 } { 
  build_lib::xilinx::load_post_synth $PROJ_DIR $PROJ_NAME 
}
if { [string compare $strategy "load_post_route"]==0 } { 
  build_lib::xilinx::load_post_route $PROJ_DIR $PROJ_NAME 
}
if { [string compare $strategy "export_platform"]==0 } {
  build_lib::xilinx::export_platform $PROJ_DIR $PROJ_NAME $build_date $build_time
  exit
}
if { [string compare $strategy "export_bitfile"]==0 } {
  set rd_dcp 1
  build_lib::xilinx::export_bitfile $PROJ_DIR $PROJ_NAME $build_date $build_time $rd_dcp
  exit
}
if { [string compare $strategy "opt2bit"]==0 } {
  build_lib::xilinx::opt2bit $PROJ_DIR $PROJ_NAME $build_date $build_time $TOP_MODULE $DEFINES $SYNTH_ARGS $PART_NAME
  exit
}
if { [string compare $strategy "syn2bit"]==0 || [string compare $strategy "syn"]==0 } {
  set build_date_hex  [ build_lib::misc::build_date_time_hex $build_date ]
  set build_time_hex  [ build_lib::misc::build_date_time_hex $build_time ]
  build_lib::version::version "./" $PROJ_NAME $build_date_hex $build_time_hex $git_rev

  set lrepos [ list "../hdl/lib/" ]
  set lbd    [ glob ../bd/*.tcl ]
  set lxdc   [ glob ../xdc/*.xdc ] 
  set lhdl   [ glob ../hdl/*.vhd ] 
  lappend lhdl "../workspace/${PROJ_NAME}_config_pkg.vhd"
  lappend lhdl "../workspace/${PROJ_NAME}_build_pkg.vhd"

  build_lib::xilinx::read_sources $lhdl $lxdc $lrepos $lbd

  if { [string compare $archive "zip" ]==0 || [string compare $archive "zip_post"]==0 } {
    build_lib::xilinx::archive $PROJ_DIR $PROJ_NAME $build_date $build_time
  }
  if { [string compare $strategy "syn2bit"]==0 } {
    build_lib::xilinx::syn2bit $PROJ_DIR $PROJ_NAME $build_date $build_time $TOP_MODULE $DEFINES $SYNTH_ARGS $PART_NAME
  } 
  if { [string compare $strategy "syn"]==0 } {
    build_lib::xilinx::synth $PROJ_DIR $PROJ_NAME $TOP_MODULE $DEFINES $SYNTH_ARGS $PART_NAME
  }
  exit
}

#source ../tcl/synth.tcl
#source ../tcl/export.tcl

