--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:27:28 12/04/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testCPU.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PCIF
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testCPU IS
END testCPU;
 
ARCHITECTURE behavior OF testCPU IS 


signal FlashLoadComplete_o : std_logic;   ---not used
signal Flash_clk2          : std_logic;   ---not used
signal FlashAddr_o         : std_logic_vector(22 downto 0); --not used
signal FlashData_i         : std_logic_vector(15 downto 0); --not used
signal se_wrn_o            : std_logic;
signal se_rdn_o            : std_logic;
signal se_tbre_i           : std_logic;
signal se_tsre_i           : std_logic;
signal se_data_ready_i     : std_logic;
signal clk: std_logic;
signal rst: std_logic;


----signal se_rw_stall_i: std_logic;	---from MEM
----signal id_addr_i_INST_ROM: std_logic_vector (15 downto 0);	---pc
signal id_inst_o_INST_ROM: std_logic_vector(15 downto 0);
signal id_succ_o_INST_ROM: std_logic;

signal mem_wr_i_INST_ROM: std_logic;
signal mem_rd_i_INST_ROM: std_logic;
signal mem_addr_i_INST_ROM: std_logic_vector(15 downto 0);
signal mem_wdata_i_INST_ROM: std_logic_vector(15 downto 0);
signal mem_rdata_o_INST_ROM: std_logic_vector(15 downto 0);
signal RAM1Addr: std_logic_vector(17 downto 0);
signal RAM1Data: std_logic_vector(15 downto 0);
signal RAM1EN:std_logic;
signal RAM1WE:std_logic;
signal RAM1OE:std_logic;

    -- Component Declaration for the Unit Under Test (UUT)
 
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
				  reg_src1_data_o      : out std_logic_vector(15 downto 0);
				  reg_src2_data_o      : out std_logic_vector(15 downto 0);
				  reg_src1_addr_o      : out std_logic_vector(3 downto 0);
				  reg_src2_addr_o      : out std_logic_vector(3 downto 0);
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
				  se_rw_stall_i          : in  std_logic;
				  mem_rd_i_EXE_MEM       : in  std_logic;
				  mem_wr_i_RF_EXE        : in  std_logic;
				  mem_rd_i_RF_EXE        : in  std_logic;
				  reg_exemem_dest_addr_i : in  std_logic_vector(3 downto 0);
				  reg_src1_addr_i        : in  std_logic_vector(3 downto 0);
				  reg_src2_addr_i        : in  std_logic_vector(3 downto 0);
				  RegStalls_o            : out std_logic_vector(4 downto 0);
				  RegFlushs_o            : out std_logic_vector(3 downto 0)
				);
				end component StallFlushCtrlUnit;



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
				  reg_src1_data_i : in  std_logic_vector(15 downto 0);
				  reg_src2_data_i : in  std_logic_vector(15 downto 0);
				  reg_src1_addr_i : in  std_logic_vector(3 downto 0);
				  reg_src2_addr_i : in  std_logic_vector(3 downto 0);
				  extended_i      : in  std_logic_vector(15 downto 0);
				  reg_dest_i      : in  std_logic_vector(3 downto 0);
				  mem_rd_i        : in  std_logic;
				  mem_wr_i        : in  std_logic;
				  writeback_mux_i : in  std_logic;
				  branch_type_o   : out std_logic_vector(2 downto 0);
				  exe_aluop_o     : out std_logic_vector(3 downto 0);
				  exe_mux1_o      : out std_logic;
				  exe_mux2_o      : out std_logic;
				  reg_src1_data_o : out std_logic_vector(15 downto 0);
				  reg_src2_data_o : out std_logic_vector(15 downto 0);
				  reg_src1_addr_o : out std_logic_vector(3 downto 0);
				  reg_src2_addr_o : out std_logic_vector(3 downto 0);
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
        
        component INST_ROM
        port (
          serial_rw_install_o : out std_logic;
          clk                 : in  std_logic;
          rst                 : in  std_logic;
          id_addr_i           : in  std_logic_vector (15 downto 0);
          id_succ_o           : out std_logic;
          id_inst_o           : out std_logic_vector (15 downto 0);
          mem_wr_i            : in  std_logic;
          mem_rd_i            : in  std_logic;
          mem_addr_i          : in  std_logic_vector(15 downto 0);
          mem_wdata_i         : in  std_logic_vector(15 downto 0);
          mem_rdata_o         : out std_logic_vector(15 downto 0);
          Ram1Addr            : out std_logic_vector(17 downto 0);
          Ram1Data            : inout std_logic_vector(15 downto 0);
          Ram1OE              : out std_logic;
          Ram1WE              : out std_logic;
          Ram1EN              : out std_logic;
          FlashLoadComplete_o : out std_logic;
          Flash_clk2          : in  std_logic;
          FlashAddr_o         : out std_logic_vector(22 downto 0);
          FlashData_i         : in  std_logic_vector(15 downto 0);
          se_wrn_o            : out std_logic;
          se_rdn_o            : out std_logic;
          se_tbre_i           : in  std_logic;
          se_tsre_i           : in  std_logic;
          se_data_ready_i     : in  std_logic
        );
        end component INST_ROM;
        component SIMU_RAM
        port (
          rst  : in  std_logic;
          addr : in  std_logic_vector(17 downto 0);
          data : inout std_logic_vector(15 downto 0);
          WE   : in  std_logic;
          OE   : in  std_logic;
          EN   : in  std_logic
        );
        end component SIMU_RAM;

        
        
        
        signal serial_rw_install_o : std_logic;


        












				---signals
				---PCIF
				signal pc_o_PCIF:  std_logic_vector(15 downto 0);	---connected to memory unit;
				signal instruction_o_PCIF:  std_logic_vector(15 downto 0); ---connected to registers between parts;
        
        ---RF
				signal  pc_i_RF:  std_logic_vector(15 downto 0);
				signal instr_i_RF:   std_logic_vector(15 downto 0);
				signal reg_dest_i_RF:  std_logic_vector(3 downto 0);---write back;
				signal reg_wdata_i_RF:  std_logic_vector(15 downto 0);---write back;
				signal branch_type_o_RF:  std_logic_vector(2 downto 0);
				signal exe_aluop_o_RF:  std_logic_vector(3 downto 0);---ALU operation;
				signal exe_mux1_o_RF:  std_logic;	--reg or 0;
				signal exe_mux2_o_RF:  std_logic;  --reg or extended                                                                                                                 ;
				signal reg_src1_data_o_RF:  std_logic_vector(15 downto 0);
				signal reg_src2_data_o_RF:  std_logic_vector(15 downto 0);
				signal reg_src1_addr_o_RF:  std_logic_vector(3 downto 0);
				signal reg_src2_addr_o_RF:  std_logic_vector(3 downto 0);
				signal extended_o_RF:  std_logic_vector(15 downto 0);
				signal reg_dest_o_RF:  std_logic_vector(3 downto 0);
				signal mem_rd_o_RF:  std_logic;
				signal mem_wr_o_RF:  std_logic;
				signal writeback_mux_o_RF:  std_logic;

				---EXE_FF
				signal reg_src1_data_i_EXE_FF:  std_logic_vector(15 downto 0);
				signal reg_src2_data_i_EXE_FF:  std_logic_vector(15 downto 0);
				signal reg_src1_addr_i_EXE_FF:  std_logic_vector(3 downto 0);
				signal reg_src2_addr_i_EXE_FF:  std_logic_vector(3 downto 0);

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



				---MEM
				signal reg_dest_i_MEM:  std_logic_vector(3 downto 0);		--- herit;
				signal mem_wr_i_MEM:  std_logic;									---connect to reg between parts,write signal;
				signal mem_rd_i_MEM:  std_logic;									---connect to reg between parts,read signal;
				signal ALU_result_i_MEM:   std_logic_vector(15 downto 0);		---connect to reg between parts,ALU result;
				signal mem_wdata_i_MEM:   std_logic_vector(15 downto 0);		---connect to reg beween parts,oper2;
				signal writeback_mux_i_MEM:  std_logic;
				signal reg_dest_o_MEM:  std_logic_vector(3 downto 0);		--- herit;
				signal writeback_data_o_MEM:   std_logic_vector(15 downto 0);----connect to reg between parts;




				---StallFlushCtrlUnit
				signal RegStalls_o_StallFlushCtrlUnit:  std_logic_vector(4 downto 0);
				signal RegFlushs_o_StallFlushCtrlUnit:  std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
 
