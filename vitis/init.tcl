setws ./

set script [info script] 
set script_dir [file normalize [file dirname $script]]
puts "INFO: Running $script"

set lang "c"

puts "#############################################"
puts "# Create HW Platform                        #"
puts "#############################################"
set hw_src [lindex [glob -nocomplain $script_dir/*.xsa] 0]
puts "INFO: Found $hw_src"
set hw_name "zybo_platform"
platform create -name "$hw_name" -hw "$hw_src"
platform active "zybo_platform"


puts "#############################################"
puts "# Create Standalone BSP                     #"
puts "#############################################"
set domain_name "zybo_bsp_standalone"
set arch "32-bit"
set os "standalone"
set proc "ps7_cortexa9_0"
domain create -name $domain_name -proc $proc -arch $arch -os $os
bsp setlib -name xilffs


puts "#############################################"
puts "# Create FreeRTOS BSP                       #"
puts "#############################################"
set domain_name "zybo_bsp_freertos"
set os "freertos10_xilinx"
set proc "ps7_cortexa9_1"
domain create -name $domain_name -proc $proc -arch $arch -os $os
bsp setlib -name xilffs
bsp setlib -name lwip211

platform generate

set domain "zybo_bsp_standalone"
set platform "zybo_platform"

puts "#############################################"
puts "# Create Standalone Hello World             #"
puts "#############################################"
set app_name "zybo_standalone_hello"
set template "Hello World"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

puts "#############################################"
puts "# Create Standalone FSBL                    #"
puts "#############################################"
set app_name "zybo_standalone_fsbl"
set template "Zynq FSBL"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 


puts "#############################################"
puts "# Create Standalone Dhrystone               #"
puts "#############################################"
set app_name "zybo_standalone_dyhrstone"
set template "Dhrystone"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

puts "#############################################"
puts "# Create Standalone Memtest                 #"
puts "#############################################"
set app_name "zybo_standalone_memtest"
set template "Memory Tests"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

puts "#############################################"
puts "# Create Standalone DRAM Tests              #"
puts "#############################################"
set app_name "zybo_standalone_dram_test"
set template "Zynq DRAM tests"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

puts "#############################################"
puts "# Create Standalone empty App               #"
puts "#############################################"
set app_name "zybo_standalone_empty"
set template "Empty Application"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

set domain "zybo_bsp_freertos"
set platform "zybo_platform"
puts "#############################################"
puts "# Create FreeRTOS Echo Server               #"
puts "#############################################"
set app_name "zybo_freertos_echo_server"
set template "FreeRTOS lwIP Echo Server"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

puts "#############################################"
puts "# Create FreeRTOS UDP Perf Server           #"
puts "#############################################"
set app_name "zybo_freertos_udp_perf_server"
set template "FreeRTOS lwIP UDP Perf Server"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

puts "#############################################"
puts "# Create FreeRTOS TCP Perf Server           #"
puts "#############################################"
set app_name "zybo_freertos_tcp_perf_server"
set template "FreeRTOS lwIP TCP Perf Server"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 


puts "#############################################"
puts "# Create FreeRTOS Hello World               #"
puts "#############################################"
set app_name "zybo_freertos_hello"
set template "FreeRTOS Hello World"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

puts "#############################################"
puts "# Build All                                 #"
puts "#############################################"
app build -all
