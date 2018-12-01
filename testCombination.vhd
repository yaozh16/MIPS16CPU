--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:14:05 11/30/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testCombination.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Combination
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
 
ENTITY testCombination IS
END testCombination;
 
ARCHITECTURE behavior OF testCombination IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Combination
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         display1 : OUT  std_logic_vector(15 downto 0);
         display2 : OUT  std_logic_vector(15 downto 0);
         display3 : OUT  std_logic_vector(15 downto 0);
         display4 : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal display1 : std_logic_vector(15 downto 0);
   signal display2 : std_logic_vector(15 downto 0);
   signal display3 : std_logic_vector(15 downto 0);
   signal display4 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Combination PORT MAP (
          clk => clk,
          rst => rst,
          display1 => display1,
          display2 => display2,
          display3 => display3,
          display4 => display4
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
      -- hold reset state for 100 ns.
		rst<='0';
      wait for 100 ns;	
		rst<='1';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
