----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:43:31 11/28/2018 
-- Design Name: 
-- Module Name:    RF - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RF is
	port(
		clk:in std_logic;
		pc_i:in std_logic_vector(15 downto 0);
		instr_i: in std_logic_vector(15 downto 0);
		stall_i:in std_logic;	---last branch success
		
		reg_dest_i:in std_logic_vector(3 downto 0);---write back
		reg_wdata_i:in std_logic_vector(15 downto 0);---write back
		
		branch_type_o:out std_logic_vector(2 downto 0);
		exe_aluop_o:out std_logic_vector(3 downto 0);---ALU operation
		exe_mux1_o:out std_logic;	--reg or 0
		exe_mux2_o:out std_logic;  --reg or extended                                                                                                                 
		reg_src1_data_o:out std_logic_vector(15 downto 0);
		reg_src2_data_o:out std_logic_vector(15 downto 0);
		reg_src1_addr_o:out std_logic_vector(3 downto 0);
		reg_src2_addr_o:out std_logic_vector(3 downto 0);
		
		extended_o:out std_logic_vector(15 downto 0);
		reg_dest_o:out std_logic_vector(3 downto 0);
		mem_rd_o:out std_logic;
		mem_wr_o:out std_logic;
		writeback_mux_o:out std_logic
	);
end RF;

architecture Behavioral of RF is
	TYPE reg is ARRAY(0 to 15)of STD_LOGIC_VECTOR(15 downto 0);
	signal Regs:reg;
	signal extend_ctrl:std_logic_vector(3 downto 0):="0000";
	signal extended:	std_logic_vector(15 downto 0):=ZeroWord;
	signal reg_src_data1: std_logic_vector(15 downto 0):=ZeroWord;
	signal reg_src_data2: std_logic_vector(15 downto 0):=ZeroWord;
	signal reg_src_addr1: std_logic_vector(3 downto 0):=RegAddrNOP;
	signal reg_src_addr2: std_logic_vector(3 downto 0):=RegAddrNOP;
