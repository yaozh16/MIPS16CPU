----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:37:05 12/03/2018 
-- Design Name: 
-- Module Name:    Combination - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Combination is
    port(
    clk                 : in  std_logic;
    rst                 : in  std_logic;
	 display_o			   : out std_logic_vector(15 downto 0);
    Ram1Addr            : out std_logic_vector(17 downto 0);
    Ram1Data            : inout std_logic_vector(15 downto 0);
    Ram1OE              : out std_logic;
    Ram1WE              : out std_logic;
    Ram1EN              : out std_logic;
    se_wrn_o            : out std_logic;
    se_rdn_o            : out std_logic;
    se_tbre_i           : in  std_logic;
    se_tsre_i           : in  std_logic;
    se_data_ready_i     : in  std_logic
    );
end Combination;

architecture Behavioral of Combination is

component INST_ROM
port (
  serial_rw_install_o : out std_logic;
  clk                 : in  std_logic;
  rst                 : in  std_logic;
  id_addr_i           : in  std_logic_vector (15 downto 0);
  id_succ_o           : out std_logic;
  id_inst_o           : out std_logic_vector (15 downto 0);
  mem_wr_i            : in  std_logic;
  mem_rd_i            : in  std_logic;
  mem_addr_i          : in  std_logic_vector(15 downto 0);
  mem_wdata_i         : in  std_logic_vector(15 downto 0);
  mem_rdata_o         : out std_logic_vector(15 downto 0);
  Ram1Addr            : out std_logic_vector(17 downto 0);
  Ram1Data            : inout std_logic_vector(15 downto 0);
  Ram1OE              : out std_logic;
  Ram1WE              : out std_logic;
  Ram1EN              : out std_logic;
  FlashLoadComplete_o : out std_logic;
  Flash_clk2          : in  std_logic;
  FlashAddr_o         : out std_logic_vector(22 downto 0);
  FlashData_i         : in  std_logic_vector(15 downto 0);
  se_wrn_o            : out std_logic;
  se_rdn_o            : out std_logic;
  se_tbre_i           : in  std_logic;
  se_tsre_i           : in  std_logic;
  se_data_ready_i     : in  std_logic
);
end component INST_ROM;
signal serial_rw_install_o : std_logic;
---signal clk                 : std_logic;
---signal rst                 : std_logic;
------signal id_addr_i           : std_logic_vector (15 downto 0);
------signal id_succ_o           : std_logic;
------signal id_inst_o           : std_logic_vector (15 downto 0);
------signal mem_wr_i            : std_logic;
------signal mem_rd_i            : std_logic;
------signal mem_addr_i          : std_logic_vector(15 downto 0);
------signal mem_wdata_i         : std_logic_vector(15 downto 0);
------signal mem_rdata_o         : std_logic_vector(15 downto 0);
--signal Ram1Addr            : std_logic_vector(17 downto 0);
--signal Ram1Data            : std_logic_vector(15 downto 0);
--signal Ram1OE              : std_logic;
--signal Ram1WE              : std_logic;
--signal Ram1EN              : std_logic;
signal FlashLoadComplete_o : std_logic;   ---not used
signal Flash_clk2          : std_logic;   ---not used
signal FlashAddr_o         : std_logic_vector(22 downto 0); --not used
signal FlashData_i         : std_logic_vector(15 downto 0); --not used
---signal se_wrn_o            : std_logic;
---signal se_rdn_o            : std_logic;
---signal se_tbre_i           : std_logic;
---signal se_tsre_i           : std_logic;
---signal se_data_ready_i     : std_logic;



component CPU
port (
  clk                  : in  std_logic;
  rst                  : in  std_logic;
  se_rw_stall_i        : in  std_logic;
  display_o            : out std_logic_vector(15 downto 0);
  id_addr_i_INST_ROM   : out std_logic_vector (15 downto 0);
  id_inst_o_INST_ROM   : in  std_logic_vector(15 downto 0);
  id_succ_o_INST_ROM   : in  std_logic;
  mem_wr_i_INST_ROM    : out std_logic;
  mem_rd_i_INST_ROM    : out std_logic;
  mem_addr_i_INST_ROM  : out std_logic_vector(15 downto 0);
  mem_wdata_i_INST_ROM : out std_logic_vector(15 downto 0);
  mem_rdata_o_INST_ROM : in  std_logic_vector(15 downto 0)
);
end component CPU;
--signal clk                  : std_logic;
--signal rst                  : std_logic;
-------signal se_rw_stall_i        : std_logic;
signal id_addr_i_INST_ROM   : std_logic_vector (15 downto 0);
signal id_inst_o_INST_ROM   : std_logic_vector(15 downto 0);
signal id_succ_o_INST_ROM   : std_logic;
signal mem_wr_i_INST_ROM    : std_logic;
signal mem_rd_i_INST_ROM    : std_logic;
signal mem_addr_i_INST_ROM  : std_logic_vector(15 downto 0);
signal mem_wdata_i_INST_ROM : std_logic_vector(15 downto 0);
signal mem_rdata_o_INST_ROM : std_logic_vector(15 downto 0);


signal display_CPU : std_logic_vector(15 downto 0);

begin
  
  display_o<=display_CPU;
  INST_ROM_i : INST_ROM
  port map (
    serial_rw_install_o => serial_rw_install_o,
    clk                 => clk,
    rst                 => rst,
    id_addr_i           => id_addr_i_INST_ROM,---id_addr_i,
    id_succ_o           => id_succ_o_INST_ROM,---id_succ_o,
    id_inst_o           => id_inst_o_INST_ROM,---id_inst_o,
    mem_wr_i            => mem_wr_i_INST_ROM,---mem_wr_i
    mem_rd_i            => mem_rd_i_INST_ROM,---mem_rd_i
    mem_addr_i          => mem_addr_i_INST_ROM,---mem_addr_i
    mem_wdata_i         => mem_wdata_i_INST_ROM,---mem_wdata_i
    mem_rdata_o         => mem_rdata_o_INST_ROM,---mem_rdata_o
    Ram1Addr            => Ram1Addr,
    Ram1Data            => Ram1Data,
    Ram1OE              => Ram1OE,
    Ram1WE              => Ram1WE,
    Ram1EN              => Ram1EN,
    FlashLoadComplete_o => FlashLoadComplete_o,
    Flash_clk2          => Flash_clk2,
    FlashAddr_o         => FlashAddr_o,
    FlashData_i         => FlashData_i,
    se_wrn_o            => se_wrn_o,
    se_rdn_o            => se_rdn_o,
    se_tbre_i           => se_tbre_i,
    se_tsre_i           => se_tsre_i,
    se_data_ready_i     => se_data_ready_i
  );

  CPU_i : CPU
  port map (
    clk                  => clk,
    rst                  => rst,
    se_rw_stall_i        => serial_rw_install_o,---se_rw_stall_i,
    display_o            => display_CPU,
    id_addr_i_INST_ROM   => id_addr_i_INST_ROM,
    id_inst_o_INST_ROM   => id_inst_o_INST_ROM,
    id_succ_o_INST_ROM   => id_succ_o_INST_ROM,
    mem_wr_i_INST_ROM    => mem_wr_i_INST_ROM,
    mem_rd_i_INST_ROM    => mem_rd_i_INST_ROM,
    mem_addr_i_INST_ROM  => mem_addr_i_INST_ROM,
    mem_wdata_i_INST_ROM => mem_wdata_i_INST_ROM,
    mem_rdata_o_INST_ROM => mem_rdata_o_INST_ROM
  );

end Behavioral;

