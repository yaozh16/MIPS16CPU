----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:02:17 12/01/2018 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Combination is
end Combination;

architecture Behavioral of Combination is
component CPU 
	port(
		clk:in std_logic;
		rst:in std_logic;
		
		id_addr_i_INST_ROM:out std_logic_vector (15 downto 0);	---pc
		id_inst_o_INST_ROM:in std_logic_vector(15 downto 0);
		id_succ_o_INST_ROM:in std_logic;
		
		mem_wr_i_INST_ROM:out std_logic;
		mem_rd_i_INST_ROM:out std_logic;
		mem_addr_i_INST_ROM:out std_logic_vector(15 downto 0);
		mem_wdata_i_INST_ROM:out std_logic_vector(15 downto 0);
		mem_rdata_o_INST_ROM:in std_logic_vector(15 downto 0)
	);
end component;


begin


end Behavioral;

