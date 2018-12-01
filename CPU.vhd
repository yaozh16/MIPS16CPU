----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:15:49 11/29/2018 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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

entity CPU is
	port(
		clk:in std_logic;
		rst:in std_logic;
		
		Ram1Data_INST_ROM:inout std_logic_vector(15 downto 0);
		Ram1Addr_INST_ROM:out std_logic_vector(17 downto 0);
		Ram1OE_INST_ROM:out std_logic;
		Ram1WE_INST_ROM:out std_logic;
		Ram1EN_INST_ROM:out std_logic;
		
		
		Ram2Data_INST_ROM:inout std_logic_vector(15 downto 0);
		Ram2Addr_INST_ROM:out std_logic_vector(17 downto 0);
		Ram2OE_INST_ROM:out std_logic;
		Ram2WE_INST_ROM:out std_logic;
		Ram2EN_INST_ROM:out std_logic;
		
		display1:out std_logic_vector(15 downto 0);
		display2:out std_logic_vector(15 downto 0);
		display3:out std_logic_vector(15 downto 0);
		display4:out std_logic_vector(15 downto 0);
		display5:out std_logic_vector(15 downto 0);
		display6:out std_logic_vector(15 downto 0)
		
		
		
	);
end CPU;

architecture Behavioral of CPU is
---pipeline compoonents
component PCIF
port (
  clk           : in  std_logic;
  rst           : in  std_logic;
  LW_stall_i    : in  std_logic;
  branch_addr_i : in  std_logic_vector(15 downto 0);
  branch_flag_i : in  std_logic;
  pc_o          : out std_logic_vector(15 downto 0);
  instruction_i : in  std_logic_vector(15 downto 0);
  id_succ_i     : in std_logic;
  instruction_o : out std_logic_vector(15 downto 0) ---connected to registers between parts
);
end component PCIF;
component RF
port (
  clk                  : in  std_logic;
  pc_i 					  : in  std_logic_vector(15 downto 0);
  instr_i              : in  std_logic_vector(15 downto 0);
  stall_i              : in  std_logic;
  reg_dest_i           : in  std_logic_vector(3 downto 0);
  reg_wdata_i          : in  std_logic_vector(15 downto 0);
  branch_type_o        : out std_logic_vector(2 downto 0);
  exe_aluop_o          : out std_logic_vector(3 downto 0);
  exe_mux1_o           : out std_logic;
  exe_mux2_o           : out std_logic;
  reg_src_data1_o      : out std_logic_vector(15 downto 0);
  reg_src_data2_o      : out std_logic_vector(15 downto 0);
  reg_src_addr1_o      : out std_logic_vector(3 downto 0);
  reg_src_addr2_o      : out std_logic_vector(3 downto 0);
  extended_o           : out std_logic_vector(15 downto 0);
  reg_dest_o           : out std_logic_vector(3 downto 0);
  mem_rd_o             : out std_logic;
  mem_wr_o             : out std_logic;
  writeback_mux_o      : out std_logic
);
end component RF;
component EXE_FF
port (
  reg_src1_data_i        : in  std_logic_vector(15 downto 0);
  reg_src2_data_i        : in  std_logic_vector(15 downto 0);
  reg_exemem_dest_data_i : in  std_logic_vector(15 downto 0);
  reg_memwb_dest_data_i  : in  std_logic_vector(15 downto 0);
  reg_src1_addr_i        : in  std_logic_vector(3 downto 0);
  reg_src2_addr_i        : in  std_logic_vector(3 downto 0);
  reg_exemem_dest_addr_i : in  std_logic_vector(3 downto 0);
  reg_memwb_dest_addr_i  : in  std_logic_vector(3 downto 0);
  reg_src1_data_o        : out std_logic_vector(15 downto 0);
  reg_src2_data_o        : out std_logic_vector(15 downto 0)
);
end component EXE_FF;

