
fpga: 
	cd ./workspace && vivado -nojournal -nolog -mode batch -source ./build.tcl
	cp -f workspace/zybo_base_system/zybo_base_system.xsa ./vitis/hwexport.xsa 

init_apps_standalone: 
	cd ./vitis/standalone && xsct -eval source ./init.tcl

apps_standalone: 
	cd ./vitis/standalone && xsct -eval source ./build.tcl

init_apps_freertos:
	cd ./vitis/freeRTOS && xsct -eval source ./init.tcl

apps_freertos: 
	cd ./vitis/freeRTOS/ && xsct -eval source ./build.tcl

