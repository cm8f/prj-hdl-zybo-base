proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir /home/phil/github/zybo/base_system/base_system.cache/wt [current_project]
  set_property parent.project_dir /home/phil/github/zybo/base_system [current_project]
  add_files -quiet /home/phil/github/zybo/base_system/base_system.runs/synth_1/base_system_wrapper.dcp
  read_xdc -ref base_system_processing_system7_0_0 -cells inst /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_processing_system7_0_0/base_system_processing_system7_0_0.xdc
  set_property processing_order EARLY [get_files /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_processing_system7_0_0/base_system_processing_system7_0_0.xdc]
  read_xdc -ref base_system_axi_gpio_0_0 -cells U0 /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_axi_gpio_0_0/base_system_axi_gpio_0_0.xdc
  set_property processing_order EARLY [get_files /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_axi_gpio_0_0/base_system_axi_gpio_0_0.xdc]
  read_xdc -prop_thru_buffers -ref base_system_axi_gpio_0_0 -cells U0 /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_axi_gpio_0_0/base_system_axi_gpio_0_0_board.xdc
  set_property processing_order EARLY [get_files /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_axi_gpio_0_0/base_system_axi_gpio_0_0_board.xdc]
  read_xdc -ref base_system_axi_gpio_0_1 -cells U0 /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_axi_gpio_0_1/base_system_axi_gpio_0_1.xdc
  set_property processing_order EARLY [get_files /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_axi_gpio_0_1/base_system_axi_gpio_0_1.xdc]
  read_xdc -prop_thru_buffers -ref base_system_axi_gpio_0_1 -cells U0 /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_axi_gpio_0_1/base_system_axi_gpio_0_1_board.xdc
  set_property processing_order EARLY [get_files /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_axi_gpio_0_1/base_system_axi_gpio_0_1_board.xdc]
  read_xdc -ref base_system_rst_processing_system7_0_100M_0 /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_rst_processing_system7_0_100M_0/base_system_rst_processing_system7_0_100M_0.xdc
  set_property processing_order EARLY [get_files /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_rst_processing_system7_0_100M_0/base_system_rst_processing_system7_0_100M_0.xdc]
  read_xdc -prop_thru_buffers -ref base_system_rst_processing_system7_0_100M_0 /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_rst_processing_system7_0_100M_0/base_system_rst_processing_system7_0_100M_0_board.xdc
  set_property processing_order EARLY [get_files /home/phil/github/zybo/base_system/base_system.srcs/sources_1/bd/base_system/ip/base_system_rst_processing_system7_0_100M_0/base_system_rst_processing_system7_0_100M_0_board.xdc]
  read_xdc /home/phil/github/zybo/base_system/base_system.srcs/constrs_1/imports/library/ZYBO_Master.xdc
  link_design -top base_system_wrapper -part xc7z010clg400-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  catch {update_ip_catalog -quiet -current_ip_cache {/home/phil/github/zybo/base_system/base_system.cache} }
  opt_design 
  write_checkpoint -force base_system_wrapper_opt.dcp
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  write_checkpoint -force base_system_wrapper_placed.dcp
  catch { report_io -file base_system_wrapper_io_placed.rpt }
  catch { report_clock_utilization -file base_system_wrapper_clock_utilization_placed.rpt }
  catch { report_utilization -file base_system_wrapper_utilization_placed.rpt -pb base_system_wrapper_utilization_placed.pb }
  catch { report_control_sets -verbose -file base_system_wrapper_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force base_system_wrapper_routed.dcp
  catch { report_drc -file base_system_wrapper_drc_routed.rpt -pb base_system_wrapper_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -file base_system_wrapper_timing_summary_routed.rpt -pb base_system_wrapper_timing_summary_routed.pb }
  catch { report_power -file base_system_wrapper_power_routed.rpt -pb base_system_wrapper_power_summary_routed.pb }
  catch { report_route_status -file base_system_wrapper_route_status.rpt -pb base_system_wrapper_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force base_system_wrapper.bit 
  if { [file exists /home/phil/github/zybo/base_system/base_system.runs/synth_1/base_system_wrapper.hwdef] } {
    catch { write_sysdef -hwdef /home/phil/github/zybo/base_system/base_system.runs/synth_1/base_system_wrapper.hwdef -bitfile base_system_wrapper.bit -meminfo base_system_wrapper_bd.bmm -file base_system_wrapper.sysdef }
  }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

