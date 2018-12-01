--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:03:58 11/30/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testCom.vhd
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
 
ENTITY testCom IS
END testCom;
 
ARCHITECTURE behavior OF testCom IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Combination
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         addr2_d : OUT  std_logic_vector(17 downto 0);
         data2_d : OUT  std_logic_vector(15 downto 0);
         WE2_d : OUT  std_logic;
         OE2_d : OUT  std_logic;
         EN2_d : OUT  std_logic;
         addr1_d : OUT  std_logic_vector(17 downto 0);
         data1_d : OUT  std_logic_vector(15 downto 0);
         WE1_d : OUT  std_logic;
         OE1_d : OUT  std_logic;
         EN1_d : OUT  std_logic;
         pc:out std_logic_vector(15 downto 0);
			inst:out std_logic_vector(15 downto 0);
			extend:out std_logic_vector(15 downto 0);
			regsrc12destEM:out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal addr2_d : std_logic_vector(17 downto 0);
   signal data2_d : std_logic_vector(15 downto 0);
   signal WE2_d : std_logic;
   signal OE2_d : std_logic;
   signal EN2_d : std_logic;
   signal addr1_d : std_logic_vector(17 downto 0);
   signal data1_d : std_logic_vector(15 downto 0);
   signal WE1_d : std_logic;
   signal OE1_d : std_logic;
   signal EN1_d : std_logic;
   signal pc : std_logic_vector(15 downto 0);
   signal inst : std_logic_vector(15 downto 0);
   signal extend : std_logic_vector(15 downto 0);
   signal regsrc12destEM : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Combination PORT MAP (
          clk => clk,
          rst => rst,
          addr2_d => addr2_d,
          data2_d => data2_d,
          WE2_d => WE2_d,
          OE2_d => OE2_d,
          EN2_d => EN2_d,
          addr1_d => addr1_d,
          data1_d => data1_d,
          WE1_d => WE1_d,
          OE1_d => OE1_d,
          EN1_d => EN1_d,
           pc =>  pc,
          inst => inst,
          extend => extend,
          regsrc12destEM => regsrc12destEM
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
      wait for  clk_period*2/3;
		rst<='1';

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
