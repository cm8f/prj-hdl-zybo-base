set BUILD_DATE [ clock format [ clock seconds ] -format %Y%m%d]
set BUILD_TIME [ clock format [ clock seconds ] -format %H%M%S]

# Global Settings
set PROJ_NAME "zybo_base_system"
set PROJ_DIR  "./$PROJ_NAME"
set PART_NAME "xc7z010clg400-1"

if { ![file exists $PROJ_DIR ]} {
  file mkdir $PROJ_DIR
}

