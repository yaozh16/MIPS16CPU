----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:32:57 11/29/2018 
-- Design Name: 
-- Module Name:    Reg_rf_exe - Behavioral 
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

entity Reg_rf_exe is
	port(
		rst:in std_logic;
		clk:in std_logic;
		flush:in std_logic;
		stall:in std_logic;
		
		
		branch_type_i:in std_logic_vector(2 downto 0);
		exe_aluop_i:in std_logic_vector(3 downto 0);---ALU operation
		exe_mux1_i:in std_logic;	--reg or 0
		exe_mux2_i:in std_logic;  --reg or extended           
		reg_src1_addr_i:in std_logic_vector(3 downto 0);
		reg_src2_addr_i:in std_logic_vector(3 downto 0);
		
		extended_i:in std_logic_vector(15 downto 0);
		reg_dest_i:in std_logic_vector(3 downto 0);
		mem_rd_i:in std_logic;
		mem_wr_i:in std_logic;
		writeback_mux_i:in std_logic;
	
	
		branch_type_o:out std_logic_vector(2 downto 0);
		exe_aluop_o:out std_logic_vector(3 downto 0);---ALU operation
		exe_mux1_o:out std_logic;	--reg or 0
		exe_mux2_o:out std_logic;  --reg or extended         
		reg_src1_addr_o:out std_logic_vector(3 downto 0);
		reg_src2_addr_o:out std_logic_vector(3 downto 0);
		
		extended_o:out std_logic_vector(15 downto 0);
		reg_dest_o:out std_logic_vector(3 downto 0);
		mem_rd_o:out std_logic;
		mem_wr_o:out std_logic;
		writeback_mux_o:out std_logic;
		
		                                                                                                                 
		reg_src1_data_i:in std_logic_vector(15 downto 0);
		reg_src2_data_i:in std_logic_vector(15 downto 0);                                                                                             
		reg_src1_data_o:out std_logic_vector(15 downto 0);
		reg_src2_data_o:out std_logic_vector(15 downto 0)
	);
end Reg_rf_exe;

architecture Behavioral of Reg_rf_exe is	
begin
	process(clk,rst,flush)
	begin
		if(rst='0')then
			branch_type_o<=BRJ_NOP;
			exe_aluop_o<=OP_NOP;
			exe_mux1_o<=LOW;
			exe_mux2_o<=LOW;
			reg_src1_data_o<=ZeroWord;
			reg_src2_data_o<=ZeroWord;
			reg_src1_addr_o<=RegAddrNOP;
			reg_src2_addr_o<=RegAddrNOP;
			extended_o<=ZeroWord;
			reg_dest_o<=RegAddrNOP;
			mem_rd_o<=LOW;
			mem_wr_o<=LOW;
			writeback_mux_o<=LOW;	
		elsif(clk'event and clk=HIGH)then
				if(flush='1')then
					branch_type_o<=BRJ_NOP;
					exe_aluop_o<=OP_NOP;
					exe_mux1_o<=LOW;
					exe_mux2_o<=LOW;
					reg_src1_data_o<=ZeroWord;
					reg_src2_data_o<=ZeroWord;
					reg_src1_addr_o<=RegAddrNOP;
					reg_src2_addr_o<=RegAddrNOP;
					extended_o<=ZeroWord;
					reg_dest_o<=RegAddrNOP;
					mem_rd_o<=LOW;
					mem_wr_o<=LOW;
					writeback_mux_o<=LOW;	
				elsif(stall=LOW)then
					reg_src1_data_o<=reg_src1_data_i;
					reg_src2_data_o<=reg_src2_data_i;
					
					branch_type_o<=branch_type_i;
					exe_aluop_o<=exe_aluop_i;
					exe_mux1_o<=exe_mux1_i;
					exe_mux2_o<=exe_mux2_i;
					reg_src1_addr_o<=reg_src1_addr_i;
					reg_src2_addr_o<=reg_src2_addr_i;
					extended_o<=extended_i;
					reg_dest_o<=reg_dest_i;
					mem_rd_o<=mem_rd_i;
					mem_wr_o<=mem_wr_i;
					writeback_mux_o<=writeback_mux_i;
				end if;
		end if;
	end process;

end Behavioral;