---PCIF
PCIF_component:PCIF port map(
clk=>clk,
rst=>rst,
LW_stall_i=>RegStalls_o_StallFlushCtrlUnit(0),
branch_addr_i=>branch_addr_o_EXE,
branch_flag_i=>branch_flag_o_EXE,
pc_o=>pc_o_PCIF,
instruction_i=>id_inst_o_INST_ROM,
id_succ_i=>id_succ_o_INST_ROM,
instruction_o=>instruction_o_PCIF
);
---Reg_id_rf
Reg_id_rf_component:Reg_id_rf port map(
rst=>rst,
clk=>clk,
flush=>RegFlushs_o_StallFlushCtrlUnit(0),
stall=>RegStalls_o_StallFlushCtrlUnit(1),
instruction_i=>instruction_o_PCIF,
instruction_o=>instr_i_RF,
pc_i=>pc_o_PCIF,
pc_o=>pc_i_RF
);
---RF
RF_component:RF port map(
clk=>clk,
pc_i=>pc_i_RF,
instr_i=>instr_i_RF,
stall_i=>RegStalls_o_StallFlushCtrlUnit(1),
reg_dest_i=>reg_dest_i_RF,
reg_wdata_i=>reg_wdata_i_RF,
branch_type_o=>branch_type_o_RF,
exe_aluop_o=>exe_aluop_o_RF,
exe_mux1_o=>exe_mux1_o_RF,
exe_mux2_o=>exe_mux2_o_RF,
reg_src1_data_o=>reg_src1_data_o_RF,
reg_src2_data_o=>reg_src2_data_o_RF,
reg_src1_addr_o=>reg_src1_addr_o_RF,
reg_src2_addr_o=>reg_src2_addr_o_RF,
extended_o=>extended_o_RF,
reg_dest_o=>reg_dest_o_RF,
mem_rd_o=>mem_rd_o_RF,
mem_wr_o=>mem_wr_o_RF,
writeback_mux_o=>writeback_mux_o_RF
);
---Reg_rf_exe
Reg_rf_exe_component:Reg_rf_exe port map(
rst=>rst,
clk=>clk,
flush=>RegFlushs_o_StallFlushCtrlUnit(1),
stall=>RegStalls_o_StallFlushCtrlUnit(2),
branch_type_i=>branch_type_o_RF,
exe_aluop_i=>exe_aluop_o_RF,
exe_mux1_i=>exe_mux1_o_RF,
exe_mux2_i=>exe_mux2_o_RF,
reg_src1_data_i=>reg_src1_data_o_RF,
reg_src2_data_i=>reg_src2_data_o_RF,
reg_src1_addr_i=>reg_src1_addr_o_RF,
reg_src2_addr_i=>reg_src2_addr_o_RF,
extended_i=>extended_o_RF,
reg_dest_i=>reg_dest_o_RF,
mem_rd_i=>mem_rd_o_RF,
mem_wr_i=>mem_wr_o_RF,
writeback_mux_i=>writeback_mux_o_RF,
branch_type_o=>branch_type_i_EXE,
exe_aluop_o=>exe_aluop_i_EXE,
exe_mux1_o=>exe_mux1_i_EXE,
exe_mux2_o=>exe_mux2_i_EXE,
reg_src1_data_o=>reg_src1_data_i_EXE_FF,				---send to ff unit
reg_src2_data_o=>reg_src2_data_i_EXE_FF,
reg_src1_addr_o=>reg_src1_addr_i_EXE_FF,
reg_src2_addr_o=>reg_src2_addr_i_EXE_FF,
extended_o=>extended_i_EXE,
reg_dest_o=>reg_dest_i_EXE,
mem_rd_o=>mem_rd_i_EXE,
mem_wr_o=>mem_wr_i_EXE,
writeback_mux_o=>writeback_mux_i_EXE
);