component EXE
port (
  exe_aluop_i     : in  std_logic_vector(3 downto 0);
  exe_mux1_i      : in  std_logic;
  exe_mux2_i      : in  std_logic;
  reg_src1_data_i : in  std_logic_vector(15 downto 0);
  reg_src2_data_i : in  std_logic_vector(15 downto 0);
  extended_i      : in  std_logic_vector(15 downto 0);
  branch_type_i   : in  std_logic_vector(2 downto 0);
  branch_flag_o   : out std_logic;
  branch_addr_o   : out std_logic_vector(15 downto 0);
  ALU_result_o    : out std_logic_vector(15 downto 0);
  reg_dest_i      : in  std_logic_vector(3 downto 0);
  reg_dest_o      : out std_logic_vector(3 downto 0);
  mem_wr_i        : in  std_logic;
  mem_wr_o        : out std_logic;
  mem_rd_i        : in  std_logic;
  mem_rd_o        : out std_logic;
  writeback_mux_i : in  std_logic;
  writeback_mux_o : out std_logic;
  mem_wdata_o     : out std_logic_vector(15 downto 0)
);
end component EXE;
component MEM
port (
  rst              : in  std_logic;
  reg_dest_i       : in  std_logic_vector(3 downto 0);
  mem_wr_i         : in  std_logic;
  mem_rd_i         : in  std_logic;
  ALU_result_i     : in  std_logic_vector(15 downto 0);
  mem_wdata_i      : in  std_logic_vector(15 downto 0);
  writeback_mux_i  : in  std_logic;
  mem_wr_o         : out std_logic;
  mem_rd_o         : out std_logic;
  mem_addr_o       : out std_logic_vector(15 downto 0);
  mem_wdata_o      : out std_logic_vector(15 downto 0);
  mem_rdata_i      : in  std_logic_vector(15 downto 0);
  reg_dest_o       : out std_logic_vector(3 downto 0);
  writeback_data_o : out std_logic_vector(15 downto 0)----connect to reg between parts
);
end component MEM;
component StallFlushCtrlUnit
port (
  branch_flag_i          : in  std_logic;
  mem_rd_i_EXE_MEM       : in  std_logic;
  reg_exemem_dest_addr_i : in  std_logic_vector(3 downto 0);
  reg_src_addr1_i        : in  std_logic_vector(3 downto 0);
  reg_src_addr2_i        : in  std_logic_vector(3 downto 0);
  RegStalls_o            : out std_logic_vector(4 downto 0);
  RegFlushs_o            : out std_logic_vector(3 downto 0)
);
end component StallFlushCtrlUnit;
component INST_ROM
port (
  clk         : in  std_logic;
  rst         : in  std_logic;
  id_addr_i   : in  std_logic_vector (15 downto 0);
  id_inst_o   : out std_logic_vector (15 downto 0); 
  id_succ_o   : std_logic;
  mem_wr_i    : in  std_logic;
  mem_rd_i    : in  std_logic;
  mem_addr_i  : in  std_logic_vector(15 downto 0);
  mem_wdata_i : in  std_logic_vector(15 downto 0);
  mem_rdata_o : out std_logic_vector(15 downto 0);
  Ram1Addr    : out std_logic_vector(17 downto 0);
  Ram1Data    : inout std_logic_vector(15 downto 0);
  Ram1OE      : out std_logic;
  Ram1WE      : out std_logic;
  Ram1EN      : out std_logic;
  Ram2Addr    : out std_logic_vector(17 downto 0);
  Ram2Data    : inout std_logic_vector(15 downto 0);
  Ram2OE      : out std_logic;
  Ram2WE      : out std_logic;
  Ram2EN      : out std_logic
);
end component INST_ROM;


---pipeline registers
component Reg_id_rf
port (
  rst           : in  std_logic;
  clk           : in  std_logic;
  flush         : in  std_logic;
  stall         : in  std_logic;
  instruction_i : in  std_logic_vector(15 downto 0);
  instruction_o : out std_logic_vector(15 downto 0);
  pc_i          : in  std_logic_vector(15 downto 0);
  pc_o          : out std_logic_vector(15 downto 0)
);
end component Reg_id_rf;
component Reg_rf_exe
port (
  rst             : in  std_logic;
  clk             : in  std_logic;
  flush           : in  std_logic;
  stall           : in  std_logic;
  branch_type_i   : in  std_logic_vector(2 downto 0);
  exe_aluop_i     : in  std_logic_vector(3 downto 0);
  exe_mux1_i      : in  std_logic;
  exe_mux2_i      : in  std_logic;
  reg_src_data1_i : in  std_logic_vector(15 downto 0);
  reg_src_data2_i : in  std_logic_vector(15 downto 0);
  reg_src_addr1_i : in  std_logic_vector(3 downto 0);
  reg_src_addr2_i : in  std_logic_vector(3 downto 0);
  extended_i      : in  std_logic_vector(15 downto 0);
  reg_dest_i      : in  std_logic_vector(3 downto 0);
  mem_rd_i        : in  std_logic;
  mem_wr_i        : in  std_logic;
  writeback_mux_i : in  std_logic;
  branch_type_o   : out std_logic_vector(2 downto 0);
  exe_aluop_o     : out std_logic_vector(3 downto 0);
  exe_mux1_o      : out std_logic;
  exe_mux2_o      : out std_logic;
  reg_src_data1_o : out std_logic_vector(15 downto 0);
  reg_src_data2_o : out std_logic_vector(15 downto 0);
  reg_src_addr1_o : out std_logic_vector(3 downto 0);
  reg_src_addr2_o : out std_logic_vector(3 downto 0);
  extended_o      : out std_logic_vector(15 downto 0);
  reg_dest_o      : out std_logic_vector(3 downto 0);
  mem_rd_o        : out std_logic;
  mem_wr_o        : out std_logic;
  writeback_mux_o : out std_logic
);
end component Reg_rf_exe;
component Reg_exe_mem
port (
  rst             : in  std_logic;
  clk             : in  std_logic;
  flush           : in  std_logic;
  stall           : in  std_logic;
  ALU_result_i    : in  std_logic_vector(15 downto 0);
  reg_dest_i      : in  std_logic_vector(3 downto 0);
  mem_rd_i        : in  std_logic;
  mem_wr_i        : in  std_logic;
  writeback_mux_i : in  std_logic;
  mem_wdata_i     : in  std_logic_vector(15 downto 0);
  ALU_result_o    : out std_logic_vector(15 downto 0);
  reg_dest_o      : out std_logic_vector(3 downto 0);
  mem_rd_o        : out std_logic;
  mem_wr_o        : out std_logic;
  writeback_mux_o : out std_logic;
  mem_wdata_o     : out std_logic_vector(15 downto 0)
);
end component Reg_exe_mem;
component Reg_mem_wb
port (
  rst              : in  std_logic;
  clk              : in  std_logic;
  flush            : in  std_logic;
  stall            : in  std_logic;
  reg_dest_i       : in  std_logic_vector(3 downto 0);
  writeback_data_i : in  std_logic_vector(15 downto 0);
  reg_dest_o       : out std_logic_vector(3 downto 0);
  writeback_data_o : out std_logic_vector(15 downto 0)
);
end component Reg_mem_wb;















