source ./common.tcl
read_checkpoint $PROJ_DIR/${PROJ_NAME}_post_route.dcp
open_checkpoint $PROJ_DIR/${PROJ_NAME}_post_route.dcp
write_bitstream -force $PROJ_DIR/${PROJ_NAME}.bit
write_hw_platform -fixed -include_bit -force -file $PROJ_DIR/${PROJ_NAME}.xsa

