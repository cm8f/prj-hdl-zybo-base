--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
--Date        : Sun Sep 26 13:58:29 2021
--Host        : phobos running 64-bit EndeavourOS Linux
--Command     : generate_target base_system_wrapper.bd
--Design      : base_system_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
USE WORK.project_config_pkg.ALL;
entity top_level is
  port (
    -- ddr
    DDR_addr          : INOUT STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba            : INOUT STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n         : INOUT STD_LOGIC;
    DDR_ck_n          : INOUT STD_LOGIC;
    DDR_ck_p          : INOUT STD_LOGIC;
    DDR_cke           : INOUT STD_LOGIC;
    DDR_cs_n          : INOUT STD_LOGIC;
    DDR_dm            : INOUT STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq            : INOUT STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n         : INOUT STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p         : INOUT STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt           : INOUT STD_LOGIC;
    DDR_ras_n         : INOUT STD_LOGIC;
    DDR_reset_n       : INOUT STD_LOGIC;
    DDR_we_n          : INOUT STD_LOGIC;
    -- fixed io
    FIXED_IO_ddr_vrn  : INOUT STD_LOGIC;
    FIXED_IO_ddr_vrp  : INOUT STD_LOGIC;
    FIXED_IO_mio      : INOUT STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk   : INOUT STD_LOGIC;
    FIXED_IO_ps_porb  : INOUT STD_LOGIC;
    FIXED_IO_ps_srstb : INOUT STD_LOGIC;
    -- i2s
    AC_BCLK           : OUT   STD_LOGIC_VECTOR ( 0 to 0 );
    AC_MCLK           : OUT   STD_LOGIC;
    AC_MUTE_N         : OUT   STD_LOGIC_VECTOR ( 0 to 0 );
    AC_PBLRC          : OUT   STD_LOGIC_VECTOR ( 0 to 0 );
    AC_RECLRC         : OUT   STD_LOGIC_VECTOR ( 0 to 0 );
    AC_SDATA_I        : IN    STD_LOGIC;
    AC_SDATA_O        : OUT   STD_LOGIC_VECTOR ( 0 to 0 );
    -- vga
    RED_O             : OUT   STD_LOGIC_VECTOR ( 4 downto 0 );
    BLUE_O            : OUT   STD_LOGIC_VECTOR ( 4 downto 0 );
    GREEN_O           : OUT   STD_LOGIC_VECTOR ( 5 downto 0 );
    HSYNC_O           : OUT   STD_LOGIC;
    VSYNC_O           : OUT   STD_LOGIC;
    -- hdmi
    HDMI_CLK_N        : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0);
    HDMI_CLK_P        : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0);
    HDMI_D0_N         : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0);
    HDMI_D0_P         : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0);
    HDMI_D1_N         : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0);
    HDMI_D1_P         : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0);
    HDMI_D2_N         : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0);
    HDMI_D2_P         : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0);
    HDMI_OEN          : OUT   STD_LOGIC_VECTOR(p_use_hdmi*1-1 DOWNTO 0 );
    -- i2c
    IIC_0_scl_io      : INOUT STD_LOGIC;
    IIC_0_sda_io      : INOUT STD_LOGIC;
    -- user io
    LEDs_4Bits_tri_o  : OUT   STD_LOGIC_VECTOR ( 3 downto 0 );
    SWs_4Bits_tri_i   : IN    STD_LOGIC_VECTOR ( 3 downto 0 );
    BTNs_4Bits_tri_i  : IN    STD_LOGIC_VECTOR ( 3 downto 0 );
    -- pmods
    io_pmod_ja        : INOUT STD_LOGIC_VECTOR(p_use_pmod_a*8-1 DOWNTO 0);
    io_pmod_jb        : INOUT STD_LOGIC_VECTOR(p_use_pmod_b*8-1 DOWNTO 0);
    io_pmod_jc        : INOUT STD_LOGIC_VECTOR(p_use_pmod_c*8-1 DOWNTO 0);
    io_pmod_jd        : INOUT STD_LOGIC_VECTOR(p_use_pmod_d*8-1 DOWNTO 0);
    io_pmod_je        : INOUT STD_LOGIC_VECTOR(p_use_pmod_e*8-1 DOWNTO 0)
  );
end top_level;

