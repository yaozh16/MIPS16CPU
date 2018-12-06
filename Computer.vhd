----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:17:43 12/05/2018 
-- Design Name: 
-- Module Name:    Computer - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Computer is
	port(
			
			clk_ps2:in std_logic;
			data_ps2:in std_logic;
			sw_in:in std_logic_vector(15 downto 0);
			led_out: out std_logic_vector(15 downto 0);
			se_wrn_o :out std_logic;
			se_rdn_o :out std_logic;
			se_tbre_i :in std_logic;
			se_tsre_i :in std_logic;
			se_data_ready_i :in std_logic;
			clk:in std_logic;
			rst:in std_logic;
			
			
			RAM1Addr:out std_logic_vector(17 downto 0);
			RAM1Data:inout std_logic_vector(15 downto 0);
			RAM1EN:out std_logic;
			RAM1WE:out std_logic;
			RAM1OE:out std_logic;
			
			
			RAM2Addr:out std_logic_vector(17 downto 0);
			RAM2Data:inout std_logic_vector(15 downto 0);
			RAM2EN:out std_logic;
			RAM2WE:out std_logic;
			RAM2OE:out std_logic;
			
			
			Rs:out std_logic_vector(2 downto 0);
			Gs:out std_logic_vector(2 downto 0);
			Bs:out std_logic_vector(2 downto 0);
			Hs:out std_logic;
			Vs:out std_logic;
			
			  flash_byte : out std_logic;
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;				---ce0
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  flash_addr : out std_logic_vector(22 downto 0);
			  flash_data : inout std_logic_vector(15 downto 0)
	);
end Computer;

architecture Behavioral of Computer is
signal keycode_o_PS2: std_logic_vector(15 downto 0);
signal FlashLoadComplete_o_INST_ROM : std_logic;   
signal Flash_clk2_o_FLASH          : std_logic;   
signal FlashAddr_o_INST_ROM: std_logic_vector(22 downto 0); 
signal FlashData_o_FLASH         : std_logic_vector(15 downto 0); 


----signal se_rw_stall_i: std_logic;	---from MEM
----signal id_addr_i_INST_ROM: std_logic_vector (15 downto 0);	---pc
signal id_inst_o_INST_ROM: std_logic_vector(15 downto 0);
signal id_succ_o_INST_ROM: std_logic;

signal mem_wr_i_INST_ROM: std_logic;
signal mem_rd_i_INST_ROM: std_logic;
signal mem_addr_i_INST_ROM: std_logic_vector(15 downto 0);
signal mem_wdata_i_INST_ROM: std_logic_vector(15 downto 0);
signal mem_rdata_o_INST_ROM: std_logic_vector(15 downto 0);
signal Screen_posi_o_INST_ROM:std_logic_vector(11 downto 0);
signal Screen_data_o_INST_ROM:std_logic_vector(17 downto 0);
signal Screen_we_o_INST_ROM:STD_LOGIC_VECTOR(0 DOWNTO 0);
signal VGAAddr_i_INST_ROM: std_logic_vector(17 downto 0);			---from VGACtrl module
signal VGAData_o_INST_ROM: std_logic_vector(15 downto 0);			---to VGACtrl module

    -- Component Declaration for the Unit Under Test (UUT)
			component FLASH
			port (
			  clk                : in  std_logic;
			  FlashLoad_Complete : in  std_logic;
			  Flash_clk2         : out std_logic;
			  rst                : in  std_logic;
			  FlashRAMAddr_i     : in  std_logic_vector(22 downto 0);
			  FlashData_o        : out std_logic_vector(15 downto 0);
			  flash_byte         : out std_logic;
			  flash_vpen         : out std_logic;
			  flash_ce           : out std_logic;
			  flash_oe           : out std_logic;
			  flash_we           : out std_logic;
			  flash_rp           : out std_logic;
			  flash_addr         : out std_logic_vector(22 downto 0);
			  flash_data         : inout std_logic_vector(15 downto 0)
			);
			end component FLASH;


			component VGA_CTRL
			port (
			  VGAAddr_o          : out std_logic_vector(17 downto 0);
			  VGAData_i          : in  std_logic_vector(15 downto 0);
			  ScreenBlockIndex_o : out std_logic_vector(11 downto 0);
			  ScreenOffset_i     : in  std_logic_vector(17 downto 0);
			  clk                : in  std_logic;
			  rst                : in  std_logic;
			  Rs                 : out std_logic_vector(2 downto 0);
			  Gs                 : out std_logic_vector(2 downto 0);
			  Bs                 : out std_logic_vector(2 downto 0);
			  Hs                 : out std_logic;
			  Vs                 : out std_logic
			);
			end component VGA_CTRL;

