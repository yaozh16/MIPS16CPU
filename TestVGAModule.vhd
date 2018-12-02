----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:43:35 12/02/2018 
-- Design Name: 
-- Module Name:    testVGA - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestVGAModule is
	port(
		
		clk:in std_logic;
		rst:in std_logic;
		
		colX_display:out std_logic_vector(15 downto 0);
		
		---hardware
		Rs:out std_logic_vector(2 downto 0);
		Gs:out std_logic_vector(2 downto 0);
		Bs:out std_logic_vector(2 downto 0);
		Hs:out std_logic;
		Vs:out std_logic
	);
end TestVGAModule;

architecture Behavioral of TestVGAModule is
	component VGA_CTRL port(
		VGAAddr_o:out std_logic_vector(17 downto 0);		---send to INST_ROM
		VGAData_i:in std_logic_vector(15 downto 0);		---recv from INST_ROM
		
		clk:in std_logic;
		rst:in std_logic;
		
		
		---hardware
		Rs:out std_logic_vector(2 downto 0);
		Gs:out std_logic_vector(2 downto 0);
		Bs:out std_logic_vector(2 downto 0);
		Hs:out std_logic;
		Vs:out std_logic
	);
	end component;
	signal VGAAddr_o: std_logic_vector(17 downto 0);		---send to INST_ROM
	signal VGAData_i: std_logic_vector(15 downto 0);		---recv from INST_ROM
	signal clk_count:integer:=0;
	signal color:std_logic_vector(8 downto 0):="000000000";
begin
	uut:VGA_CTRL port map(
		VGAAddr_o=>VGAAddr_o,
		VGAData_i=>VGAData_i,
		clk=>clk,
		rst=>rst,
		Rs=>Rs,
		Gs=>Gs,
		Bs=>Bs,
		Hs=>Hs,
		Vs=>Vs
	);
	process(rst,clk)
	begin
		if(rst='0')then
			clk_count<=0;
			color<="000000000";
		else
			if(clk'event and clk='1')then
				if(clk_count=50000000)then
					clk_count<=0;
					color<=color+"000000001";
				else
					clk_count<=clk_count+1;
				end if;
			end if;
		end if;
	end process;
	colX_display<=VGAData_i;
	VGAData_i<="0000000"&color;
end Behavioral;

