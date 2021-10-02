LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE project_config_pkg IS 

  CONSTANT p_bd_ps_only         : INTEGER := 0;
  CONSTANT p_bd_grd             : INTEGER := 1;
  CONSTANT p_config_bd_version  : INTEGER := p_bd_grd;

END PACKAGE;
