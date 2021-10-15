namespace eval version {
  # ######################################
  # create initial version file
  # param f: file to create (example ../workspace/version_${revision}_pkg.vhd
  # ######################################
  proc create_file { f } {
    set fid [open $f "w"]
    puts $fid "LIBRARY IEEE;"
    puts $fid "USE IEEE.STD_LOGIC_1164.ALL;"
    puts $fid "USE IEEE.NUMERIC_STD.ALL;\n"
    puts $fid "PACKAGE version_pkg IS"
    puts $fid "  CONSTANT p_build_number    : STD_LOGIC_VECTOR(31 DOWNTO 0) := x\"00000000\";"
    puts $fid "  CONSTANT p_build_date      : STD_LOGIC_VECTOR(31 DOWNTO 0) := x\"00000000\";"
    puts $fid "  CONSTANT p_build_time      : STD_LOGIC_VECTOR(31 DOWNTO 0) := x\"00000000\";"
    puts $fid "  CONSTANT p_build_git_rev   : STD_LOGIC_VECTOR(31 DOWNTO 0) := x\"00000000\";"
    puts $fid "END PACKAGE version_pkg;"
    close $fid
  }

  proc update_version_number { input_file output_file build_date build_time git_rev} { 
    #return error if input file cannot be opended
    if { [catch {open $input_file} input ] } {
      return -code error $input
    } 
    puts "Opened input file"
    #return error if output file cannot be opened
    if { [catch {open $output_file w} output ] } {
      return -code error $output 
    }
  
  
    while {-1 != [gets $input line] } {
      if { [regexp {p_build_number.* x\"([[:xdigit:]]+)\"} $line match buildnumber ] } {
        puts "buildnumber found"
        scan $buildnumber "%x" decimal_value
        incr decimal_value
        set new_build_number [format "%08X" $decimal_value]
        regsub ${buildnumber} $line ${new_build_number} line
      } 
      if { [regexp {p_build_git_rev.* x\"([[:xdigit:]]+)\"} $line match gitversion ] } {
        puts "gitrevision found"
        regsub ${gitversion} $line ${git_rev} line
      } 
      if { [regexp {p_build_date.* x\"([[:xdigit:]]+)\"} $line match timestamp] } {
        puts "date found"
        regsub ${timestamp} $line $build_date line 
      }
      if { [regexp {p_build_time.* x\"([[:xdigit:]]+)\"} $line match timestamp] } {
        puts "time found"
        regsub ${timestamp} $line $build_time line 
      }
      puts $output $line
    }
    close $input
    close $output
  }

  # ######################################
  # update version file 
  # param: fname:       file name to update 
  # param: build_date:  current date 
  # param: build_time:  current time
  # param: git_rev:     current git revision
  # ######################################
  proc update_file { fname build_date build_time git_rev } {
    set input_file [file normalize $fname]
    set output_file [file normalize "${fname}.updated"]

    if { [catch { update_version_number $input_file $output_file $build_date $build_time $git_rev } res ] } {
      puts "$res"
    } else {
      puts "version update done"
      if { [catch { file rename -force $output_file $input_file } res ] } {
        puts "$res"
      }
    }
  }

  proc version { wrkdir prj bdate btime rev } {

    set version_file_name [file normalize "${wrkdir}/${prj}_build_pkg.vhd"]
    puts "version file name is $version_file_name"

    if { ![file exists $version_file_name] } {
      puts "file does not exist"
      create_file $version_file_name
      update_file $version_file_name $bdate $btime $rev 
    } else {
      puts "file exists. updateing..."
      update_file $version_file_name $bdate $btime $rev 
    }
  }

}
