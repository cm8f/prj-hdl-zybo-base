set scriptdir [file dirname [ dict get [ info frame 0 ] file ] ]


namespace eval build_lib {
  source $scriptdir/lib_misc.tcl
  source $scriptdir/lib_version.tcl
  source $scriptdir/lib_xil_syn.tcl


}