---EXE_FF
EXE_FF_component:EXE_FF port map(
reg_src1_data_i=>reg_src1_data_i_EXE_FF,
reg_src2_data_i=>reg_src2_data_i_EXE_FF,
reg_exemem_dest_data_i=>ALU_result_i_MEM,
reg_memwb_dest_data_i=>reg_wdata_i_RF,
reg_src1_addr_i=>reg_src1_addr_i_EXE_FF,
reg_src2_addr_i=>reg_src2_addr_i_EXE_FF,
reg_exemem_dest_addr_i=>reg_dest_i_MEM,
reg_memwb_dest_addr_i=>reg_dest_i_RF,
reg_src1_data_o=>reg_src1_data_i_EXE,
reg_src2_data_o=>reg_src2_data_i_EXE
);
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

---Reg_exe_mem
Reg_exe_mem_component:Reg_exe_mem port map(
rst=>rst,
clk=>clk,
flush=>RegFlushs_o_StallFlushCtrlUnit(2),
stall=>RegStalls_o_StallFlushCtrlUnit(3),
ALU_result_i=>ALU_result_o_EXE,
reg_dest_i=>reg_dest_o_EXE,
mem_rd_i=>mem_rd_o_EXE,
mem_wr_i=>mem_wr_o_EXE,
writeback_mux_i=>writeback_mux_o_EXE,
mem_wdata_i=>mem_wdata_o_EXE,
ALU_result_o=>ALU_result_i_MEM,
reg_dest_o=>reg_dest_i_MEM,
mem_rd_o=>mem_rd_i_MEM,
mem_wr_o=>mem_wr_i_MEM,
writeback_mux_o=>writeback_mux_i_MEM,
mem_wdata_o=>mem_wdata_i_MEM
);
---MEM
MEM_component:MEM port map(
rst=>rst,
reg_dest_i=>reg_dest_i_MEM,
mem_wr_i=>mem_wr_i_MEM,
mem_rd_i=>mem_rd_i_MEM,
ALU_result_i=>ALU_result_i_MEM,
mem_wdata_i=>mem_wdata_i_MEM,
writeback_mux_i=>writeback_mux_i_MEM,
mem_wr_o=>mem_wr_i_INST_ROM,
mem_rd_o=>mem_rd_i_INST_ROM,
mem_addr_o=>mem_addr_i_INST_ROM,
mem_wdata_o=>mem_wdata_i_INST_ROM,
mem_rdata_i=>mem_rdata_o_INST_ROM,
reg_dest_o=>reg_dest_o_MEM,
writeback_data_o=>writeback_data_o_MEM
);
---Reg_mem_wb
Reg_mem_wb_component:Reg_mem_wb port map(
rst=>rst,
clk=>clk,
flush=>RegFlushs_o_StallFlushCtrlUnit(3),
stall=>RegStalls_o_StallFlushCtrlUnit(4),
reg_dest_i=>reg_dest_o_MEM,
writeback_data_i=>writeback_data_o_MEM,
reg_dest_o=>reg_dest_i_RF,
writeback_data_o=>reg_wdata_i_RF
);




