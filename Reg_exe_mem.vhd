----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:34:01 11/29/2018 
-- Design Name: 
-- Module Name:    Reg_exe_mem - Behavioral 
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

entity Reg_exe_mem is
	port(
		rst:in std_logic;
		clk:in std_logic;
		flush:in std_logic;
		stall:in std_logic;
	
		ALU_result_i:in std_logic_vector(15 downto 0);
		reg_dest_i:in std_logic_vector(3 downto 0);
		mem_rd_i:in std_logic;
		mem_wr_i:in std_logic;
		writeback_mux_i:in std_logic;
		mem_wdata_i:in std_logic_vector(15 downto 0);
		
		ALU_result_o:out std_logic_vector(15 downto 0);
		reg_dest_o:out std_logic_vector(3 downto 0);
		mem_rd_o:out std_logic;
		mem_wr_o:out std_logic;
		writeback_mux_o:out std_logic;
		mem_wdata_o:out std_logic_vector(15 downto 0)
	);
end Reg_exe_mem;

architecture Behavioral of Reg_exe_mem is
	
begin
	process(clk,rst,flush)
	begin
		if((rst=LOW) or (flush=HIGH))then
			ALU_result_o<=ZeroWord;
			reg_dest_o<=RegAddrNOP;
			mem_rd_o<=LOW;
			mem_wr_o<=LOW;
			writeback_mux_o<=LOW;
			mem_wdata_o<=ZeroWord;
		elsif(clk'event and clk=HIGH and stall=LOW)then
			ALU_result_o<=ALU_result_i;
			reg_dest_o<=reg_dest_i;
			mem_rd_o<=mem_rd_i;
			mem_wr_o<=mem_wr_i;
			writeback_mux_o<=writeback_mux_i;
			mem_wdata_o<=mem_wdata_i;
		end if;
	end process;
end Behavioral;

