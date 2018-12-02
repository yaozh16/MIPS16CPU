--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:06:37 12/03/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testLoadFlashBench.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TestLoadFlash
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
 
ENTITY testLoadFlashBench IS
END testLoadFlashBench;
 
ARCHITECTURE behavior OF testLoadFlashBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TestLoadFlash
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         control_Addr_in : IN  std_logic_vector(15 downto 0);
         display_Data_out : OUT  std_logic_vector(15 downto 0);
         flash_byte : OUT  std_logic;
         flash_vpen : OUT  std_logic;
         flash_ce : OUT  std_logic;
         flash_oe : OUT  std_logic;
         flash_we : OUT  std_logic;
         flash_rp : OUT  std_logic;
         flash_addr : OUT  std_logic_vector(22 downto 0);
         flash_data : INOUT  std_logic_vector(15 downto 0);
         Ram1Addr : OUT  std_logic_vector(17 downto 0);
         Ram1Data : INOUT  std_logic_vector(15 downto 0);
         Ram1OE : OUT  std_logic;
         Ram1WE : OUT  std_logic;
         Ram1EN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal control_Addr_in : std_logic_vector(15 downto 0) := (others => '0');

	--BiDirs
   signal flash_data : std_logic_vector(15 downto 0);
   signal Ram1Data : std_logic_vector(15 downto 0);

 	--Outputs
   signal display_Data_out : std_logic_vector(15 downto 0);
   signal flash_byte : std_logic;
   signal flash_vpen : std_logic;
   signal flash_ce : std_logic;
   signal flash_oe : std_logic;
   signal flash_we : std_logic;
   signal flash_rp : std_logic;
   signal flash_addr : std_logic_vector(22 downto 0);
   signal Ram1Addr : std_logic_vector(17 downto 0);
   signal Ram1OE : std_logic;
   signal Ram1WE : std_logic;
   signal Ram1EN : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TestLoadFlash PORT MAP (
          clk => clk,
          rst => rst,
          control_Addr_in => control_Addr_in,
          display_Data_out => display_Data_out,
          flash_byte => flash_byte,
          flash_vpen => flash_vpen,
          flash_ce => flash_ce,
          flash_oe => flash_oe,
          flash_we => flash_we,
          flash_rp => flash_rp,
          flash_addr => flash_addr,
          flash_data => flash_data,
          Ram1Addr => Ram1Addr,
          Ram1Data => Ram1Data,
          Ram1OE => Ram1OE,
          Ram1WE => Ram1WE,
          Ram1EN => Ram1EN
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		rst<='0';
		control_Addr_in<="1010101000001111";
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		rst<='1';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
