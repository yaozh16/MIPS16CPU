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

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end DEFINE;

package body DEFINE is
	constant ZeroWord : std_logic_vector(15 downto 0) := "0000000000000000";
	constant RegAddrZero : std_logic_vector(3  downto 0) := "0000";
	constant RegAddrR0 : std_logic_vector(3  downto 0) := "1000";
	constant RegAddrR1 : std_logic_vector(3  downto 0) := "1000";
	constant RegAddrR2 : std_logic_vector(3  downto 0) := "1000";
	constant RegAddrR3 : std_logic_vector(3  downto 0) := "1000";
	constant RegAddrR4 : std_logic_vector(3  downto 0) := "1000";
	constant RegAddrR5 : std_logic_vector(3  downto 0) := "1000";
	constant RegAddrR6 : std_logic_vector(3  downto 0) := "1000";
	constant RegAddrR7 : std_logic_vector(3  downto 0) := "1000";
	constant RegAddrRA : std_logic_vector(3  downto 0) := "0001";
	constant RegAddrSP : std_logic_vector(3  downto 0) := "0010";
	constant RegAddrT  : std_logic_vector(3  downto 0) := "0011";
	constant RegAddrIH : std_logic_vector(3  downto 0) := "0100";
	
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
	constant EXE_LI_OP : std_logic_vector(7 downto 0) := "00010011"; --19
	constant EXE_LW : std_logic_vector(7 downto 0) := "00010100"; --20
	constant EXE_LW_SP : std_logic_vector(7 downto 0) := "00010101"; --21
	constant EXE_MFIH : std_logic_vector(7 downto 0) := "00010110"; --22
	constant EXE_MFPC : std_logic_vector(7 downto 0) := "00010111"; --23
	constant EXE_MOVE_OP : std_logic_vector(7 downto 0) := "00011000"; --24
	constant EXE_MTIH : std_logic_vector(7 downto 0) := "00011001"; --25
	constant EXE_MTSP : std_logic_vector(7 downto 0) := "00011010"; --26
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
	constant EXE_SW : std_logic_vector(7 downto 0) := "00101010"; --42
	constant EXE_SW_RS : std_logic_vector(7 downto 0) := "00101011"; --43
	constant EXE_SW_SP : std_logic_vector(7 downto 0) := "00101100"; --44
	constant EXE_XOR_OP : std_logic_vector(7 downto 0) := "00101101"; --45

	constant HIGH : std_logic:='1';
	constant LOW  : std_logic:='0';
	constant ENABLE : std_logic:='1';
	constant DISABLE  : std_logic:='0';
 
end DEFINE;