begin
	extended_o<=extended;
	reg_src1_data_o<=reg_src_data1;
	reg_src2_data_o<=reg_src_data2;
	reg_src1_addr_o<=reg_src_addr1;
	reg_src2_addr_o<=reg_src_addr2;
	reg_src_data1<=Regs(CONV_INTEGER(reg_src_addr1));
	reg_src_data2<=Regs(CONV_INTEGER(reg_src_addr2));
	--- write back
	process(clk,reg_dest_i,reg_wdata_i)
	begin 
			if(clk'event and clk=HIGH)then
				if(not(reg_dest_i=RegAddrNOP))then
					Regs(CONV_INTEGER(reg_dest_i))<=reg_wdata_i;
				end if;
			end if;
	end process;
	
	---extend ctrl
	process (extend_ctrl,instr_i,pc_i)
	begin
		case extend_ctrl is
			when EXTEND_NOP	=>extended<=ZeroWord;
			when EXTEND_7S0	=>extended<=to_stdlogicvector(to_bitvector(instr_i(7 downto 0)&Zero8) sra 8);
			when EXTEND_3S0	=>extended<=to_stdlogicvector(to_bitvector(instr_i(3 downto 0)&Zero8&Zero4) sra 12);
			when EXTEND_PC10S0=>extended<=pc_i+OneWord+to_stdlogicvector(to_bitvector(instr_i(10 downto 0)&Zero4&"0") sra 5);
			when EXTEND_PC7S0	=>extended<=pc_i+OneWord+to_stdlogicvector(to_bitvector(instr_i(7 downto 0)&Zero8) sra 8);
			when EXTEND_7Z0	=>extended<=Zero8&instr_i(7 downto 0);
			when EXTEND_4S0	=>extended<=to_stdlogicvector(to_bitvector(instr_i(4 downto 0)&Zero8&"000") sra 11);
			when EXTEND_PC		=>extended<=pc_i+OneWord;
			when EXTEND_4Z2_Z8=>if(instr_i(4 downto 2)="000")then
											extended<=Zero8&Zero4&"1000";
										else
											extended<=Zero8&Zero4&"0"&instr_i(4 downto 2);
										end if;
			when others=>extended<=ZeroWord;
		end case;
	end process;
	
	process(instr_i,stall_i)
	begin
		if(stall_i=HIGH)then---pause nop
			exe_aluop_o<=OP_NOP;
			exe_mux1_o<=LOW;
			exe_mux2_o<=LOW;
			reg_src_addr1<=RegAddrNOP;
			reg_src_addr2<=RegAddrNOP;
			extend_ctrl<=EXTEND_NOP;
			reg_dest_o<=RegAddrNOP;
			writeback_mux_o<=MEM_MUX_ALU_RESULT;
			mem_wr_o<=LOW;
			mem_rd_o<=LOW;
			branch_type_o<=BRJ_NOP;
		else
			case (instr_i(15 downto 11)) is
				when "00000"=>	exe_aluop_o<=OP_ADD;			---ADDSP3
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<=RegAddrSP;		--SP
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_7S0;
									reg_dest_o<="0"&instr_i(10 downto 8);	--Rx
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "00010"=>	exe_aluop_o<=OP_NOP;			---B
									exe_mux1_o<=LOW;
									exe_mux2_o<=LOW;				---B to Extend
									reg_src_addr1<=RegAddrNOP;
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_PC10S0;	---PC+immediate10
									reg_dest_o<=RegAddrNOP;
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_B;
				when "00100"=>	exe_aluop_o<=OP_NOP;			---BEQZ
									exe_mux1_o<=LOW;
									exe_mux2_o<=LOW;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_PC7S0;
									reg_dest_o<=RegAddrNOP;
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_BEQZ;
				when "00101"=>	exe_aluop_o<=OP_NOP;			---BNEZ
									exe_mux1_o<=LOW;
									exe_mux2_o<=LOW;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_PC7S0;
									reg_dest_o<=RegAddrNOP;
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_BNEZ;
				when "00110"=>	case instr_i(1 downto 0) is 
										when "00"=>	exe_aluop_o<=OP_SLL;			---SLL
														exe_mux1_o<=LOW;
														exe_mux2_o<=HIGH;
														reg_src_addr1<="0"&instr_i(7 downto 5);		--Ry
														reg_src_addr2<=RegAddrNOP;
														extend_ctrl<=EXTEND_4Z2_Z8;
														reg_dest_o<="0"&instr_i(10 downto 8);		--Rx
														writeback_mux_o<=MEM_MUX_ALU_RESULT;
														mem_wr_o<=LOW;
														mem_rd_o<=LOW;
														branch_type_o<=BRJ_NOP;
										when "10"=>	exe_aluop_o<=OP_SRL;			---SRL
														exe_mux1_o<=LOW;
														exe_mux2_o<=HIGH;
														reg_src_addr1<="0"&instr_i(7 downto 5);		--Ry
														reg_src_addr2<=RegAddrNOP;
														extend_ctrl<=EXTEND_4Z2_Z8;
														reg_dest_o<="0"&instr_i(10 downto 8);		--Rx
														writeback_mux_o<=MEM_MUX_ALU_RESULT;
														mem_wr_o<=LOW;
														mem_rd_o<=LOW;
														branch_type_o<=BRJ_NOP;
										when "11"=>	exe_aluop_o<=OP_SRA;			---SRA
														exe_mux1_o<=LOW;
														exe_mux2_o<=HIGH;
														reg_src_addr1<="0"&instr_i(7 downto 5);		--Ry
														reg_src_addr2<=RegAddrNOP;
														extend_ctrl<=EXTEND_4Z2_Z8;
														reg_dest_o<="0"&instr_i(10 downto 8);		--Rx
														writeback_mux_o<=MEM_MUX_ALU_RESULT;
														mem_wr_o<=LOW;
														mem_rd_o<=LOW;
														branch_type_o<=BRJ_NOP;
										when others=>exe_aluop_o<=OP_NOP;		---NOP
														exe_mux1_o<=LOW;
														exe_mux2_o<=LOW;
														reg_src_addr1<=RegAddrNOP;
														reg_src_addr2<=RegAddrNOP;
														extend_ctrl<=EXTEND_NOP;
														reg_dest_o<=RegAddrNOP;
														writeback_mux_o<=MEM_MUX_ALU_RESULT;
														mem_wr_o<=LOW;
														mem_rd_o<=LOW;
														branch_type_o<=BRJ_NOP;
									end case;
				when "01000"=>	exe_aluop_o<=OP_ADD;			---ADDIU3
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_3S0;
									reg_dest_o<="0"&instr_i(7 downto 5);	--Ry
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "01001"=>	exe_aluop_o<=OP_ADD;			---ADDIU
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_7S0;
									reg_dest_o<="0"&instr_i(10 downto 8);	--Rx
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "01010"=>	exe_aluop_o<=OP_SLT_S;			---SLTI
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_7S0;
									reg_dest_o<=RegAddrT;	--T
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "01011"=>	exe_aluop_o<=OP_SLT_U;			---SLTUI
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_7S0;
									reg_dest_o<=RegAddrT;	--T
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "01100"=>	case(instr_i(10 downto 8)) is
										when "000" =>	exe_aluop_o<=OP_NOP;			---BTEQZ
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<=RegAddrT;		--T
															reg_src_addr2<=RegAddrNOP;
															extend_ctrl<=EXTEND_PC7S0;
															reg_dest_o<=RegAddrNOP;
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_BEQZ;
										when "001" =>	exe_aluop_o<=OP_NOP;			---BTNEZ
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<=RegAddrT;		--T
															reg_src_addr2<=RegAddrNOP;
															extend_ctrl<=EXTEND_PC7S0;
															reg_dest_o<=RegAddrNOP;
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_BNEZ;
										when "010" =>	exe_aluop_o<=OP_ADD;			---SW_RS
															exe_mux1_o<=LOW;
															exe_mux2_o<=HIGH;
															reg_src_addr1<=RegAddrSP;
															reg_src_addr2<=RegAddrRA;
															extend_ctrl<=EXTEND_7S0;
															reg_dest_o<=RegAddrNOP;
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=HIGH;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "011" =>  exe_aluop_o<=OP_ADD;			---ADDSP
															exe_mux1_o<=LOW;
															exe_mux2_o<=HIGH;
															reg_src_addr1<=RegAddrSP;		--SP
															reg_src_addr2<=RegAddrNOP;
															extend_ctrl<=EXTEND_7S0;
															reg_dest_o<=RegAddrSP;	--SP
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "100" =>  exe_aluop_o<=OP_ADD;			---MTSP
															exe_mux1_o<=HIGH;
															exe_mux2_o<=LOW;
															reg_src_addr1<=RegAddrNOP;		
															reg_src_addr2<="0"&instr_i(7 downto 5);	---Ry
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<=RegAddrSP;	--SP
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when others=>	exe_aluop_o<=OP_NOP;		---NOP
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<=RegAddrNOP;
															reg_src_addr2<=RegAddrNOP;
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<=RegAddrNOP;
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
									end case;
				when "01101"=>	exe_aluop_o<=OP_ADD;			---LI
									exe_mux1_o<=HIGH;
									exe_mux2_o<=HIGH;
									reg_src_addr1<=RegAddrNOP;
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_7Z0;
									reg_dest_o<="0"&instr_i(10 downto 8);	--Rx
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "01110"=>	exe_aluop_o<=OP_CMP;			---CMPI
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_7S0;
									reg_dest_o<=RegAddrT;	--T
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "01111"=>	exe_aluop_o<=OP_ADD;			---MOVE
									exe_mux1_o<=HIGH;
									exe_mux2_o<=LOW;
									reg_src_addr1<=RegAddrNOP;		
									reg_src_addr2<="0"&instr_i(7 downto 5);		--Rx
									extend_ctrl<=EXTEND_NOP;
									reg_dest_o<="0"&instr_i(10 downto 8);		--Rx
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "10010"=>	exe_aluop_o<=OP_ADD;			---LWSP
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<=RegAddrSP;		--SP
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_7S0;
									reg_dest_o<="0"&instr_i(10 downto 8);		--Rx
									writeback_mux_o<=MEM_MUX_MEM_OUT;
									mem_wr_o<=LOW;
									mem_rd_o<=HIGH;
									branch_type_o<=BRJ_NOP;
				when "10011"=>	exe_aluop_o<=OP_ADD;			---LW
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_4S0;
									reg_dest_o<="0"&instr_i(7 downto 5);		--Ry
									writeback_mux_o<=MEM_MUX_MEM_OUT;
									mem_wr_o<=LOW;
									mem_rd_o<=HIGH;
									branch_type_o<=BRJ_NOP;
				when "11010"=>	exe_aluop_o<=OP_ADD;			---SW_SP
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<=RegAddrSP;		--SP
									reg_src_addr2<="0"&instr_i(10 downto 8);		--Rx
									extend_ctrl<=EXTEND_7S0;
									reg_dest_o<=RegAddrNOP;
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=HIGH;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "11011"=>	exe_aluop_o<=OP_ADD;			---SW
									exe_mux1_o<=LOW;
									exe_mux2_o<=HIGH;
									reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
									reg_src_addr2<="0"&instr_i(7 downto 5);		--Ry
									extend_ctrl<=EXTEND_4S0;
									reg_dest_o<=RegAddrNOP;
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=HIGH;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
				when "11100"=>	case instr_i(1 downto 0) is
										when "01"=>	exe_aluop_o<=OP_ADD;			---ADDU
														exe_mux1_o<=LOW;
														exe_mux2_o<=LOW;
														reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
														reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
														extend_ctrl<=EXTEND_NOP;
														reg_dest_o<=RegAddrNOP;
														writeback_mux_o<=MEM_MUX_ALU_RESULT;
														mem_wr_o<=LOW;
														mem_rd_o<=LOW;
														branch_type_o<=BRJ_NOP;
										when "11"=>	exe_aluop_o<=OP_SUB;			---SUBU
														exe_mux1_o<=LOW;
														exe_mux2_o<=LOW;
														reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
														reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
														extend_ctrl<=EXTEND_NOP;
														reg_dest_o<="0"&instr_i( 4 downto 2);	--Rz
														writeback_mux_o<=MEM_MUX_ALU_RESULT;
														mem_wr_o<=LOW;
														mem_rd_o<=LOW;
														branch_type_o<=BRJ_NOP;
										when others=> 	exe_aluop_o<=OP_NOP;		---NOP
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<=RegAddrNOP;
															reg_src_addr2<=RegAddrNOP;
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<=RegAddrNOP;
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
									end case;
									
				when "11101"=>	case(instr_i(4 downto 0)) is
										when "00000"=>	case (instr_i(7 downto 5))is
																when "000"=>exe_aluop_o<=OP_NOP;			---JR
																				exe_mux1_o<=LOW;
																				exe_mux2_o<=LOW;
																				reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
																				reg_src_addr2<=RegAddrNOP;
																				extend_ctrl<=EXTEND_NOP;
																				reg_dest_o<=RegAddrNOP;
																				writeback_mux_o<=MEM_MUX_ALU_RESULT;
																				mem_wr_o<=LOW;
																				mem_rd_o<=LOW;
																				branch_type_o<=BRJ_JR;
																when "110"=>exe_aluop_o<=OP_ADD;			---JARL
																				exe_mux1_o<=HIGH;
																				exe_mux2_o<=HIGH;
																				reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx: for exe to jump
																				reg_src_addr2<=RegAddrNOP;
																				extend_ctrl<=EXTEND_PC;
																				reg_dest_o<=RegAddrRA;
																				writeback_mux_o<=MEM_MUX_ALU_RESULT;
																				mem_wr_o<=LOW;
																				mem_rd_o<=LOW;
																				branch_type_o<=BRJ_JR;
																when others=>exe_aluop_o<=OP_NOP;		---NOP
																				exe_mux1_o<=LOW;
																				exe_mux2_o<=LOW;
																				reg_src_addr1<=RegAddrNOP;
																				reg_src_addr2<=RegAddrNOP;
																				extend_ctrl<=EXTEND_NOP;
																				reg_dest_o<=RegAddrNOP;
																				writeback_mux_o<=MEM_MUX_ALU_RESULT;
																				mem_wr_o<=LOW;
																				mem_rd_o<=LOW;
																				branch_type_o<=BRJ_NOP;
															end case;
										when "00010"=>	exe_aluop_o<=OP_SLT_S;			---SLT
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
															reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<=RegAddrT;			---T
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "00011"=>	exe_aluop_o<=OP_SLT_U;			---SLTU
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
															reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<=RegAddrT;			---T
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "00100"=>	exe_aluop_o<=OP_SLL;			---SLLV
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i(7 downto 5);		--Ry
															reg_src_addr2<="0"&instr_i(10 downto 8);		--Rx
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<="0"&instr_i(7 downto 5);		--Ry
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "00110"=>	exe_aluop_o<=OP_SRL;			---SRLV
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i(7 downto 5);		--Ry
															reg_src_addr2<="0"&instr_i(10 downto 8);		--Rx
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<="0"&instr_i(7 downto 5);		--Ry
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "00111"=>	exe_aluop_o<=OP_SRA;			---SRAV
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i(7 downto 5);		--Ry
															reg_src_addr2<="0"&instr_i(10 downto 8);		--Rx
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<="0"&instr_i(7 downto 5);		--Ry
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "01010"=>	exe_aluop_o<=OP_CMP;			---CMP
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
															reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<=RegAddrT;	--T
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "01011"=>	exe_aluop_o<=OP_SUB;			---NEG
															exe_mux1_o<=HIGH;
															exe_mux2_o<=LOW;
															reg_src_addr1<=RegAddrNOP;
															reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<="0"&instr_i( 10 downto 8);	--Rx
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "01110"=>	exe_aluop_o<=OP_XOR;			---XOR
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i( 10 downto 8);		--Rx
															reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<="0"&instr_i( 10 downto 8);	--Rx
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "01100"=>	exe_aluop_o<=OP_AND;			---AND
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
															reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<="0"&instr_i(10 downto 8);	--Rx
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "01101"=>	exe_aluop_o<=OP_OR;			---OR
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i(10 downto 8);		--Rx
															reg_src_addr2<="0"&instr_i( 7 downto 5);		--Ry
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<="0"&instr_i(10 downto 8);	--Rx
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when "01111"=>	exe_aluop_o<=OP_NOT;			---NOT
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<="0"&instr_i( 7 downto 5);		--Ry
															reg_src_addr2<=RegAddrNOP;
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<="0"&instr_i(10 downto 8);	--Rx
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
										when others=> 	exe_aluop_o<=OP_NOP;		---NOP
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<=RegAddrNOP;
															reg_src_addr2<=RegAddrNOP;
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<=RegAddrNOP;
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
									end case;
				when "11110"=>	case instr_i(7 downto 0) is
										when "00000000"	=>	exe_aluop_o<=OP_ADD;		---MFIH
																	exe_mux1_o<=HIGH;
																	exe_mux2_o<=LOW;
																	reg_src_addr1<=RegAddrNOP;
																	reg_src_addr2<=RegAddrIH;	--IH
																	extend_ctrl<=EXTEND_NOP;
																	reg_dest_o<="0"&instr_i(10 downto 8);		--Rx
																	writeback_mux_o<=MEM_MUX_ALU_RESULT;
																	mem_wr_o<=LOW;
																	mem_rd_o<=LOW;
																	branch_type_o<=BRJ_NOP;
										when "00000001"	=>	exe_aluop_o<=OP_ADD;		---MTIH
																	exe_mux1_o<=HIGH;
																	exe_mux2_o<=LOW;
																	reg_src_addr1<=RegAddrNOP;
																	reg_src_addr2<="0"&instr_i(10 downto 8); --Rx
																	extend_ctrl<=EXTEND_NOP;
																	reg_dest_o<=RegAddrIH;		--IH
																	writeback_mux_o<=MEM_MUX_ALU_RESULT;
																	mem_wr_o<=LOW;
																	mem_rd_o<=LOW;
																	branch_type_o<=BRJ_NOP;
										when "01000000"	=>	exe_aluop_o<=OP_ADD;		---MFPC
																	exe_mux1_o<=HIGH;
																	exe_mux2_o<=HIGH;
																	reg_src_addr1<=RegAddrNOP;
																	reg_src_addr2<=RegAddrNOP;
																	extend_ctrl<=EXTEND_PC;
																	reg_dest_o<="0"&instr_i(10 downto 8);		--Rx
																	writeback_mux_o<=MEM_MUX_ALU_RESULT;
																	mem_wr_o<=LOW;
																	mem_rd_o<=LOW;
																	branch_type_o<=BRJ_NOP;
										when others	=>	exe_aluop_o<=OP_NOP;		---NOP
															exe_mux1_o<=LOW;
															exe_mux2_o<=LOW;
															reg_src_addr1<=RegAddrNOP;
															reg_src_addr2<=RegAddrNOP;
															extend_ctrl<=EXTEND_NOP;
															reg_dest_o<=RegAddrNOP;
															writeback_mux_o<=MEM_MUX_ALU_RESULT;
															mem_wr_o<=LOW;
															mem_rd_o<=LOW;
															branch_type_o<=BRJ_NOP;
									end case;
				when others=>	exe_aluop_o<=OP_NOP;		---NOP
									exe_mux1_o<=LOW;
									exe_mux2_o<=LOW;
									reg_src_addr1<=RegAddrNOP;
									reg_src_addr2<=RegAddrNOP;
									extend_ctrl<=EXTEND_NOP;
									reg_dest_o<=RegAddrNOP;
									writeback_mux_o<=MEM_MUX_ALU_RESULT;
									mem_wr_o<=LOW;
									mem_rd_o<=LOW;
									branch_type_o<=BRJ_NOP;
			end case;
		end if;
	end process;

end Behavioral;

