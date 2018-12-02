----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:12:13 12/02/2018 
-- Design Name: 
-- Module Name:    TestPS2Module - Behavioral 
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

entity TestPS2Module is
	port(
		clk_ps2:in std_logic;
		data_ps2:in std_logic;
		rst:in std_logic;
		clk:in std_logic;
		
		---7 downto 0:keycode
		---15 16: pressed
		keycode:out std_logic_vector(15 downto 0)		
	);
end TestPS2Module;

architecture Behavioral of TestPS2Module is
	component PS2 port (
		clk_ps2:in std_logic;
		data_ps2:in std_logic;
		rst:in std_logic;
		clk:in std_logic;
		
		---7 downto 0:keycode
		---15 16: pressed
		keycode:out std_logic_vector(15 downto 0)		
	);
end component;
begin
	uut:PS2 port map(
		clk_ps2=>clk_ps2,
		data_ps2=>data_ps2,
		rst=>rst,
		clk=>clk,
		keycode=>keycode
	);
end Behavioral;