---signals
---PCIF
signal clk_PCIF:   std_logic;
signal rst_PCIF:   std_logic;
signal LW_stall_i_PCIF:  std_logic;
signal branch_addr_i_PCIF:  std_logic_vector(15 downto 0);
signal branch_flag_i_PCIF:  std_logic;
signal pc_o_PCIF:  std_logic_vector(15 downto 0);	---connected to memory unit;
signal instruction_i_PCIF:  std_logic_vector(15 downto 0);	---connected to memory unit;
signal id_succ_i_PCIF: std_logic;
signal instruction_o_PCIF:  std_logic_vector(15 downto 0); ---connected to registers between parts;

---EXE
signal exe_aluop_i_EXE:  std_logic_vector(3 downto 0);---ALU operation;
signal exe_mux1_i_EXE:  std_logic;
signal exe_mux2_i_EXE:  std_logic;
signal reg_src1_data_i_EXE:  std_logic_vector(15 downto 0);
signal reg_src2_data_i_EXE:  std_logic_vector(15 downto 0);
signal extended_i_EXE:  std_logic_vector(15 downto 0);
signal branch_type_i_EXE:  std_logic_vector(2 downto 0);
signal branch_flag_o_EXE:  std_logic;
signal branch_addr_o_EXE:  std_logic_vector(15 downto 0);
signal ALU_result_o_EXE:  std_logic_vector(15 downto 0);
signal reg_dest_i_EXE:  std_logic_vector(3 downto 0);
signal reg_dest_o_EXE:  std_logic_vector(3 downto 0);
signal mem_wr_i_EXE:  std_logic;
signal mem_wr_o_EXE:  std_logic;
signal mem_rd_i_EXE:  std_logic;
signal mem_rd_o_EXE:  std_logic;
signal writeback_mux_i_EXE:  std_logic;
signal writeback_mux_o_EXE:  std_logic;
signal mem_wdata_o_EXE:  std_logic_vector(15 downto 0);

---EXE_FF
signal reg_src1_data_i_EXE_FF:  std_logic_vector(15 downto 0);
signal reg_src2_data_i_EXE_FF:  std_logic_vector(15 downto 0);
signal reg_exemem_dest_data_i_EXE_FF:  std_logic_vector(15 downto 0);
signal reg_memwb_dest_data_i_EXE_FF:  std_logic_vector(15 downto 0);
signal reg_src1_addr_i_EXE_FF:  std_logic_vector(3 downto 0);
signal reg_src2_addr_i_EXE_FF:  std_logic_vector(3 downto 0);
signal reg_exemem_dest_addr_i_EXE_FF:  std_logic_vector(3 downto 0);
signal reg_memwb_dest_addr_i_EXE_FF:  std_logic_vector(3 downto 0);
signal reg_src1_data_o_EXE_FF:  std_logic_vector(15 downto 0);
signal reg_src2_data_o_EXE_FF:  std_logic_vector(15 downto 0);

---INST_ROM
signal clk_INST_ROM:  std_logic;
signal rst_INST_ROM:  std_logic;
signal id_addr_i_INST_ROM:  std_logic_vector (15 downto 0);	---pc;
signal id_succ_i_INST_ROM:   std_logic;
signal id_inst_o_INST_ROM:  std_logic_vector (15 downto 0);	---returned id;
signal mem_wr_i_INST_ROM:  std_logic;		---mem ctrl signal;
signal mem_rd_i_INST_ROM:  std_logic;		---mem ctrl signal;
signal mem_addr_i_INST_ROM:   std_logic_vector(15 downto 0);		---mem signal;
signal mem_wdata_i_INST_ROM:   std_logic_vector(15 downto 0);		---mem signal;
signal mem_rdata_o_INST_ROM:  std_logic_vector(15 downto 0);
--signal Ram1Addr_INST_ROM:   std_logic_vector(17 downto 0);
--signal Ram1Data_INST_ROM:    std_logic_vector(15 downto 0);
--signal Ram1OE_INST_ROM:   std_logic;
--signal Ram1WE_INST_ROM:   std_logic;
--signal Ram1EN_INST_ROM:   std_logic;
--signal Ram2Addr_INST_ROM:   std_logic_vector(17 downto 0);
--signal Ram2Data_INST_ROM:    std_logic_vector(15 downto 0);
--signal Ram2OE_INST_ROM:   std_logic;
--signal Ram2WE_INST_ROM:   std_logic;
--signal Ram2EN_INST_ROM:   std_logic;

