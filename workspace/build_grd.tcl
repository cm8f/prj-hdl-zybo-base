source ../tcl/common.tcl

# Global Settings
set PROJ_NAME "zybo_grd"
set PROJ_DIR  "./$PROJ_NAME"
set PART_NAME "xc7z010clg400-1"

if { ![file exists $PROJ_DIR ]} {
  file mkdir $PROJ_DIR
}

set TOP_MODULE "top_level"

set_part $PART_NAME
set_property target_language VHDL [current_project]

#read_vhdl -library work [ glob ../hdl/*.vhd ] 
read_vhdl -vhdl2008 -library work "../hdl/top_level.vhd"
read_vhdl -vhdl2008 -library work "../hdl/system_grd_config_pkg.vhd"
read_xdc [ glob ../xdc/*.xdc ] 

# in case of bare minimum project
set_property  ip_repo_paths  {../hdl/lib/} [current_project]
update_ip_catalog

source ../bd/base_system_ps_only.tcl 
source ../bd/system_grd.tcl

generate_target all [get_files ./.srcs/sources_1/bd/base_system_ps_only/base_system_ps_only.bd] 
make_wrapper -files [get_files ./.srcs/sources_1/bd/base_system_ps_only/base_system_ps_only.bd] -top

generate_target all [get_files ./.srcs/sources_1/bd/system_grd/system_grd.bd]  
make_wrapper -files [get_files ./.srcs/sources_1/bd/system_grd/system_grd.bd] -top

source ../tcl/synth.tcl
source ../tcl/export.tcl

