  namespace eval misc {
    # ######################################
    # get build date in human readable format
    # ######################################
    proc build_date_ymd {} {
      set BUILD_DATE [ clock format [ clock seconds ] -format %Y%m%d]
      return $BUILD_DATE
    }

    # ######################################
    # get build time in human readable format
    # ######################################
    proc build_time_hms {} {
      set BUILD_TIME [ clock format [ clock seconds ] -format %H%M%S]
      return $BUILD_TIME
    }

    # ######################################
    # convert build time to hex
    # param str: return value of build_time_hms/build_date_ymd
    # ######################################
    proc build_date_time_hex { str } {
      set timestamp_out [format "%08X" $str]
      return $timestamp_out
    }
    
    # ######################################
    # get git revision
    # ######################################
    proc git_revision { } {
      # The Maximum number of seconds
      set cmd "git rev-parse --short=8 HEAD"
      if {[catch {open "|$cmd"} input] } {
        return -code error $input
      } else {
        gets $input line
        set git_hash $line
        close $input
      }
      return $git_hash
    }
  }