---MEM
signal rst_MEM:  std_logic;
signal reg_dest_i_MEM:  std_logic_vector(3 downto 0);		--- herit;
signal mem_wr_i_MEM:  std_logic;									---connect to reg between parts,write signal;
signal mem_rd_i_MEM:  std_logic;									---connect to reg between parts,read signal;
signal ALU_result_i_MEM:   std_logic_vector(15 downto 0);		---connect to reg between parts,ALU result;
signal mem_wdata_i_MEM:   std_logic_vector(15 downto 0);		---connect to reg beween parts,oper2;
signal writeback_mux_i_MEM:  std_logic;
signal mem_wr_o_MEM:  std_logic;									---connect to memory unit;
signal mem_rd_o_MEM:  std_logic;									---connect to memory unit;
signal mem_addr_o_MEM:   std_logic_vector(15 downto 0);		---connect to memory unit;
signal mem_wdata_o_MEM:  std_logic_vector(15 downto 0);		---connect to memory unit;
signal mem_rdata_i_MEM:  std_logic_vector(15 downto 0);		---connect to memory unit;
signal reg_dest_o_MEM:  std_logic_vector(3 downto 0);		--- herit;
signal writeback_data_o_MEM:   std_logic_vector(15 downto 0);----connect to reg between parts;

---Reg_exe_mem
signal rst_Reg_exe_mem:  std_logic;
signal clk_Reg_exe_mem:  std_logic;
signal flush_Reg_exe_mem:  std_logic;
signal stall_Reg_exe_mem:  std_logic;
signal ALU_result_i_Reg_exe_mem:  std_logic_vector(15 downto 0);
signal reg_dest_i_Reg_exe_mem:  std_logic_vector(3 downto 0);
signal mem_rd_i_Reg_exe_mem:  std_logic;
signal mem_wr_i_Reg_exe_mem:  std_logic;
signal writeback_mux_i_Reg_exe_mem:  std_logic;
signal mem_wdata_i_Reg_exe_mem:  std_logic_vector(15 downto 0);
signal ALU_result_o_Reg_exe_mem:  std_logic_vector(15 downto 0);
signal reg_dest_o_Reg_exe_mem:  std_logic_vector(3 downto 0);
signal mem_rd_o_Reg_exe_mem:  std_logic;
signal mem_wr_o_Reg_exe_mem:  std_logic;
signal writeback_mux_o_Reg_exe_mem:  std_logic;
signal mem_wdata_o_Reg_exe_mem:  std_logic_vector(15 downto 0);

---Reg_id_rf
signal rst_Reg_id_rf:  std_logic;
signal clk_Reg_id_rf:  std_logic;
signal flush_Reg_id_rf:  std_logic;
signal stall_Reg_id_rf:  std_logic;
signal instruction_i_Reg_id_rf:  std_logic_vector(15 downto 0);
signal instruction_o_Reg_id_rf:  std_logic_vector(15 downto 0);
signal pc_i_Reg_id_rf:  std_logic_vector(15 downto 0);
signal pc_o_Reg_id_rf:  std_logic_vector(15 downto 0);

---Reg_mem_wb
signal rst_Reg_mem_wb:  std_logic;
signal clk_Reg_mem_wb:  std_logic;
signal flush_Reg_mem_wb:  std_logic;
signal stall_Reg_mem_wb:  std_logic;
signal reg_dest_i_Reg_mem_wb:  std_logic_vector(3 downto 0);	
signal writeback_data_i_Reg_mem_wb:   std_logic_vector(15 downto 0);
signal reg_dest_o_Reg_mem_wb:  std_logic_vector(3 downto 0);	
signal writeback_data_o_Reg_mem_wb:   std_logic_vector(15 downto 0);

---Reg_rf_exe
signal rst_Reg_rf_exe:  std_logic;
signal clk_Reg_rf_exe:  std_logic;
signal flush_Reg_rf_exe:  std_logic;
signal stall_Reg_rf_exe:  std_logic;
signal branch_type_i_Reg_rf_exe:  std_logic_vector(2 downto 0);
signal exe_aluop_i_Reg_rf_exe:  std_logic_vector(3 downto 0);---ALU operation;
signal exe_mux1_i_Reg_rf_exe:  std_logic;	--reg or 0;
signal exe_mux2_i_Reg_rf_exe:  std_logic;  --reg or extended                                                                                                                 ;
signal reg_src_data1_i_Reg_rf_exe:  std_logic_vector(15 downto 0);
signal reg_src_data2_i_Reg_rf_exe:  std_logic_vector(15 downto 0);
signal reg_src_addr1_i_Reg_rf_exe:  std_logic_vector(3 downto 0);
signal reg_src_addr2_i_Reg_rf_exe:  std_logic_vector(3 downto 0);
signal extended_i_Reg_rf_exe:  std_logic_vector(15 downto 0);
signal reg_dest_i_Reg_rf_exe:  std_logic_vector(3 downto 0);
signal mem_rd_i_Reg_rf_exe:  std_logic;
signal mem_wr_i_Reg_rf_exe:  std_logic;
signal writeback_mux_i_Reg_rf_exe:  std_logic;
signal branch_type_o_Reg_rf_exe:  std_logic_vector(2 downto 0);
signal exe_aluop_o_Reg_rf_exe:  std_logic_vector(3 downto 0);---ALU operation;
signal exe_mux1_o_Reg_rf_exe:  std_logic;	--reg or 0;
signal exe_mux2_o_Reg_rf_exe:  std_logic;  --reg or extended                                                                                                                 ;
signal reg_src_data1_o_Reg_rf_exe:  std_logic_vector(15 downto 0);
signal reg_src_data2_o_Reg_rf_exe:  std_logic_vector(15 downto 0);
signal reg_src_addr1_o_Reg_rf_exe:  std_logic_vector(3 downto 0);
signal reg_src_addr2_o_Reg_rf_exe:  std_logic_vector(3 downto 0);
signal extended_o_Reg_rf_exe:  std_logic_vector(15 downto 0);
signal reg_dest_o_Reg_rf_exe:  std_logic_vector(3 downto 0);
signal mem_rd_o_Reg_rf_exe:  std_logic;
signal mem_wr_o_Reg_rf_exe:  std_logic;
signal writeback_mux_o_Reg_rf_exe:  std_logic;

