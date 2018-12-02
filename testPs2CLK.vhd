--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:59:04 12/02/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testPs2CLK.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PS2
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
 
ENTITY testPs2CLK IS
END testPs2CLK;
 
ARCHITECTURE behavior OF testPs2CLK IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PS2
    PORT(
         clk_ps2 : IN  std_logic;
			data_ps2:IN std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         keycode : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_ps2 : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
	
	signal	data_ps2:std_logic:='1';

 	--Outputs
   signal keycode : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_ps2_period : time := 500 ns;
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PS2 PORT MAP (
          clk_ps2 => clk_ps2,
          data_ps2 => data_ps2,
          rst => rst,
          clk => clk,
          keycode => keycode
        );

   -- Clock process definitions
   clk_ps2_process :process
   begin
		clk_ps2 <= '0';
		wait for clk_ps2_period/2;
		clk_ps2 <= '1';
		wait for clk_ps2_period/2;
   end process;
 
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
      wait for 100 ns;	

      wait for clk_ps2_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