signal ScreenBlockIndex_o_VGA : std_logic_vector(11 downto 0);		---connect to screen
signal ScreenOffset_i_VGA     : std_logic_vector(17 downto 0);		---connect to screen
    ---pipeline compoonents
				component PCIF
				port (
					
				sw_in:in std_logic_vector(15 downto 0);
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
				  rst                  : in  std_logic;
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
				  stall			   : in  std_logic;
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
          se_rw_stall_o : out std_logic;
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
		    keycode_i				: in std_logic_vector(15 downto 0);		---connect to PS2
			 Screen_posi_o			: out std_logic_vector(11 downto 0);
			 Screen_data_o			: out std_logic_vector(17 downto 0);
			 Screen_we_o			: out std_logic_vector(0 downto 0);
			 VGAAddr_i           : in std_logic_vector(17 downto 0);
			 VGAData_o           : out std_logic_vector(15 downto 0);
          Ram2Addr            : out std_logic_vector(17 downto 0);
          Ram2Data            : inout std_logic_vector(15 downto 0);
          Ram2OE              : out std_logic;
          Ram2WE              : out std_logic;
          Ram2EN              : out std_logic;
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
			component PS2
			port (
			  clk_ps2  : in  std_logic;
			  data_ps2 : in  std_logic;
			  rst      : in  std_logic;
			  clk      : in  std_logic;
			  keycode  : out std_logic_vector(15 downto 0)
			);
			end component PS2;

        signal se_rw_stall_o_INST_ROM : std_logic;
        
        
        


        












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
			
				signal clk_f:std_logic;
				signal clk_count:integer:=0;
   -- Clock period definitions
   ---constant clk_period : time := 10 ns;
	component Screen_offset_mem 
	PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
	);
	end component;
BEGIN
 