---RF
signal clk_RF:  std_logic;
signal  pc_i_RF:  std_logic_vector(15 downto 0);
signal instr_i_RF:   std_logic_vector(15 downto 0);
signal stall_i_RF:  std_logic;	---last branch success;
signal reg_dest_i_RF:  std_logic_vector(3 downto 0);---write back;
signal reg_wdata_i_RF:  std_logic_vector(15 downto 0);---write back;
signal branch_type_o_RF:  std_logic_vector(2 downto 0);
signal exe_aluop_o_RF:  std_logic_vector(3 downto 0);---ALU operation;
signal exe_mux1_o_RF:  std_logic;	--reg or 0;
signal exe_mux2_o_RF:  std_logic;  --reg or extended                                                                                                                 ;
signal reg_src_data1_o_RF:  std_logic_vector(15 downto 0);
signal reg_src_data2_o_RF:  std_logic_vector(15 downto 0);
signal reg_src_addr1_o_RF:  std_logic_vector(3 downto 0);
signal reg_src_addr2_o_RF:  std_logic_vector(3 downto 0);
signal extended_o_RF:  std_logic_vector(15 downto 0);
signal reg_dest_o_RF:  std_logic_vector(3 downto 0);
signal mem_rd_o_RF:  std_logic;
signal mem_wr_o_RF:  std_logic;
signal writeback_mux_o_RF:  std_logic;


---StallFlushCtrlUnit
signal branch_flag_i_StallFlushCtrlUnit:  std_logic;	---from EXE;
signal mem_rd_i_EXE_MEM_StallFlushCtrlUnit:  std_logic;									-- from exe_mem_regs;
signal reg_exemem_dest_addr_i_StallFlushCtrlUnit:  std_logic_vector(3 downto 0);	-- from exe_mem_regs;
signal reg_src_addr1_i_StallFlushCtrlUnit:  std_logic_vector(3 downto 0);		---from rf_exe regs;
signal reg_src_addr2_i_StallFlushCtrlUnit:  std_logic_vector(3 downto 0);		-- from rf_exe regs;
signal RegStalls_o_StallFlushCtrlUnit:  std_logic_vector(4 downto 0);
signal RegFlushs_o_StallFlushCtrlUnit:  std_logic_vector(3 downto 0);





















begin

display1<=pc_o_PCIF;
display2<=instruction_o_PCIF;
display3<=instruction_o_Reg_id_rf;
display4<=extended_o_RF;
display5<=reg_src_addr1_o_RF&"11111111"&reg_src_addr2_o_RF;
---PCIF
PCIF_component:PCIF port map(
	clk=>clk_PCIF,
	rst=>rst_PCIF,
	LW_stall_i=>LW_stall_i_PCIF,
	branch_addr_i=>branch_addr_i_PCIF,
	branch_flag_i=>branch_flag_i_PCIF,
	pc_o=>pc_o_PCIF,
	instruction_i=>instruction_i_PCIF,
	id_succ_i=>id_succ_i_PCIF,
	instruction_o=>instruction_o_PCIF
);
clk_PCIF<=clk;
rst_PCIF<=rst;
LW_stall_i_PCIF<=RegStalls_o_StallFlushCtrlUnit(0);
branch_addr_i_PCIF<=branch_addr_o_EXE;
branch_flag_i_PCIF<=branch_flag_o_EXE;
instruction_i_PCIF<=id_inst_o_INST_ROM;
id_succ_i_PCIF<=id_succ_o_INST_ROM;
---RF
RF_component:RF port map(
	clk=>clk_RF,
	pc_i=>pc_i_RF,
	instr_i=>instr_i_RF,
	stall_i=>stall_i_RF,
	reg_dest_i=>reg_dest_i_RF,
	reg_wdata_i=>reg_wdata_i_RF,
	branch_type_o=>branch_type_o_RF,
	exe_aluop_o=>exe_aluop_o_RF,
	exe_mux1_o=>exe_mux1_o_RF,
	exe_mux2_o=>exe_mux2_o_RF,
	reg_src_data1_o=>reg_src_data1_o_RF,
	reg_src_data2_o=>reg_src_data2_o_RF,
	reg_src_addr1_o=>reg_src_addr1_o_RF,
	reg_src_addr2_o=>reg_src_addr2_o_RF,
	extended_o=>extended_o_RF,
	reg_dest_o=>reg_dest_o_RF,
	mem_rd_o=>mem_rd_o_RF,
	mem_wr_o=>mem_wr_o_RF,
	writeback_mux_o=>writeback_mux_o_RF
);

clk_RF<=clk;
 pc_i_RF<=pc_i_Reg_id_rf;
