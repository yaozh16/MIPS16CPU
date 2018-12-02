--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:00:24 12/01/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/testFlash.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FLASH
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
 
ENTITY testFlash IS
END testFlash;
 
ARCHITECTURE behavior OF testFlash IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FLASH
    PORT(
         clk : IN  std_logic;
         FlashLoad_clk : IN  std_logic;
         rst : IN  std_logic;
         addr_in : IN  std_logic_vector(22 downto 0);
         data_out : OUT  std_logic_vector(15 downto 0);
         flash_byte : OUT  std_logic;
         flash_vpen : OUT  std_logic;
         flash_ce : OUT  std_logic;
         flash_oe : OUT  std_logic;
         flash_we : OUT  std_logic;
         flash_rp : OUT  std_logic;
         flash_addr : OUT  std_logic_vector(22 downto 0);
         flash_data : INOUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal FlashLoad_clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal addr_in : std_logic_vector(22 downto 0) := (others => '0');

	--BiDirs
   signal flash_data : std_logic_vector(15 downto 0);

 	--Outputs
   signal data_out : std_logic_vector(15 downto 0);
   signal flash_byte : std_logic;
   signal flash_vpen : std_logic;
   signal flash_ce : std_logic;
   signal flash_oe : std_logic;
   signal flash_we : std_logic;
   signal flash_rp : std_logic;
   signal flash_addr : std_logic_vector(22 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant FlashLoad_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FLASH PORT MAP (
          clk => clk,
          FlashLoad_clk => FlashLoad_clk,
          rst => rst,
          addr_in => addr_in,
          data_out => data_out,
          flash_byte => flash_byte,
          flash_vpen => flash_vpen,
          flash_ce => flash_ce,
          flash_oe => flash_oe,
          flash_we => flash_we,
          flash_rp => flash_rp,
          flash_addr => flash_addr,
          flash_data => flash_data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   FlashLoad_clk_process :process
   begin
		FlashLoad_clk <= '0';
		wait for FlashLoad_clk_period/2;
		FlashLoad_clk <= '1';
		wait for FlashLoad_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
