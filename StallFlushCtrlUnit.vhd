----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:23:03 11/29/2018 
-- Design Name: 
-- Module Name:    StallFlushCtrlUnit - Behavioral 
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

entity StallFlushCtrlUnit is
	port(
		branch_flag_i:in std_logic;	---from EXE
		
		se_rw_stall_i:in std_logic;	---from MEM
		
		----need to stall:
		--PC |RF  |	EXE(LW) | MEM |WB
		--			 ^			  ^
		--s  s	 s			  f	  
		mem_rd_i_EXE_MEM:in std_logic;									-- from exe_mem_regs
		mem_wr_i_RF_EXE:in std_logic;										-- from exe_mem_regs
		mem_rd_i_RF_EXE:in std_logic;										-- from exe_mem_regs
		reg_exemem_dest_addr_i:in std_logic_vector(3 downto 0);	-- from exe_mem_regs
		reg_src1_addr_i:in std_logic_vector(3 downto 0);			---from rf_exe regs
		reg_src2_addr_i:in std_logic_vector(3 downto 0);			-- from rf_exe regs
		
		
		----PC IFID  |	RF	|	EXE	|	MEM	|	WB
		----PC and  4 "|" between parts
		RegStalls_o:out std_logic_vector(4 downto 0); 
		RegFlushs_o:out std_logic_vector(3 downto 0)
	);
end StallFlushCtrlUnit;

architecture Behavioral of StallFlushCtrlUnit is
begin
	process(
				branch_flag_i,
				mem_rd_i_EXE_MEM,
				reg_exemem_dest_addr_i,
				reg_src1_addr_i,
				reg_src2_addr_i,
				mem_wr_i_RF_EXE,
				mem_rd_i_RF_EXE,
				se_rw_stall_i
				)
	begin
		if(se_rw_stall_i='1')then
			----Waiting until serial port finished read or write
			RegStalls_o<="11111";
			RegFlushs_o<= "0000";
		elsif((mem_rd_i_EXE_MEM='1')and 
					(	((reg_exemem_dest_addr_i=reg_src1_addr_i) and not( reg_src1_addr_i=RegAddrNOP)) 
					or ((reg_exemem_dest_addr_i=reg_src2_addr_i) and not( reg_src2_addr_i=RegAddrNOP))
					)
				)then			
					--- LW conflict
					RegStalls_o<="11100";---PC  IFRF   RFEXE 
					RegFlushs_o<= "0010";
		elsif(branch_flag_i='1')then
					RegStalls_o<="00000";
					RegFlushs_o<= "1100";	----delay slot
		else
					RegStalls_o<="00000";
					RegFlushs_o<= "0000";
		end if;
	end process;

end Behavioral;