instr_i_RF<=instruction_o_Reg_id_rf;
stall_i_RF<=RegStalls_o_StallFlushCtrlUnit(1);
reg_dest_i_RF<=reg_dest_o_Reg_mem_wb;
reg_wdata_i_RF<=writeback_data_o_Reg_mem_wb;
---EXE
EXE_component:EXE port map(
	exe_aluop_i=>exe_aluop_i_EXE,
	exe_mux1_i=>exe_mux1_i_EXE,
	exe_mux2_i=>exe_mux2_i_EXE,
	reg_src1_data_i=>reg_src1_data_i_EXE,
	reg_src2_data_i=>reg_src2_data_i_EXE,
	extended_i=>extended_i_EXE,
	branch_type_i=>branch_type_i_EXE,
	branch_flag_o=>branch_flag_o_EXE,
	branch_addr_o=>branch_addr_o_EXE,
	ALU_result_o=>ALU_result_o_EXE,
	reg_dest_i=>reg_dest_i_EXE,
	reg_dest_o=>reg_dest_o_EXE,
	mem_wr_i=>mem_wr_i_EXE,
	mem_wr_o=>mem_wr_o_EXE,
	mem_rd_i=>mem_rd_i_EXE,
	mem_rd_o=>mem_rd_o_EXE,
	writeback_mux_i=>writeback_mux_i_EXE,
	writeback_mux_o=>writeback_mux_o_EXE,
	mem_wdata_o=>mem_wdata_o_EXE
);

exe_aluop_i_EXE<=exe_aluop_o_Reg_rf_exe;
exe_mux1_i_EXE<=exe_mux1_o_Reg_rf_exe;
exe_mux2_i_EXE<=exe_mux2_o_Reg_rf_exe;
reg_src1_data_i_EXE<=reg_src1_data_o_EXE_FF;
reg_src2_data_i_EXE<=reg_src2_data_o_EXE_FF;
extended_i_EXE<=extended_o_Reg_rf_exe;
branch_type_i_EXE<=branch_type_i_Reg_rf_exe;
reg_dest_i_EXE<=reg_dest_o_Reg_rf_exe;
mem_wr_i_EXE<=mem_wr_o_Reg_rf_exe;
mem_rd_i_EXE<=mem_rd_o_Reg_rf_exe;
writeback_mux_i_EXE<=writeback_mux_o_Reg_rf_exe;

---EXE_FF
EXE_FF_component:EXE_FF port map(
	reg_src1_data_i=>reg_src1_data_i_EXE_FF,
	reg_src2_data_i=>reg_src2_data_i_EXE_FF,
	reg_exemem_dest_data_i=>reg_exemem_dest_data_i_EXE_FF,
	reg_memwb_dest_data_i=>reg_memwb_dest_data_i_EXE_FF,
	reg_src1_addr_i=>reg_src1_addr_i_EXE_FF,
	reg_src2_addr_i=>reg_src2_addr_i_EXE_FF,
	reg_exemem_dest_addr_i=>reg_exemem_dest_addr_i_EXE_FF,
	reg_memwb_dest_addr_i=>reg_memwb_dest_addr_i_EXE_FF,
	reg_src1_data_o=>reg_src1_data_o_EXE_FF,
	reg_src2_data_o=>reg_src2_data_o_EXE_FF
);

reg_src1_data_i_EXE_FF<=reg_src_data1_o_Reg_rf_exe;
reg_src2_data_i_EXE_FF<=reg_src_data2_o_Reg_rf_exe;
reg_exemem_dest_data_i_EXE_FF<=ALU_result_i_Reg_exe_mem;
reg_memwb_dest_data_i_EXE_FF<=writeback_data_o_Reg_mem_wb;
reg_src1_addr_i_EXE_FF<=reg_src_addr1_o_Reg_rf_exe;
reg_src2_addr_i_EXE_FF<=reg_src_addr2_o_Reg_rf_exe;
reg_exemem_dest_addr_i_EXE_FF<=reg_dest_o_Reg_exe_mem;
reg_memwb_dest_addr_i_EXE_FF<=reg_dest_o_Reg_mem_wb;

---INST_ROM
INST_ROM_component:INST_ROM port map(
	clk=>clk_INST_ROM,
	rst=>rst_INST_ROM,
	id_addr_i=>id_addr_i_INST_ROM,
	id_inst_o=>id_inst_o_INST_ROM,
	id_succ_o=>id_succ_o_INST_ROM,
	mem_wr_i=>mem_wr_i_INST_ROM,
	mem_rd_i=>mem_rd_i_INST_ROM,
	mem_addr_i=>mem_addr_i_INST_ROM,
	mem_wdata_i=>mem_wdata_i_INST_ROM,
	mem_rdata_o=>mem_rdata_o_INST_ROM,
	Ram1Addr=>Ram1Addr_INST_ROM,
	Ram1Data=>Ram1Data_INST_ROM,
	Ram1OE=>Ram1OE_INST_ROM,
	Ram1WE=>Ram1WE_INST_ROM,
	Ram1EN=>Ram1EN_INST_ROM,
	Ram2Addr=>Ram2Addr_INST_ROM,
	Ram2Data=>Ram2Data_INST_ROM,
	Ram2OE=>Ram2OE_INST_ROM,
	Ram2WE=>Ram2WE_INST_ROM,
	Ram2EN=>Ram2EN_INST_ROM
);

