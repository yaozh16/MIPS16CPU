----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:32:06 11/29/2018 
-- Design Name: 
-- Module Name:    Reg_id_rf - Behavioral 
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
use work.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg_id_rf is
	port(
		rst:in std_logic;
		clk:in std_logic;
		flush:in std_logic;
		stall:in std_logic;
		instruction_i:in std_logic_vector(15 downto 0);
		instruction_o:out std_logic_vector(15 downto 0);
		
		pc_i:in std_logic_vector(15 downto 0);
		pc_o:out std_logic_vector(15 downto 0)
	);
end Reg_id_rf;

architecture Behavioral of Reg_id_rf is

begin
	process(clk,rst)
	begin
		if((rst=LOW)or (flush=HIGH))then
			pc_o<=ZeroWord;
			instruction_o<=NopInst;
		elsif(clk'event and clk=HIGH and stall=LOW)then
			pc_o<=pc_i;
			instruction_o<=instruction_i;
		end if;
	end process;

end Behavioral;

