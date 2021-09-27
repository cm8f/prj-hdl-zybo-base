setws ./

set script [info script] 
set script_dir [file normalize [file dirname $script]]
puts "INFO: Running $script"

set lang "c"
set arch "32-bit"

puts "#############################################"
puts "# Create HW Platform                        #"
puts "#############################################"
set hw_src [lindex [glob -nocomplain $script_dir/../*.xsa] 0]
puts "INFO: Found $hw_src"
set hw_name "zybo_platform"
platform create -name "$hw_name" -hw "$hw_src"
platform active "zybo_platform"

puts "#############################################"
puts "# Create FreeRTOS BSP                       #"
puts "#############################################"
set domain_name "zybo_bsp_freertos"
set os "freertos10_xilinx"
set proc "ps7_cortexa9_1"
domain create -name $domain_name -proc $proc -arch $arch -os $os
platform generate

set domain "zybo_bsp_freertos"
set platform "zybo_platform"
puts "#############################################"
puts "# Create FreeRTOS Hello World               #"
puts "#############################################"
set app_name "zybo_freertos_hello"
set template "FreeRTOS Hello World"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

puts "#############################################"
puts "# Create FreeRTOS Empty                     #"
puts "#############################################"
set app_name "zybo_freertos_empty"
set template "Empty Application"
app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

#puts "#############################################"
#puts "# Create FreeRTOS Echo Server               #"
#puts "#############################################"
#set app_name "zybo_freertos_echo_server"
#set template "FreeRTOS lwIP Echo Server"
#app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

#puts "#############################################"
#puts "# Create FreeRTOS UDP Perf Server           #"
#puts "#############################################"
#set app_name "zybo_freertos_udp_perf_server"
#set template "FreeRTOS lwIP UDP Perf Server"
#app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

#puts "#############################################"
#puts "# Create FreeRTOS TCP Perf Server           #"
#puts "#############################################"
#set app_name "zybo_freertos_tcp_perf_server"
#set template "FreeRTOS lwIP TCP Perf Server"
#app create -name $app_name -lang $lang -template $template -domain $domain -platform $platform 

