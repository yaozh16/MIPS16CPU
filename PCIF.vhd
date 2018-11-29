----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:16:02 11/29/2018 
-- Design Name: 
-- Module Name:    PCIF - Behavioral 
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
use DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PCIF is
	port(
		clk: in std_logic;
		rst: in std_logic;
		install_i: in std_logic;	---should be stable before clk down edge
											---connected to memory unit
		branch_addr_i:in std_logic_vector(15 downto 0);
		branch_flag_i:in std_logic;
		
		---communicate with memory unit
		pc_o:out std_logic_vector(15 downto 0);	---connected to memory unit
		
		---if
		
		instruction_i:in std_logic_vector(15 downto 0);	---connected to memory unit
		instruction_o:out std_logic_vector(15 downto 0) ---connected to registers between parts
	);
end PCIF;

architecture Behavioral of PCIF is
	signal pc:std_logic_vector(15 downto 0):=ZeroWord;
	signal install:std_logic:=LOW;
begin
	pc_o<=pc;
	instruction_o<=instruction_i;
	process(clk,rst)
	begin
		if(rst=LOW)then
			pc<=ZeroWord;
		elsif (clk'event and clk=HIGH) then
			if(branch_flag_i=HIGH)then
				pc<=branch_addr_i;
			elsif(install=LOW)then
				pc<=pc+1;
			end if;
		end if;
	end process;
	
	process(clk,install_i)
	begin
		if(clk'event and clk=LOW)then
			install<=install_i;
		end if;
	end process;
end Behavioral;

