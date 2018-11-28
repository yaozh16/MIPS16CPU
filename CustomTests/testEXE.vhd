--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:09:11 11/29/2018
-- Design Name:   
-- Module Name:   /media/yaozh16/00017DA30004166D/Academic/Grade3.1/CC/PRJ/MIPS16CPU/CustomTests/testEXE.vhd
-- Project Name:  MIPS16CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EXE
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
 
ENTITY testEXE IS
END testEXE;
 
ARCHITECTURE behavior OF testEXE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXE
    PORT(
         exe_aluop_i : IN  std_logic_vector(3 downto 0);
         exe_mux1_i : IN  std_logic_vector(1 downto 0);
         exe_mux2_i : IN  std_logic_vector(1 downto 0);
         reg_src1_i : IN  std_logic_vector(15 downto 0);
         reg_src2_i : IN  std_logic_vector(15 downto 0);
         extended_i : IN  std_logic_vector(15 downto 0);
         reg_dest_i : IN  std_logic_vector(3 downto 0);
         ALU_result_o : OUT  std_logic_vector(15 downto 0);
         reg_dest_o : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal exe_aluop_i : std_logic_vector(3 downto 0) := (others => '0');
   signal exe_mux1_i : std_logic_vector(1 downto 0) := (others => '0');
   signal exe_mux2_i : std_logic_vector(1 downto 0) := (others => '0');
   signal reg_src1_i : std_logic_vector(15 downto 0) := (others => '0');
   signal reg_src2_i : std_logic_vector(15 downto 0) := (others => '0');
   signal extended_i : std_logic_vector(15 downto 0) := (others => '0');
   signal reg_dest_i : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal ALU_result_o : std_logic_vector(15 downto 0);
   signal reg_dest_o : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXE PORT MAP (
          exe_aluop_i => exe_aluop_i,
          exe_mux1_i => exe_mux1_i,
          exe_mux2_i => exe_mux2_i,
          reg_src1_i => reg_src1_i,
          reg_src2_i => reg_src2_i,
          extended_i => extended_i,
          reg_dest_i => reg_dest_i,
          ALU_result_o => ALU_result_o,
          reg_dest_o => reg_dest_o
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		exe_mux1_i<="00";
		exe_mux2_i<="00";
		reg_src1_i<="1000000011111110";
		reg_src2_i<="0000000000000011";
		exe_aluop_i<="1101";
      wait;
   end process;

END;
