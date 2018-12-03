----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:01:04 12/01/2018 
-- Design Name: 
-- Module Name:    TestFlashModule - Behavioral 
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

entity TestFlashModule is
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
		flash_data : inout std_logic_vector(15 downto 0)
	);
end TestFlashModule;

architecture Behavioral of TestFlashModule is
COMPONENT FLASH PORT(
			  clk : in std_logic;
			  FlashLoad_Complete:in std_logic;
			  Flash_clk2:out std_logic;
			  rst : in std_logic;
			  
			  
			  
			  ---RAM
			  RAMAddr_i:in std_logic_vector(22 downto 0);
			  ---VGA
			  VGAAddr_i:in std_logic_vector(22 downto 0);	---VGAData addr in ram2
           FlashData_o:out std_logic_vector(15 downto 0);
			  
			  
			  flash_byte : out std_logic;
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;				---ce0
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  flash_addr : out std_logic_vector(22 downto 0);
			  flash_data : inout std_logic_vector(15 downto 0)
			 
	);
	END COMPONENT;
	signal RAMAddr_i :  std_logic_vector(22 downto 0);
	signal VGAAddr_i :  std_logic_vector(22 downto 0);
	signal FlashData_o :  std_logic_vector(15 downto 0);
	signal Flash_clk2:std_logic;
	signal FlashLoad_Complete:std_logic;
begin
	FlashLoad_Complete<='0';
	uut:FLASH PORT map(
			  clk =>clk,
			  FlashLoad_Complete=>FlashLoad_Complete,
			  Flash_clk2=>Flash_clk2,
			  rst =>rst,
			  
			  RAMAddr_i=>RAMAddr_i,
			  VGAAddr_i=>VGAAddr_i,
			  FlashData_o=>FlashData_o,
			  flash_byte =>flash_byte,
			  flash_vpen =>flash_vpen,
			  flash_ce =>flash_ce,
			  flash_oe =>Flash_oe,				---ce0
			  flash_we =>flash_we,
			  flash_rp =>flash_rp,
			  flash_addr =>flash_addr,
			  flash_data =>flash_data
	);
	process(rst,clk,Flash_clk2)
	begin
		if(rst='0')then
			RAMAddr_i<=(others=>'1');
			VGAAddr_i<=(others=>'1');
		else
			if(clk'event and clk='0' and Flash_clk2='1')then	---down side
				RAMAddr_i<="000000"&control_Addr_in&"0";
				VGAAddr_i<="000000"&control_Addr_in&"0";
			end if;
		end if;
	end process;
	
	
	process(Flash_clk2,rst)
	begin
		if(rst='0')then
			display_Data_out<="0000000000000000";
		else
			if(Flash_clk2'event and Flash_clk2='1' )then
			--if(not(FlashData_o=x"00FF"))then
				display_Data_out<=FlashData_o;
			end if;
		end if;
	end process;
end Behavioral;

