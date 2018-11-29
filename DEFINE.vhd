--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package DEFINE is
	constant ZeroWord : std_logic_vector(15 downto 0) := "0000000000000000";
	constant Zero15   : std_logic_vector(14 downto 0) := "000000000000000";
	constant Zero8   : std_logic_vector(7 downto 0) := "00000000";
	constant Zero4   : std_logic_vector(3 downto 0) := "0000";
	constant OneWord  : std_logic_vector(15 downto 0) := "0000000000000001";
	

	constant RegAddrR0 : std_logic_vector(3  downto 0) := "0000";---0
	constant RegAddrR1 : std_logic_vector(3  downto 0) := "0001";
	constant RegAddrR2 : std_logic_vector(3  downto 0) := "0010";
	constant RegAddrR3 : std_logic_vector(3  downto 0) := "0011";
	constant RegAddrR4 : std_logic_vector(3  downto 0) := "0100";
	constant RegAddrR5 : std_logic_vector(3  downto 0) := "0101";
	constant RegAddrR6 : std_logic_vector(3  downto 0) := "0110";
	constant RegAddrR7 : std_logic_vector(3  downto 0) := "0111";---7
	constant RegAddrRA : std_logic_vector(3  downto 0) := "1000";---8
	constant RegAddrSP : std_logic_vector(3  downto 0) := "1001";---9
	constant RegAddrT  : std_logic_vector(3  downto 0) := "1010";---10
	constant RegAddrIH : std_logic_vector(3  downto 0) := "1011";---11
	constant RegAddrNOP : std_logic_vector(3  downto 0):="1100";---12
	constant RegAddrPC : std_logic_vector(3  downto 0):="1101";---12
	
	constant NopInst : std_logic_vector(15 downto 0) := "0000100000000000";
	
	constant EXE_ADDIU_OP : std_logic_vector(7 downto 0) := "00000010"; --2
	constant EXE_ADDIU3_OP : std_logic_vector(7 downto 0) := "00000011"; --3
	constant EXE_ADDSP3_OP : std_logic_vector(7 downto 0) := "00000100"; --4
	constant EXE_ADDSP_OP : std_logic_vector(7 downto 0) := "00000101"; --4
	constant EXE_ADDU_OP : std_logic_vector(7 downto 0) := "00000110"; --6
	constant EXE_AND_OP : std_logic_vector(7 downto 0) := "00000111"; --7
	constant EXE_CMP_OP : std_logic_vector(7 downto 0) := "00001101"; --13
	constant EXE_CMPI_OP : std_logic_vector(7 downto 0) := "00001110"; --14
	constant EXE_JALR_OP : std_logic_vector(7 downto 0) := "00010000"; -- 16
	constant EXE_JR_OP : std_logic_vector(7 downto 0) := "00010001"; -- 17
	constant EXE_JRRA_OP : std_logic_vector(7 downto 0) := "00010010"; -- 18
	constant EXE_LI_OP : std_logic_vector(7 downto 0) := "00010011"; --19
	constant EXE_LW_OP : std_logic_vector(7 downto 0) := "00010100"; --20
	constant EXE_LW_SP_OP : std_logic_vector(7 downto 0) := "00010101"; --21
	constant EXE_MFIH_OP : std_logic_vector(7 downto 0) := "00010110"; --22
	constant EXE_MFPC_OP : std_logic_vector(7 downto 0) := "00010111"; --23
	constant EXE_MOVE_OP : std_logic_vector(7 downto 0) := "00011000"; --24
	constant EXE_MTIH_OP : std_logic_vector(7 downto 0) := "00011001"; --25
	constant EXE_MTSP_OP : std_logic_vector(7 downto 0) := "00011010"; --26
	constant EXE_NEG_OP : std_logic_vector(7 downto 0) := "00011011"; --27
	constant EXE_NOT_OP : std_logic_vector(7 downto 0) := "00011100"; --28
	constant EXE_NOP_OP : std_logic_vector(7 downto 0) := "00011101"; --29
	constant EXE_OR_OP : std_logic_vector(7 downto 0) := "00011110"; --30
	constant EXE_SLL_OP : std_logic_vector(7 downto 0) := "00011111"; --31
	constant EXE_SLLV_OP : std_logic_vector(7 downto 0) := "00100000"; --32
	constant EXE_SLT_OP : std_logic_vector(7 downto 0) := "00100001"; --33
	constant EXE_SLTI_OP : std_logic_vector(7 downto 0) := "00100010"; --34
	constant EXE_SLTU_OP : std_logic_vector(7 downto 0) := "00100011"; --35
	constant EXE_SLTUI_OP : std_logic_vector(7 downto 0) := "00100100"; --36
	constant EXE_SRA_OP : std_logic_vector(7 downto 0) := "00100101"; --37
	constant EXE_SRAV_OP : std_logic_vector(7 downto 0) := "00100110"; --38
	constant EXE_SRL_OP : std_logic_vector(7 downto 0) := "00100111"; --39
	constant EXE_SRLV_OP : std_logic_vector(7 downto 0) := "00101000"; --40
	constant EXE_SUBU_OP : std_logic_vector(7 downto 0) := "00101001"; --41
	constant EXE_SW_OP : std_logic_vector(7 downto 0) := "00101010"; --42
	constant EXE_SW_RS_OP : std_logic_vector(7 downto 0) := "00101011"; --43
	constant EXE_SW_SP : std_logic_vector(7 downto 0) := "00101100"; --44
	constant EXE_XOR_OP : std_logic_vector(7 downto 0) := "00101101"; --45

	constant HIGH : std_logic:='1';
	constant LOW  : std_logic:='0';
 
	constant OP_NOP: std_logic_vector(3 downto 0):="0000";
	constant OP_ADD: std_logic_vector(3 downto 0):="0001";
	constant OP_SUB: std_logic_vector(3 downto 0):="0010";
	constant OP_AND: std_logic_vector(3 downto 0):="0011";
	constant OP_OR : std_logic_vector(3 downto 0):="0100";
	constant OP_CMP: std_logic_vector(3 downto 0):="0101";
	constant OP_NOT: std_logic_vector(3 downto 0):="0110";
	constant OP_SLL: std_logic_vector(3 downto 0):="0111";
	constant OP_SLT_S: std_logic_vector(3 downto 0):="1000";
	constant OP_SLT_U: std_logic_vector(3 downto 0):="1001";
	constant OP_SRL: std_logic_vector(3 downto 0):="1010";
	constant OP_SRA: std_logic_vector(3 downto 0):="1011";
	constant OP_XOR: std_logic_vector(3 downto 0):="1100";

	constant ENABLE : std_logic:='1';
	constant DISABLE  : std_logic:='0';
	
	constant EXTEND_NOP :std_logic_vector(3 downto 0):="0000";
	constant EXTEND_7S0 :std_logic_vector(3 downto 0):="0001";
	constant EXTEND_3S0 :std_logic_vector(3 downto 0):="0010";
	constant EXTEND_PC10S0:std_logic_vector(3 downto 0):="0011";
	constant EXTEND_PC7S0:std_logic_vector(3 downto 0):="0100";
	constant EXTEND_7Z0 :std_logic_vector(3 downto 0):="0101";
	constant EXTEND_4S0 :std_logic_vector(3 downto 0):="0110";
	constant EXTEND_PC :std_logic_vector(3 downto 0):="0111";
	constant EXTEND_4Z2_Z8:std_logic_vector(3 downto 0):="1000";
	
	constant BRJ_NOP	:std_logic_vector(2 downto 0):="000";
	constant BRJ_BEQZ	:std_logic_vector(2 downto 0):="001";	--if reg1==0 PC<=extend
	constant BRJ_BNEZ	:std_logic_vector(2 downto 0):="010";	--if reg1!=0 PC<=extend
	constant BRJ_JR	:std_logic_vector(2 downto 0):="011";	--PC<=reg1
	constant BRJ_B		:std_logic_vector(2 downto 0):="100";	--PC<=extend
	
	constant MEM_MUX_ALU_RESULT:std_logic:='0';
	constant MEM_MUX_MEM_OUT:std_logic:='1';
end DEFINE;

package body DEFINE is
end DEFINE;