architecture STRUCTURE of top_level is

  component system_grd is
  port (
    AC_SDATA_I : in STD_LOGIC;
    BLUE_O : out STD_LOGIC_VECTOR ( 4 downto 0 );
    GREEN_O : out STD_LOGIC_VECTOR ( 5 downto 0 );
    HSYNC_O : out STD_LOGIC;
    RED_O : out STD_LOGIC_VECTOR ( 4 downto 0 );
    VSYNC_O : out STD_LOGIC;
    AC_BCLK : out STD_LOGIC_VECTOR ( 0 to 0 );
    AC_PBLRC : out STD_LOGIC_VECTOR ( 0 to 0 );
    AC_RECLRC : out STD_LOGIC_VECTOR ( 0 to 0 );
    AC_MUTE_N : out STD_LOGIC_VECTOR ( 0 to 0 );
    AC_SDATA_O : out STD_LOGIC_VECTOR ( 0 to 0 );
    HDMI_CLK_N : out STD_LOGIC;
    HDMI_CLK_P : out STD_LOGIC;
    HDMI_D0_N : out STD_LOGIC;
    HDMI_D0_P : out STD_LOGIC;
    HDMI_D1_N : out STD_LOGIC;
    HDMI_D1_P : out STD_LOGIC;
    HDMI_D2_N : out STD_LOGIC;
    HDMI_D2_P : out STD_LOGIC;
    AC_MCLK : out STD_LOGIC;
    HDMI_OEN : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    LEDs_4Bits_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SWs_4Bits_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    IIC_0_sda_i : in STD_LOGIC;
    IIC_0_sda_o : out STD_LOGIC;
    IIC_0_sda_t : out STD_LOGIC;
    IIC_0_scl_i : in STD_LOGIC;
    IIC_0_scl_o : out STD_LOGIC;
    IIC_0_scl_t : out STD_LOGIC;
    BTNs_4Bits_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component system_grd;

  component base_system_ps_only is
  port (
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    IIC_0_sda_i : in STD_LOGIC;
    IIC_0_sda_o : out STD_LOGIC;
    IIC_0_sda_t : out STD_LOGIC;
    IIC_0_scl_i : in STD_LOGIC;
    IIC_0_scl_o : out STD_LOGIC;
    IIC_0_scl_t : out STD_LOGIC
  );
  end component base_system_ps_only;

  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;

  signal IIC_0_scl_i : STD_LOGIC;
  signal IIC_0_scl_o : STD_LOGIC;
  signal IIC_0_scl_t : STD_LOGIC;
  signal IIC_0_sda_i : STD_LOGIC;
  signal IIC_0_sda_o : STD_LOGIC;
  signal IIC_0_sda_t : STD_LOGIC;

begin
IIC_0_scl_iobuf: component IOBUF
     port map (
      I => IIC_0_scl_o,
      IO => IIC_0_scl_io,
      O => IIC_0_scl_i,
      T => IIC_0_scl_t
    );
IIC_0_sda_iobuf: component IOBUF
     port map (
      I => IIC_0_sda_o,
      IO => IIC_0_sda_io,
      O => IIC_0_sda_i,
      T => IIC_0_sda_t
    );

gen_bd_ps_only : IF p_config_bd_version = p_bd_ps_only GENERATE
  inst_ps_only: COMPONENT base_system_ps_only
       PORT MAP (
        DDR_addr(14 downto 0)       => DDR_addr(14 downto 0),
        DDR_ba(2 downto 0)          => DDR_ba(2 downto 0),
        DDR_cas_n                   => DDR_cas_n,
        DDR_ck_n                    => DDR_ck_n,
        DDR_ck_p                    => DDR_ck_p,
        DDR_cke                     => DDR_cke,
        DDR_cs_n                    => DDR_cs_n,
        DDR_dm(3 downto 0)          => DDR_dm(3 downto 0),
        DDR_dq(31 downto 0)         => DDR_dq(31 downto 0),
        DDR_dqs_n(3 downto 0)       => DDR_dqs_n(3 downto 0),
        DDR_dqs_p(3 downto 0)       => DDR_dqs_p(3 downto 0),
        DDR_odt                     => DDR_odt,
        DDR_ras_n                   => DDR_ras_n,
        DDR_reset_n                 => DDR_reset_n,
        DDR_we_n                    => DDR_we_n,
        FIXED_IO_ddr_vrn            => FIXED_IO_ddr_vrn,
        FIXED_IO_ddr_vrp            => FIXED_IO_ddr_vrp,
        FIXED_IO_mio(53 downto 0)   => FIXED_IO_mio(53 downto 0),
        FIXED_IO_ps_clk             => FIXED_IO_ps_clk,
        FIXED_IO_ps_porb            => FIXED_IO_ps_porb,
        FIXED_IO_ps_srstb           => FIXED_IO_ps_srstb,
        IIC_0_scl_i                 => IIC_0_scl_i,
        IIC_0_scl_o                 => IIC_0_scl_o,
        IIC_0_scl_t                 => IIC_0_scl_t,
        IIC_0_sda_i                 => IIC_0_sda_i,
        IIC_0_sda_o                 => IIC_0_sda_o,
        IIC_0_sda_t                 => IIC_0_sda_t
      );
END GENERATE;

gen_bd_grd : IF p_config_bd_version = p_bd_grd GENERATE 
  inst_grd: COMPONENT system_grd
     port map (
      AC_BCLK(0)                    => AC_BCLK(0),
      AC_MCLK                       => AC_MCLK,
      AC_MUTE_N(0)                  => AC_MUTE_N(0),
      AC_PBLRC(0)                   => AC_PBLRC(0),
      AC_RECLRC(0)                  => AC_RECLRC(0),
      AC_SDATA_I                    => AC_SDATA_I,
      AC_SDATA_O(0)                 => AC_SDATA_O(0),
      BLUE_O(4 downto 0)            => BLUE_O(4 downto 0),
      BTNs_4Bits_tri_i(3 downto 0)  => BTNs_4Bits_tri_i(3 downto 0),
      DDR_addr(14 downto 0)         => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0)            => DDR_ba(2 downto 0),
      DDR_cas_n                     => DDR_cas_n,
      DDR_ck_n                      => DDR_ck_n,
      DDR_ck_p                      => DDR_ck_p,
      DDR_cke                       => DDR_cke,
      DDR_cs_n                      => DDR_cs_n,
      DDR_dm(3 downto 0)            => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0)           => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0)         => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0)         => DDR_dqs_p(3 downto 0),
      DDR_odt                       => DDR_odt,
      DDR_ras_n                     => DDR_ras_n,
      DDR_reset_n                   => DDR_reset_n,
      DDR_we_n                      => DDR_we_n,
      FIXED_IO_ddr_vrn              => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp              => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0)     => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk               => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb              => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb             => FIXED_IO_ps_srstb,
      GREEN_O(5 downto 0)           => GREEN_O(5 downto 0),
      HDMI_CLK_N                    => HDMI_CLK_N(0),
      HDMI_CLK_P                    => HDMI_CLK_P(0),
      HDMI_D0_N                     => HDMI_D0_N(0),
      HDMI_D0_P                     => HDMI_D0_P(0),
      HDMI_D1_N                     => HDMI_D1_N(0),
      HDMI_D1_P                     => HDMI_D1_P(0),
      HDMI_D2_N                     => HDMI_D2_N(0),
      HDMI_D2_P                     => HDMI_D2_P(0),
      HDMI_OEN(0)                   => HDMI_OEN(0),
      HSYNC_O                       => HSYNC_O,
      IIC_0_scl_i                   => IIC_0_scl_i,
      IIC_0_scl_o                   => IIC_0_scl_o,
      IIC_0_scl_t                   => IIC_0_scl_t,
      IIC_0_sda_i                   => IIC_0_sda_i,
      IIC_0_sda_o                   => IIC_0_sda_o,
      IIC_0_sda_t                   => IIC_0_sda_t,
      LEDs_4Bits_tri_o(3 downto 0)  => LEDs_4Bits_tri_o(3 downto 0),
      RED_O(4 downto 0)             => RED_O(4 downto 0),
      SWs_4Bits_tri_i(3 downto 0)   => SWs_4Bits_tri_i(3 downto 0),
      VSYNC_O                       => VSYNC_O
    );
END GENERATE;

  io_pmod_ja <= (OTHERS => 'Z');
  io_pmod_jb <= (OTHERS => 'Z');
  io_pmod_jc <= (OTHERS => 'Z');
  io_pmod_jd <= (OTHERS => 'Z');
  io_pmod_je <= (OTHERS => 'Z');

end STRUCTURE;
