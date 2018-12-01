--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:12:58 12/01/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testControlFlash.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: INST_ROM
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
 
ENTITY testControlFlash IS
END testControlFlash;
 
ARCHITECTURE behavior OF testControlFlash IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT INST_ROM
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         id_addr_i : IN  std_logic_vector(15 downto 0);
         id_succ_o : OUT  std_logic;
         id_inst_o : OUT  std_logic_vector(15 downto 0);
         mem_wr_i : IN  std_logic;
         mem_rd_i : IN  std_logic;
         mem_addr_i : IN  std_logic_vector(15 downto 0);
         mem_wdata_i : IN  std_logic_vector(15 downto 0);
         mem_rdata_o : OUT  std_logic_vector(15 downto 0);
         Ram1Addr : OUT  std_logic_vector(17 downto 0);
         Ram1Data : INOUT  std_logic_vector(15 downto 0);
         Ram1OE : OUT  std_logic;
         Ram1WE : OUT  std_logic;
         Ram1EN : OUT  std_logic;
         Ram2Addr : OUT  std_logic_vector(17 downto 0);
         Ram2Data : INOUT  std_logic_vector(15 downto 0);
         Ram2OE : OUT  std_logic;
         Ram2WE : OUT  std_logic;
         Ram2EN : OUT  std_logic;
         FlashLoad_Complete : OUT  std_logic;
         FlashLoad_clk : OUT  std_logic;
         FlashLoad_en : IN  std_logic;
         FlashAddr_o : OUT  std_logic_vector(22 downto 0);
         FlashData_i : IN  std_logic_vector(15 downto 0);
         VGAAddr : IN  std_logic_vector(17 downto 0);
         VGAData : OUT  std_logic_vector(15 downto 0);
         se_wrn_o : OUT  std_logic;
         se_rdn_o : OUT  std_logic;
         se_tbre_i : IN  std_logic;
         se_tsre_i : IN  std_logic;
         se_data_ready_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal id_addr_i : std_logic_vector(15 downto 0) := (others => '0');
   signal mem_wr_i : std_logic := '0';
   signal mem_rd_i : std_logic := '0';
   signal mem_addr_i : std_logic_vector(15 downto 0) := (others => '0');
   signal mem_wdata_i : std_logic_vector(15 downto 0) := (others => '0');
   signal FlashLoad_en : std_logic := '1';
   signal FlashData_i : std_logic_vector(15 downto 0) := (others => '0');
   signal VGAAddr : std_logic_vector(17 downto 0) := (others => '0');
   signal se_tbre_i : std_logic := '0';
   signal se_tsre_i : std_logic := '0';
   signal se_data_ready_i : std_logic := '0';

	--BiDirs
   signal Ram1Data : std_logic_vector(15 downto 0);
   signal Ram2Data : std_logic_vector(15 downto 0);

 	--Outputs
   signal id_succ_o : std_logic;
   signal id_inst_o : std_logic_vector(15 downto 0);
   signal mem_rdata_o : std_logic_vector(15 downto 0);
   signal Ram1Addr : std_logic_vector(17 downto 0);
   signal Ram1OE : std_logic;
   signal Ram1WE : std_logic;
   signal Ram1EN : std_logic;
   signal Ram2Addr : std_logic_vector(17 downto 0);
   signal Ram2OE : std_logic;
   signal Ram2WE : std_logic;
   signal Ram2EN : std_logic;
   signal FlashLoad_Complete : std_logic;
   signal FlashLoad_clk : std_logic;
   signal FlashAddr_o : std_logic_vector(22 downto 0);
   signal VGAData : std_logic_vector(15 downto 0);
   signal se_wrn_o : std_logic;
   signal se_rdn_o : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: INST_ROM PORT MAP (
          clk => clk,
          rst => rst,
          id_addr_i => id_addr_i,
          id_succ_o => id_succ_o,
          id_inst_o => id_inst_o,
          mem_wr_i => mem_wr_i,
          mem_rd_i => mem_rd_i,
          mem_addr_i => mem_addr_i,
          mem_wdata_i => mem_wdata_i,
          mem_rdata_o => mem_rdata_o,
          Ram1Addr => Ram1Addr,
          Ram1Data => Ram1Data,
          Ram1OE => Ram1OE,
          Ram1WE => Ram1WE,
          Ram1EN => Ram1EN,
          Ram2Addr => Ram2Addr,
          Ram2Data => Ram2Data,
          Ram2OE => Ram2OE,
          Ram2WE => Ram2WE,
          Ram2EN => Ram2EN,
          FlashLoad_Complete => FlashLoad_Complete,
          FlashLoad_clk => FlashLoad_clk,
          FlashLoad_en => FlashLoad_en,
          FlashAddr_o => FlashAddr_o,
          FlashData_i => FlashData_i,
          VGAAddr => VGAAddr,
          VGAData => VGAData,
          se_wrn_o => se_wrn_o,
          se_rdn_o => se_rdn_o,
          se_tbre_i => se_tbre_i,
          se_tsre_i => se_tsre_i,
          se_data_ready_i => se_data_ready_i
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	FlashData_i<=FlashAddr_o(15 downto 0);
	
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst<='0';
      wait for 100 ns;	

		rst<='1';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
