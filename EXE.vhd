----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:07:42 11/28/2018 
-- Design Name: 
-- Module Name:    EXE - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use WORK.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EXE is
	port(
		exe_aluop_i:in std_logic_vector(3 downto 0);---ALU operation
		exe_mux1_i:in std_logic_vector(1 downto 0);
		exe_mux2_i:in std_logic_vector(1 downto 0);
		
		reg_src1_i:in std_logic_vector(15 downto 0);
		reg_src2_i:in std_logic_vector(15 downto 0);
		extended_i:in std_logic_vector(15 downto 0);
		
		
		
		ALU_result_o:out std_logic_vector(15 downto 0);
		
		---inherit
		reg_dest_i:in std_logic_vector(3 downto 0);
		reg_dest_o:out std_logic_vector(3 downto 0);
		
		mem_wr_i:in std_logic;
		mem_wr_o:out std_logic;
		
		mem_rd_i:in std_logic;
		mem_rd_o:out std_logic
	);
end EXE;

architecture Behavioral of EXE is
	signal src_1:std_logic_vector(15 downto 0):=ZeroWord;
	signal src_2:std_logic_vector(15 downto 0):=ZeroWord;
begin
	reg_dest_o<=reg_dest_i;
	mem_wr_o<=mem_wr_i;
	mem_rd_o<=mem_rd_i;
	
	process(exe_mux1_i,reg_src1_i)
	begin
		case exe_mux1_i is
			when "00"=>src_1<=reg_src1_i;
			when "01"=>src_1<=ZeroWord;
			when others=>src_1<=ZeroWord;
		end case;
	end process;
	process(exe_mux2_i,reg_src2_i,extended_i)
	begin
		case exe_mux2_i is
			when "00"=>src_2<=reg_src2_i;
			when "01"=>src_2<=extended_i;
			when others=>src_2<=ZeroWord;
		end case;
	end process;
	
	process(exe_aluop_i,src_1,src_1)
	begin
			case exe_aluop_i is
			when	OP_ADD=>ALU_result_o<=src_1+src_2;
			when	OP_SUB=>ALU_result_o<=src_1-src_2;
			when	OP_AND=>ALU_result_o<=src_1 and src_2;
			when	OP_OR =>ALU_result_o<=src_1 or  src_2;
			when	OP_CMP=> if(src_1=src_2) then
									ALU_result_o<=ZeroWord;
								else
									ALU_result_o<=OneWord;
								end if;
			when	OP_NOT=>ALU_result_o<=not src_1;
			when	OP_SLL=>ALU_result_o<=to_stdlogicvector(to_bitvector(src_1) sll conv_integer(src_2));
			when	OP_SLT_S=> if(src_1(15)=src_2(15))then
										if(src_1<src_2)then
											ALU_result_o<=OneWord;
										else
											ALU_result_o<=ZeroWord;	
										end if;
									else
										ALU_result_o<=Zero15&(src_1(15) and (not src_2(15)));
									end if;
			when	OP_SLT_U=>	if(src_1<src_2) then
									ALU_result_o<=OneWord;
								else
									ALU_result_o<=ZeroWord;
								end if;
			when	OP_SRA=>ALU_result_o<=to_stdlogicvector(to_bitvector(src_1) sra conv_integer(src_2));
			when	OP_SRL=>ALU_result_o<=to_stdlogicvector(to_bitvector(src_1) srl conv_integer(src_2));
			when	OP_XOR=>ALU_result_o<=src_1 xor src_2;
			when  others=>ALU_result_o<=ZeroWord;
			end case;
	end process;
end Behavioral;

