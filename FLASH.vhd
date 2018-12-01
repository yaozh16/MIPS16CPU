----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:08:45 11/29/2018 
-- Design Name: 
-- Module Name:    FLASH - Behavioral 
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

entity FLASH is
	Port(
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
end FLASH;
---
---
architecture Behavioral of FLASH is
begin
	flash_byte <= '1';
	flash_vpen <= '1';
	flash_ce <= '0';
	flash_rp <= '1';
	
	flash_oe<=clk or FlashLoad_clk;
	flash_we<=clk or (not FlashLoad_clk);
	flash_addr<=addr_in;
	FlashDataControl:process(clk,FlashLoad_clk)
	begin
		if(clk'event and clk=LOW)then
			if(FlashLoad_clk=HIGH)then
				flash_data<=x"00FF";
			else
				flash_data<=(others=>'Z');
			end if;
		end if;
	end process;
	data_out<=flash_data;
end Behavioral;

