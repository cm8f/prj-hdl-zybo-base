LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE project_config_pkg IS 

  CONSTANT p_bd_ps_only         : INTEGER := 0;
  CONSTANT p_bd_grd             : INTEGER := 1;
  CONSTANT p_config_bd_version  : INTEGER := p_bd_ps_only;

  CONSTANT p_use_hdmi           : INTEGER RANGE 0 TO 1 := 0;
  CONSTANT p_use_pmod_a         : INTEGER RANGE 0 TO 1 := 0;
  CONSTANT p_use_pmod_b         : INTEGER RANGE 0 TO 1 := 0;
  CONSTANT p_use_pmod_c         : INTEGER RANGE 0 TO 1 := 0;
  CONSTANT p_use_pmod_d         : INTEGER RANGE 0 TO 1 := 0;
  CONSTANT p_use_pmod_e         : INTEGER RANGE 0 TO 1 := 0;
END PACKAGE;
