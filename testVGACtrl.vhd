--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:22:39 12/02/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testVGACtrl.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TestVGAModule
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
 
ENTITY testVGACtrl IS
END testVGACtrl;
 
ARCHITECTURE behavior OF testVGACtrl IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TestVGAModule
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Rs : OUT  std_logic_vector(2 downto 0);
         Gs : OUT  std_logic_vector(2 downto 0);
         Bs : OUT  std_logic_vector(2 downto 0);
         Hs : OUT  std_logic;
         Vs : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal Rs : std_logic_vector(2 downto 0);
   signal Gs : std_logic_vector(2 downto 0);
   signal Bs : std_logic_vector(2 downto 0);
   signal Hs : std_logic;
   signal Vs : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TestVGAModule PORT MAP (
          clk => clk,
          rst => rst,
          Rs => Rs,
          Gs => Gs,
          Bs => Bs,
          Hs => Hs,
          Vs => Vs
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
