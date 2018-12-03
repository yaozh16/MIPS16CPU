----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:36:44 12/03/2018 
-- Design Name: 
-- Module Name:    TestLoadFlash - Behavioral 
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
use WORK.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestLoadFlash is
	port(
		clk,rst: in std_logic;
		control_Addr_in: in std_logic_vector(15 downto 0);
		display_Data_out: out std_logic_vector(15 downto 0);
		
		
		
		flash_byte : out std_logic;
		flash_vpen : out std_logic;
		flash_ce : out std_logic;
		flash_oe : out std_logic;				---ce0
		flash_we : out std_logic;
		flash_rp : out std_logic;
		flash_addr : out std_logic_vector(22 downto 0);
		flash_data : inout std_logic_vector(15 downto 0);
		
		
		Ram1Addr            : out std_logic_vector(17 downto 0);
		Ram1Data            : inout std_logic_vector(15 downto 0);
		Ram1OE              : out std_logic;
		Ram1WE              : out std_logic;
      Ram1EN              : out std_logic;
		
		
		se_wrn_o            : out std_logic;
		se_rdn_o            : out std_logic
	);
end TestLoadFlash;

architecture Behavioral of TestLoadFlash is
component INST_ROM
port (
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

signal FlashLoad_Complete : std_logic;
signal Flash_clk2         : std_logic;
signal RAMAddr_i          : std_logic_vector(22 downto 0);
signal VGAAddr_i          : std_logic_vector(22 downto 0);
signal FlashData_o        : std_logic_vector(15 downto 0);

---INST_ROM
signal id_succ_o           : std_logic:='0';
signal id_inst_o           : std_logic_vector (15 downto 0);
signal mem_wr_i            : std_logic:='0';
signal mem_rd_i            : std_logic:='0';
signal mem_wdata_i         : std_logic_vector(15 downto 0);
signal mem_rdata_o         : std_logic_vector(15 downto 0);
signal FlashAddr_o         : std_logic_vector(22 downto 0);
signal FlashData_i         : std_logic_vector(15 downto 0);
signal VGAAddr_char        : std_logic_vector(17 downto 0);
signal VGAData_char        : std_logic_vector(15 downto 0);
signal se_tbre_i           : std_logic:='0';
signal se_tsre_i           : std_logic:='0';
signal se_data_ready_i     : std_logic:='0';


signal Ram1OE_t              : std_logic;
signal Ram1WE_t              : std_logic;
signal Ram2Addr            : std_logic_vector(17 downto 0);
signal Ram2Data            : std_logic_vector(15 downto 0);
signal Ram2OE              : std_logic;
signal Ram2WE              : std_logic;
signal Ram2EN              : std_logic;
begin
	process(FlashLoad_Complete,id_succ_o,id_inst_o)
	begin
		if(FlashLoad_Complete=HIGH)then
			display_Data_out<=FlashLoad_Complete&
									id_succ_o&
									Ram1OE_t&
									id_inst_o(12 downto 0);
		else
			display_Data_out<=FlashLoad_Complete
									&FlashData_o(14 downto 0);
		end if;
	end process;
	RAMAddr_i<=FlashAddr_o;
	FlashData_i<=FlashData_o;
	FLASH_i : FLASH
	port map (
	  clk                => clk,
	  FlashLoad_Complete => FlashLoad_Complete,
	  Flash_clk2         => Flash_clk2,
	  rst                => rst,
	  RAMAddr_i          => RAMAddr_i,
	  VGAAddr_i          => VGAAddr_i,
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

Ram1OE<=Ram1OE_t;
Ram1WE<=Ram1WE_t;
	INST_ROM_i : INST_ROM
port map (
  clk                 => clk,
  rst                 => rst,
  id_addr_i           => control_Addr_in,
  id_succ_o           => id_succ_o,
  id_inst_o           => id_inst_o,
  mem_wr_i            => mem_wr_i,
  mem_rd_i            => mem_rd_i,
  mem_addr_i          => control_Addr_in,
  mem_wdata_i         => mem_wdata_i,
  mem_rdata_o         => mem_rdata_o,
  Ram1Addr            => Ram1Addr,
  Ram1Data            => Ram1Data,
  Ram1OE              => Ram1OE_t,
  Ram1WE              => Ram1WE_t,
  Ram1EN              => Ram1EN,
  Ram2Addr            => Ram2Addr,
  Ram2Data            => Ram2Data,
  Ram2OE              => Ram2OE,
  Ram2WE              => Ram2WE,
  Ram2EN              => Ram2EN,
  FlashLoadComplete_o => FlashLoad_Complete,
  Flash_clk2          => Flash_clk2,
  FlashAddr_o         => FlashAddr_o,
  FlashData_i         => FlashData_i,
  VGAAddr_char        => VGAAddr_char,
  VGAData_char        => VGAData_char,
  se_wrn_o            => se_wrn_o,
  se_rdn_o            => se_rdn_o,
  se_tbre_i           => se_tbre_i,
  se_tsre_i           => se_tsre_i,
  se_data_ready_i     => se_data_ready_i
);


end Behavioral;

