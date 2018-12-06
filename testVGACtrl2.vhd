--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:59:03 12/07/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testVGACtrl2.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: VGA_CTRL
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
 
ENTITY testVGACtrl2 IS
END testVGACtrl2;
 
ARCHITECTURE behavior OF testVGACtrl2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT VGA_CTRL
    PORT(
         VGAAddr_o : OUT  std_logic_vector(17 downto 0);
         VGAData_i : IN  std_logic_vector(15 downto 0);
         ScreenBlockIndex_o : OUT  std_logic_vector(11 downto 0);
         ScreenOffset_i : IN  std_logic_vector(17 downto 0);
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
   signal VGAData_i : std_logic_vector(15 downto 0) := (others => '0');
   signal ScreenOffset_i : std_logic_vector(17 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal VGAAddr_o : std_logic_vector(17 downto 0);
   signal ScreenBlockIndex_o : std_logic_vector(11 downto 0);
   signal Rs : std_logic_vector(2 downto 0);
   signal Gs : std_logic_vector(2 downto 0);
   signal Bs : std_logic_vector(2 downto 0);
   signal Hs : std_logic;
   signal Vs : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: VGA_CTRL PORT MAP (
          VGAAddr_o => VGAAddr_o,
          VGAData_i => VGAData_i,
          ScreenBlockIndex_o => ScreenBlockIndex_o,
          ScreenOffset_i => ScreenOffset_i,
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