---StallFlushCtrlUnit
StallFlushCtrlUnit_component:StallFlushCtrlUnit port map(
se_rw_stall_i=>serial_rw_install_o,----se_rw_stall_i,
branch_flag_i=>branch_flag_o_EXE,
mem_rd_i_EXE_MEM=>mem_rd_i_MEM,
mem_wr_i_RF_EXE=>mem_wr_i_EXE,
mem_rd_i_RF_EXE=>mem_rd_i_EXE,
reg_exemem_dest_addr_i=>reg_dest_i_MEM,
reg_src1_addr_i=>reg_src1_addr_i_EXE_FF,
reg_src2_addr_i=>reg_src2_addr_i_EXE_FF,
RegStalls_o=>RegStalls_o_StallFlushCtrlUnit,
RegFlushs_o=>RegFlushs_o_StallFlushCtrlUnit
);
INST_ROM_i : INST_ROM
  port map (
    serial_rw_install_o => serial_rw_install_o,
    clk                 => clk,
    rst                 => rst,
    id_addr_i           => pc_o_PCIF,----id_addr_i_INST_ROM,---id_addr_i,
    id_succ_o           => id_succ_o_INST_ROM,---id_succ_o,
    id_inst_o           => id_inst_o_INST_ROM,---id_inst_o,
    mem_wr_i            => mem_wr_i_INST_ROM,---mem_wr_i
    mem_rd_i            => mem_rd_i_INST_ROM,---mem_rd_i
    mem_addr_i          => mem_addr_i_INST_ROM,---mem_addr_i
    mem_wdata_i         => mem_wdata_i_INST_ROM,---mem_wdata_i
    mem_rdata_o         => mem_rdata_o_INST_ROM,---mem_rdata_o
    Ram1Addr            => Ram1Addr,
    Ram1Data            => Ram1Data,
    Ram1OE              => Ram1OE,
    Ram1WE              => Ram1WE,
    Ram1EN              => Ram1EN,
    FlashLoadComplete_o => FlashLoadComplete_o,
    Flash_clk2          => Flash_clk2,
    FlashAddr_o         => FlashAddr_o,
    FlashData_i         => FlashData_i,
    se_wrn_o            => se_wrn_o,
    se_rdn_o            => se_rdn_o,
    se_tbre_i           => se_tbre_i,
    se_tsre_i           => se_tsre_i,
    se_data_ready_i     => se_data_ready_i
  );
  SIMU_RAM_i : SIMU_RAM
  port map (
    rst  => rst,
    addr => RAM1Addr,
    data => RAM1Data,
    WE   => RAM1WE,
    OE   => RAM1OE,
    EN   => RAM1EN
  );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

	
		se_tbre_i<='1';
		se_tsre_i<='1';
		se_data_ready_i<='1';
		Flash_clk2<='0';
		FlashData_i<=(others=>'0');
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst<='0';
      wait for 1 ns;	
		rst<='1';
      wait for clk_period;

      -- insert stimulus here 

      wait;
   end process;

END;