clk_INST_ROM<=clk;
rst_INST_ROM<=rst;
id_addr_i_INST_ROM<=pc_o_PCIF;
mem_wr_i_INST_ROM<=mem_wr_o_MEM;
mem_rd_i_INST_ROM<=mem_rd_o_MEM;
mem_addr_i_INST_ROM<=mem_addr_o_MEM;
mem_wdata_i_INST_ROM<=mem_wdata_o_MEM;

---MEM
MEM_component:MEM port map(
	rst=>rst_MEM,
	reg_dest_i=>reg_dest_i_MEM,
	mem_wr_i=>mem_wr_i_MEM,
	mem_rd_i=>mem_rd_i_MEM,
	ALU_result_i=>ALU_result_i_MEM,
	mem_wdata_i=>mem_wdata_i_MEM,
	writeback_mux_i=>writeback_mux_i_MEM,
	mem_wr_o=>mem_wr_o_MEM,
	mem_rd_o=>mem_rd_o_MEM,
	mem_addr_o=>mem_addr_o_MEM,
	mem_wdata_o=>mem_wdata_o_MEM,
	mem_rdata_i=>mem_rdata_i_MEM,
	reg_dest_o=>reg_dest_o_MEM,
	writeback_data_o=>writeback_data_o_MEM
);

rst_MEM<=rst;
reg_dest_i_MEM<=reg_dest_o_Reg_exe_mem;
mem_wr_i_MEM<=mem_wr_o_Reg_exe_mem;
mem_rd_i_MEM<=mem_rd_o_Reg_exe_mem;
ALU_result_i_MEM<=ALU_result_o_Reg_exe_mem;
mem_wdata_i_MEM<=mem_wdata_o_Reg_exe_mem;
writeback_mux_i_MEM<=writeback_mux_o_Reg_exe_mem;
mem_rdata_i_MEM<=mem_rdata_o_INST_ROM;

---Reg_exe_mem
Reg_exe_mem_component:Reg_exe_mem port map(
	rst=>rst_Reg_exe_mem,
	clk=>clk_Reg_exe_mem,
	flush=>flush_Reg_exe_mem,
	stall=>stall_Reg_exe_mem,
	ALU_result_i=>ALU_result_i_Reg_exe_mem,
	reg_dest_i=>reg_dest_i_Reg_exe_mem,
	mem_rd_i=>mem_rd_i_Reg_exe_mem,
	mem_wr_i=>mem_wr_i_Reg_exe_mem,
	writeback_mux_i=>writeback_mux_i_Reg_exe_mem,
	mem_wdata_i=>mem_wdata_i_Reg_exe_mem,
	ALU_result_o=>ALU_result_o_Reg_exe_mem,
	reg_dest_o=>reg_dest_o_Reg_exe_mem,
	mem_rd_o=>mem_rd_o_Reg_exe_mem,
	mem_wr_o=>mem_wr_o_Reg_exe_mem,
	writeback_mux_o=>writeback_mux_o_Reg_exe_mem,
	mem_wdata_o=>mem_wdata_o_Reg_exe_mem
);

rst_Reg_exe_mem<=rst;
clk_Reg_exe_mem<=clk;
flush_Reg_exe_mem<=RegFlushs_o_StallFlushCtrlUnit(2);
stall_Reg_exe_mem<=RegFlushs_o_StallFlushCtrlUnit(3);
ALU_result_i_Reg_exe_mem<=ALU_result_o_EXE;
reg_dest_i_Reg_exe_mem<=reg_dest_o_EXE;
mem_rd_i_Reg_exe_mem<=mem_rd_o_EXE;
mem_wr_i_Reg_exe_mem<=mem_wr_o_EXE;
writeback_mux_i_Reg_exe_mem<=writeback_mux_o_EXE;
mem_wdata_i_Reg_exe_mem<=mem_wdata_o_EXE;

---Reg_id_rf
Reg_id_rf_component:Reg_id_rf port map(
	rst=>rst_Reg_id_rf,
	clk=>clk_Reg_id_rf,
	flush=>flush_Reg_id_rf,
	stall=>stall_Reg_id_rf,
	instruction_i=>instruction_i_Reg_id_rf,
	instruction_o=>instruction_o_Reg_id_rf,
	pc_i=>pc_i_Reg_id_rf,
	pc_o=>pc_o_Reg_id_rf
);

rst_Reg_id_rf<=rst;
clk_Reg_id_rf<=clk;
flush_Reg_id_rf<=RegFlushs_o_StallFlushCtrlUnit(0);
stall_Reg_id_rf<=RegStalls_o_StallFlushCtrlUnit(1);
instruction_i_Reg_id_rf<=instruction_o_PCIF;
pc_i_Reg_id_rf<=pc_o_PCIF;

---Reg_mem_wb
Reg_mem_wb_component:Reg_mem_wb port map(
	rst=>rst_Reg_mem_wb,
	clk=>clk_Reg_mem_wb,
	flush=>flush_Reg_mem_wb,
	stall=>stall_Reg_mem_wb,
	reg_dest_i=>reg_dest_i_Reg_mem_wb,
	writeback_data_i=>writeback_data_i_Reg_mem_wb,
	reg_dest_o=>reg_dest_o_Reg_mem_wb,
	writeback_data_o=>writeback_data_o_Reg_mem_wb
);

