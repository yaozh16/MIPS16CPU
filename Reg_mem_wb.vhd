----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:34:14 11/29/2018 
-- Design Name: 
-- Module Name:    Reg_mem_wb - Behavioral 
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

entity Reg_mem_wb is
		port(
			rst:in std_logic;
			clk:in std_logic;
			flush:in std_logic;
			stall:in std_logic;
			
			
			reg_dest_i:in std_logic_vector(3 downto 0);		
			writeback_data_i: in std_logic_vector(15 downto 0);
			
			reg_dest_o:out std_logic_vector(3 downto 0);		
			writeback_data_o: out std_logic_vector(15 downto 0)
		);
end Reg_mem_wb;

architecture Behavioral of Reg_mem_wb is
begin
	process(clk,rst,flush)
	begin
		if(((not rst ) or  flush)=HIGH )then
			reg_dest_o<=RegAddrNOP;
			writeback_data_o<=ZeroWord;
		elsif((clk'event and clk=HIGH) and (stall=LOW))then
			reg_dest_o<=reg_dest_i;
			writeback_data_o<=writeback_data_i;
		end if;
	end process;
end Behavioral;

