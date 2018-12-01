----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:30:49 11/29/2018 
-- Design Name: 
-- Module Name:    Combination - Behavioral 
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
use work.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Combination is
	port(
		clk:in std_logic;
		rst:in std_logic;
		
		addr2_d :out std_logic_vector(17 downto 0);
      data2_d :out std_logic_vector(15 downto 0);
      WE2_d   :out std_logic;
      OE2_d   :out std_logic;
      EN2_d   :out std_logic;

      addr1_d :out std_logic_vector(17 downto 0);
      data1_d :out std_logic_vector(15 downto 0);
      WE1_d   :out std_logic;
      OE1_d   :out std_logic;
      EN1_d   :out std_logic;
		
		pc:out std_logic_vector(15 downto 0);
		inst:out std_logic_vector(15 downto 0);
		extend:out std_logic_vector(15 downto 0);
		regsrc12destEM:out std_logic_vector(15 downto 0)
	);
end Combination;

architecture Behavioral of Combination is
component CPU
port (
  clk               : in  std_logic;
  rst               : in  std_logic;
  Ram1Data_INST_ROM : inout std_logic_vector(15 downto 0);
  Ram1Addr_INST_ROM : out std_logic_vector(17 downto 0);
  Ram1OE_INST_ROM   : out std_logic;
  Ram1WE_INST_ROM   : out std_logic;
  Ram1EN_INST_ROM   : out std_logic;
  Ram2Data_INST_ROM : inout std_logic_vector(15 downto 0);
  Ram2Addr_INST_ROM : out std_logic_vector(17 downto 0);
  Ram2OE_INST_ROM   : out std_logic;
  Ram2WE_INST_ROM   : out std_logic;
  Ram2EN_INST_ROM   : out std_logic;
  display1 : out std_logic_vector(15 downto 0);
  display2 : out std_logic_vector(15 downto 0);
  display3 : out std_logic_vector(15 downto 0);
  display4 : out std_logic_vector(15 downto 0)
);
end component CPU;

component SIMU_RAM
port (
  rst  : in  std_logic;
  addr : in  std_logic_vector(17 downto 0);
  data : inout std_logic_vector(15 downto 0);
  WE   : in  std_logic;
  OE   : in  std_logic;
  EN   : in  std_logic
);
end component SIMU_RAM;

signal   addr2 : std_logic_vector(17 downto 0);
signal   data2 :  std_logic_vector(15 downto 0);
signal   WE2   :  std_logic;
signal   OE2   : std_logic;
signal   EN2   :  std_logic;

signal   addr1 : std_logic_vector(17 downto 0);
signal   data1 :  std_logic_vector(15 downto 0);
signal   WE1   :  std_logic;
signal   OE1   : std_logic;
signal   EN1   :  std_logic;
begin

	addr1_d<=addr1;
	data1_d<=data1;
	WE1_d<=WE1;
	OE1_d<=OE1;
	EN1_d<=EN1;
	
	addr2_d<=addr2;
	data2_d<=data2;
	WE2_d<=WE2;
	OE2_d<=OE2;
	EN2_d<=EN2;
	
	SIMU_RAM1:SIMU_RAM port map(
		rst=>rst,
		addr=>addr1,
		data=>data1,
		WE=>WE1,
		OE=>OE1,
		EN=>EN1
	);
	
	SIMU_RAM2:SIMU_RAM port map(
		rst=>rst,
		addr=>addr2,
		data=>data2,
		WE=>WE2,
		OE=>OE2,
		EN=>EN2
	);
	
	TestedCPU:	CPU port map(
  clk               =>clk,
  rst               =>rst,
  Ram1Data_INST_ROM =>data1,
  Ram1Addr_INST_ROM =>addr1,
  Ram1OE_INST_ROM   =>OE1,
  Ram1WE_INST_ROM   =>WE1,
  Ram1EN_INST_ROM   =>EN1,
  Ram2Data_INST_ROM =>data2,
  Ram2Addr_INST_ROM =>addr2,
  Ram2OE_INST_ROM   =>OE2,
  Ram2WE_INST_ROM   =>WE2,
  Ram2EN_INST_ROM   =>EN2,
  display1=>pc,
  display2=>inst,
  display3=>extend,
  display4=>regsrc12destEM
);

end Behavioral;