process(rst,clk)
begin
	if(rst='0')then
		clk_f<='0';
	else
		if(clk'event and clk='1')then
			clk_f<=not clk_f;
		end if;
	end if;
end process;
--clk_f<=clk;
---PCIF
PCIF_component:PCIF port map(
sw_in=>sw_in,
clk=>clk_f,
rst=>rst,
LW_stall_i=>RegStalls_o_StallFlushCtrlUnit(4),
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
clk=>clk_f,
flush=>RegFlushs_o_StallFlushCtrlUnit(3),
stall=>RegStalls_o_StallFlushCtrlUnit(3),
instruction_i=>instruction_o_PCIF,
instruction_o=>instr_i_RF,
pc_i=>pc_o_PCIF,
pc_o=>pc_i_RF
);
---RF
RF_component:RF port map(
rst=>rst,
clk=>clk_f,
pc_i=>pc_i_RF,
instr_i=>instr_i_RF,
stall_i=>RegStalls_o_StallFlushCtrlUnit(2),
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
clk=>clk_f,
flush=>RegFlushs_o_StallFlushCtrlUnit(2),
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
stall=>RegStalls_o_StallFlushCtrlUnit(2),
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
clk=>clk_f,
flush=>RegFlushs_o_StallFlushCtrlUnit(1),
stall=>RegStalls_o_StallFlushCtrlUnit(1),
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
clk=>clk_f,
flush=>RegFlushs_o_StallFlushCtrlUnit(0),
stall=>RegStalls_o_StallFlushCtrlUnit(0),
reg_dest_i=>reg_dest_o_MEM,
writeback_data_i=>writeback_data_o_MEM,
reg_dest_o=>reg_dest_i_RF,
writeback_data_o=>reg_wdata_i_RF
);




---StallFlushCtrlUnit
StallFlushCtrlUnit_component:StallFlushCtrlUnit port map(
se_rw_stall_i=>se_rw_stall_o_INST_ROM,----se_rw_stall_i,
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
    se_rw_stall_o => se_rw_stall_o_INST_ROM,
    clk                 => clk_f,
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
	 keycode_i				=> keycode_o_PS2,---keycode_i,
	 Screen_posi_o			=> Screen_posi_o_INST_ROM,
	 Screen_data_o			=> Screen_data_o_INST_ROM,
	 Screen_we_o			=> Screen_we_o_INST_ROM,
    VGAAddr_i           => VGAAddr_i_INST_ROM,
    VGAData_o           => VGAData_o_INST_ROM,
    Ram2Addr            => Ram2Addr,
    Ram2Data            => Ram2Data,
    Ram2OE              => Ram2OE,
    Ram2WE              => Ram2WE,
    Ram2EN              => Ram2EN,
    FlashLoadComplete_o => FlashLoadComplete_o_INST_ROM,
    Flash_clk2          => Flash_clk2_o_FLASH,
    FlashAddr_o         => FlashAddr_o_INST_ROM,
    FlashData_i         => FlashData_o_FLASH,
    se_wrn_o            => se_wrn_o,
    se_rdn_o            => se_rdn_o,
    se_tbre_i           => se_tbre_i,
    se_tsre_i           => se_tsre_i,
    se_data_ready_i     => se_data_ready_i
  );

	VGA_CTRL_i : VGA_CTRL
	port map (
	  VGAAddr_o          => VGAAddr_i_INST_ROM,		---VGAAddr_o,
	  VGAData_i          => VGAData_o_INST_ROM,		---VGAData_i,
	  ScreenBlockIndex_o => ScreenBlockIndex_o_VGA,
	  ScreenOffset_i     => ScreenOffset_i_VGA,
	  clk                => clk,
	  rst                => rst,
	  Rs                 => Rs,
	  Gs                 => Gs,
	  Bs                 => Bs,
	  Hs                 => Hs,
	  Vs                 => Vs
	);

Screen_offset_mem_i : Screen_offset_mem
port map (
  clka  => clk_f,
  wea   => Screen_we_o_INST_ROM,
  addra => Screen_posi_o_INST_ROM,
  dina  => Screen_data_o_INST_ROM,
  clkb  => clk_f,
  addrb => ScreenBlockIndex_o_VGA,
  doutb => ScreenOffset_i_VGA
);
FLASH_i : FLASH
port map (
  clk                => clk_f,
  FlashLoad_Complete => FlashLoadComplete_o_INST_ROM,
  Flash_clk2         => Flash_clk2_o_FLASH,
  rst                => rst,
  FlashRAMAddr_i     => FlashAddr_o_INST_ROM,----FlashRAMAddr_i,
  FlashData_o        => FlashData_o_FLASH,
  flash_byte         => flash_byte,
  flash_vpen         => flash_vpen,
  flash_ce           => flash_ce,
  flash_oe           => flash_oe,
  flash_we           => flash_we,
  flash_rp           => flash_rp,
  flash_addr         => flash_addr,
  flash_data         => flash_data
);
PS2_i : PS2
port map (
  clk_ps2  => clk_ps2,
  data_ps2 => data_ps2,
  rst      => rst,
  clk      => clk,
  keycode  => keycode_o_PS2
);

--led_out<=VGAAddr_i_INST_ROM(15 downto 0);
led_out<=se_data_ready_i&
			branch_flag_o_EXE&			---1+1
			(mem_rdata_o_INST_ROM(0 downto 0))&		
			(RegStalls_o_StallFlushCtrlUnit(4 downto 0))&		--6
			mem_rd_o_RF&
			mem_rd_o_EXE&
			mem_rd_i_MEM&
			se_rw_stall_o_INST_ROM&
   		se_tbre_i&
			se_tsre_i&
			keycode_o_PS2(15)&
			id_succ_o_INST_ROM;
end Behavioral;

