----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:27:57 12/03/2018 
-- Design Name: 
-- Module Name:    TestLoadFlashVGA - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestLoadFlashVGA is
	port(
		
		display_Data_out: out std_logic_vector(15 downto 0);
		  clk       : in  std_logic;
		  rst       : in  std_logic;
		  Rs        : out std_logic_vector(2 downto 0);
		  Gs        : out std_logic_vector(2 downto 0);
		  Bs        : out std_logic_vector(2 downto 0);
		  Hs        : out std_logic;
		  Vs        : out std_logic;
		  
		  
  flash_byte         : out std_logic;
  flash_vpen         : out std_logic;
  flash_ce           : out std_logic;
  flash_oe           : out std_logic;
  flash_we           : out std_logic;
  flash_rp           : out std_logic;
  flash_addr         : out std_logic_vector(22 downto 0);
  flash_data         : inout std_logic_vector(15 downto 0);
  
  
  se_wrn_o            : out std_logic;
  se_rdn_o            : out std_logic;
  se_tbre_i           : in  std_logic;
  se_tsre_i           : in  std_logic;
  se_data_ready_i     : in  std_logic;
  
  
  Ram1Addr            : out std_logic_vector(17 downto 0);
  Ram1Data            : inout std_logic_vector(15 downto 0);
  Ram1OE              : out std_logic;
  Ram1WE              : out std_logic;
  Ram1EN              : out std_logic;
  Ram2Addr            : out std_logic_vector(17 downto 0);
  Ram2Data            : inout std_logic_vector(15 downto 0);
  Ram2OE              : out std_logic;
  Ram2WE              : out std_logic;
  Ram2EN              : out std_logic
	);
end TestLoadFlashVGA;

architecture Behavioral of TestLoadFlashVGA is
component INST_ROM
port (
  serial_rw_install_o:out std_logic;	----serial write install 
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
  Ram2Addr            : out std_logic_vector(17 downto 0);
  Ram2Data            : inout std_logic_vector(15 downto 0);
  Ram2OE              : out std_logic;
  Ram2WE              : out std_logic;
  Ram2EN              : out std_logic;
  FlashLoadComplete_o : out std_logic;
  Flash_clk2          : in  std_logic;
  FlashAddr_o         : out std_logic_vector(22 downto 0);
  FlashData_i         : in  std_logic_vector(15 downto 0);
  VGAAddr_char        : in  std_logic_vector(17 downto 0);
  VGAData_char        : out std_logic_vector(15 downto 0);
  se_wrn_o            : out std_logic;
  se_rdn_o            : out std_logic;
  se_tbre_i           : in  std_logic;
  se_tsre_i           : in  std_logic;
  se_data_ready_i     : in  std_logic
);
end component INST_ROM;
component FLASH
port (
  clk                : in  std_logic;
  FlashLoad_Complete : in  std_logic;
  Flash_clk2         : out std_logic;
  rst                : in  std_logic;
  RAMAddr_i          : in  std_logic_vector(22 downto 0);
  VGAAddr_i          : in  std_logic_vector(22 downto 0);
  FlashData_o        : out std_logic_vector(15 downto 0);
  flash_byte         : out std_logic;
  flash_vpen         : out std_logic;
  flash_ce           : out std_logic;
  flash_oe           : out std_logic;
  flash_we           : out std_logic;
  flash_rp           : out std_logic;
  flash_addr         : out std_logic_vector(22 downto 0);
  flash_data         : inout std_logic_vector(15 downto 0)
);
end component FLASH;
component VGA_CTRL
port (
  VGAAddr_o : out std_logic_vector(22 downto 0);
  VGAData_i : in  std_logic_vector(15 downto 0);
  clk       : in  std_logic;
  rst       : in  std_logic;
  Rs        : out std_logic_vector(2 downto 0);
  Gs        : out std_logic_vector(2 downto 0);
  Bs        : out std_logic_vector(2 downto 0);
  Hs        : out std_logic;
  Vs        : out std_logic
);
end component VGA_CTRL;
signal serial_rw_install_o : std_logic;
signal id_addr_i           : std_logic_vector (15 downto 0);
signal id_succ_o           : std_logic;
signal id_inst_o           : std_logic_vector (15 downto 0);
signal mem_wr_i            : std_logic;
signal mem_rd_i            : std_logic;
signal mem_addr_i          : std_logic_vector(15 downto 0);
signal mem_wdata_i         : std_logic_vector(15 downto 0);
signal mem_rdata_o         : std_logic_vector(15 downto 0);

signal FlashLoadComplete_o : std_logic;
signal Flash_clk2          : std_logic;
signal FlashAddr_o         : std_logic_vector(22 downto 0);
signal VGAAddr_o         : std_logic_vector(22 downto 0);
signal FlashData_o         : std_logic_vector(15 downto 0);
signal VGAData_i         : std_logic_vector(15 downto 0);
signal VGAAddr_char        : std_logic_vector(17 downto 0);
signal VGAData_char        : std_logic_vector(15 downto 0);

begin
VGAData_i<=FlashData_o;
display_Data_out<=VGAAddr_o(16 downto 1);

INST_ROM_i : INST_ROM
port map (
	serial_rw_install_o=>serial_rw_install_o,
  clk                 => clk,
  rst                 => rst,
  id_addr_i           => id_addr_i,
  id_succ_o           => id_succ_o,
  id_inst_o           => id_inst_o,
  mem_wr_i            => mem_wr_i,
  mem_rd_i            => mem_rd_i,
  mem_addr_i          => mem_addr_i,
  mem_wdata_i         => mem_wdata_i,
  mem_rdata_o         => mem_rdata_o,
  Ram1Addr            => Ram1Addr,
  Ram1Data            => Ram1Data,
  Ram1OE              => Ram1OE,
  Ram1WE              => Ram1WE,
  Ram1EN              => Ram1EN,
  Ram2Addr            => Ram2Addr,
  Ram2Data            => Ram2Data,
  Ram2OE              => Ram2OE,
  Ram2WE              => Ram2WE,
  Ram2EN              => Ram2EN,
  FlashLoadComplete_o => FlashLoadComplete_o,
  Flash_clk2          => Flash_clk2,
  FlashAddr_o         => FlashAddr_o,
  FlashData_i         => FlashData_o,
  VGAAddr_char        => VGAAddr_char,
  VGAData_char        => VGAData_char,
  se_wrn_o            => se_wrn_o,
  se_rdn_o            => se_rdn_o,
  se_tbre_i           => se_tbre_i,
  se_tsre_i           => se_tsre_i,
  se_data_ready_i     => se_data_ready_i
);


FLASH_i : FLASH
port map (
  clk                => clk,
  FlashLoad_Complete => FlashLoadComplete_o,
  Flash_clk2         => Flash_clk2,
  rst                => rst,
  RAMAddr_i          => FlashAddr_o,
  VGAAddr_i          => VGAAddr_o,
  FlashData_o        => FlashData_o,
  flash_byte         => flash_byte,
  flash_vpen         => flash_vpen,
  flash_ce           => flash_ce,
  flash_oe           => flash_oe,
  flash_we           => flash_we,
  flash_rp           => flash_rp,
  flash_addr         => flash_addr,
  flash_data         => flash_data
);

VGA_CTRL_i : VGA_CTRL
port map (
  VGAAddr_o => VGAAddr_o,
  VGAData_i => VGAData_i,
  clk       => clk,
  rst       => rst,
  Rs        => Rs,
  Gs        => Gs,
  Bs        => Bs,
  Hs        => Hs,
  Vs        => Vs
);

end Behavioral;

