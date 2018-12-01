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
			  FlashLoad_clk:in std_logic;
			  rst : in std_logic;
			  
			  addr_in:in std_logic_vector(22 downto 0);
           data_out:out std_logic_vector(15 downto 0);
			  
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
	signal FlashAddr_o :  std_logic_vector(22 downto 0);
	signal FlashData_i :  std_logic_vector(15 downto 0);
	signal clk_2:std_logic;
begin
	uut:FLASH PORT map(
			  clk =>clk,
			  FlashLoad_clk=>clk_2,
			  rst =>rst,
			  
			  addr_in=>FlashAddr_o,
           data_out=>FlashData_i,
			  
			  flash_byte =>flash_byte,
			  flash_vpen =>flash_vpen,
			  flash_ce =>flash_ce,
			  flash_oe =>flash_oe,				---ce0
			  flash_we =>flash_we,
			  flash_rp =>flash_rp,
			  flash_addr =>flash_addr,
			  flash_data =>flash_data
	);
	process(clk)
	begin
		if (clk'event and clk='1') then
			if(clk_2='1')then
				clk_2<='0';
			else
				clk_2<='1';
			end if;
		end if;
	end process;
	
	process(rst,clk,clk_2)
	begin
		if(rst='0')then
			FlashAddr_o<=(others=>'1');
		else
			if(clk'event and clk='0' and clk_2='1')then	---down side
				FlashAddr_o<="0000000"&control_Addr_in;
			end if;
		end if;
	end process;
	
	
	process(clk_2,rst)
	begin
		if(rst='0')then
			display_Data_out<="0000000000000000";
		else
			if(clk_2'event and clk_2='1')then
				display_Data_out<=FlashData_i;
			end if;
		end if;
	end process;
end Behavioral;