rst_Reg_mem_wb<=rst;
clk_Reg_mem_wb<=clk;
flush_Reg_mem_wb<=RegFlushs_o_StallFlushCtrlUnit(3);
stall_Reg_mem_wb<=RegStalls_o_StallFlushCtrlUnit(4);
reg_dest_i_Reg_mem_wb<=reg_dest_o_MEM;
writeback_data_i_Reg_mem_wb<=writeback_data_o_MEM;

---Reg_rf_exe
Reg_rf_exe_component:Reg_rf_exe port map(
	rst=>rst_Reg_rf_exe,
	clk=>clk_Reg_rf_exe,
	flush=>flush_Reg_rf_exe,
	stall=>stall_Reg_rf_exe,
	branch_type_i=>branch_type_i_Reg_rf_exe,
	exe_aluop_i=>exe_aluop_i_Reg_rf_exe,
	exe_mux1_i=>exe_mux1_i_Reg_rf_exe,
	exe_mux2_i=>exe_mux2_i_Reg_rf_exe,
	reg_src_data1_i=>reg_src_data1_i_Reg_rf_exe,
	reg_src_data2_i=>reg_src_data2_i_Reg_rf_exe,
	reg_src_addr1_i=>reg_src_addr1_i_Reg_rf_exe,
	reg_src_addr2_i=>reg_src_addr2_i_Reg_rf_exe,
	extended_i=>extended_i_Reg_rf_exe,
	reg_dest_i=>reg_dest_i_Reg_rf_exe,
	mem_rd_i=>mem_rd_i_Reg_rf_exe,
	mem_wr_i=>mem_wr_i_Reg_rf_exe,
	writeback_mux_i=>writeback_mux_i_Reg_rf_exe,
	branch_type_o=>branch_type_o_Reg_rf_exe,
	exe_aluop_o=>exe_aluop_o_Reg_rf_exe,
	exe_mux1_o=>exe_mux1_o_Reg_rf_exe,
	exe_mux2_o=>exe_mux2_o_Reg_rf_exe,
	reg_src_data1_o=>reg_src_data1_o_Reg_rf_exe,
	reg_src_data2_o=>reg_src_data2_o_Reg_rf_exe,
	reg_src_addr1_o=>reg_src_addr1_o_Reg_rf_exe,
	reg_src_addr2_o=>reg_src_addr2_o_Reg_rf_exe,
	extended_o=>extended_o_Reg_rf_exe,
	reg_dest_o=>reg_dest_o_Reg_rf_exe,
	mem_rd_o=>mem_rd_o_Reg_rf_exe,
	mem_wr_o=>mem_wr_o_Reg_rf_exe,
	writeback_mux_o=>writeback_mux_o_Reg_rf_exe
);

rst_Reg_rf_exe<=rst;
clk_Reg_rf_exe<=clk;
flush_Reg_rf_exe<=RegFlushs_o_StallFlushCtrlUnit(1);
stall_Reg_rf_exe<=RegStalls_o_StallFlushCtrlUnit(2);
branch_type_i_Reg_rf_exe<=branch_type_o_RF;
exe_aluop_i_Reg_rf_exe<=exe_aluop_o_RF;
exe_mux1_i_Reg_rf_exe<=exe_mux1_o_RF;
exe_mux2_i_Reg_rf_exe<=exe_mux2_o_RF;
reg_src_data1_i_Reg_rf_exe<=reg_src_data1_o_RF;
reg_src_data2_i_Reg_rf_exe<=reg_src_data2_o_RF;
reg_src_addr1_i_Reg_rf_exe<=reg_src_addr1_o_RF;
reg_src_addr2_i_Reg_rf_exe<=reg_src_addr2_o_RF;
extended_i_Reg_rf_exe<=extended_o_RF;
reg_dest_i_Reg_rf_exe<=reg_dest_o_RF;
mem_rd_i_Reg_rf_exe<=mem_rd_o_RF;
mem_wr_i_Reg_rf_exe<=mem_wr_o_RF;
writeback_mux_i_Reg_rf_exe<=writeback_mux_o_RF;




---StallFlushCtrlUnit
StallFlushCtrlUnit_component:StallFlushCtrlUnit port map(
	branch_flag_i=>branch_flag_i_StallFlushCtrlUnit,
	mem_rd_i_EXE_MEM=>mem_rd_i_EXE_MEM_StallFlushCtrlUnit,
	reg_exemem_dest_addr_i=>reg_exemem_dest_addr_i_StallFlushCtrlUnit,
	reg_src_addr1_i=>reg_src_addr1_i_StallFlushCtrlUnit,
	reg_src_addr2_i=>reg_src_addr2_i_StallFlushCtrlUnit,
	RegStalls_o=>RegStalls_o_StallFlushCtrlUnit,
	RegFlushs_o=>RegFlushs_o_StallFlushCtrlUnit
);

branch_flag_i_StallFlushCtrlUnit<=branch_flag_o_EXE;
mem_rd_i_EXE_MEM_StallFlushCtrlUnit<=mem_rd_o_Reg_exe_mem;
reg_exemem_dest_addr_i_StallFlushCtrlUnit<=reg_dest_o_Reg_exe_mem;
reg_src_addr1_i_StallFlushCtrlUnit<=reg_src_addr1_o_Reg_rf_exe;
reg_src_addr2_i_StallFlushCtrlUnit<=reg_src_addr2_o_Reg_rf_exe;

end Behavioral;

