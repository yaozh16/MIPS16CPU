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
		led_out:out std_logic_vector(15 downto 0);
		clk:in std_logic;
		rst:in std_logic;
		
		
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
		
		ScreenBlockIndex_o :out std_logic_vector(11 downto 0);
		ScreenOffset_i:in std_logic_vector(17 downto 0);
		
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
	signal ScreenBlockIndex_o: std_logic_vector(11 downto 0);		---recv from buff
	signal ScreenOffset_i: std_logic_vector(17 downto 0);		---recv from buff
	
	signal clk_count:integer:=0;
	signal clk_2:std_logic:='0';
	signal color:std_logic_vector(7 downto 0):="00000000";
begin

	process(clk)
	begin
		if(clk'event and clk='0')then
			clk_2<=not clk_2;
		end if;
	end process;
	VGA_CTRL_i : VGA_CTRL
	port map (
	  VGAAddr_o          => VGAAddr_o,
	  VGAData_i          => VGAData_i,
	  ScreenBlockIndex_o => ScreenBlockIndex_o,
	  ScreenOffset_i     => ScreenOffset_i,
	  clk                => clk,
	  rst                => rst,
	  Rs                 => Rs,
	  Gs                 => Gs,
	  Bs                 => Bs,
	  Hs                 => Hs,
	  Vs                 => Vs
	);
	

	process(rst,clk)
	begin
		if(rst='0')then
			clk_count<=0;
			color<="00000000";
		else
			if(clk'event and clk='1')then
				if(clk_count=50000000)then
					clk_count<=0;
					color<=color+"00000001";
				else
					clk_count<=clk_count+1;
				end if;
			end if;
		end if;
	end process;
	
	
	process(ScreenBlockIndex_o)
	begin
		ScreenOffset_i<="00"&x"0"&ScreenBlockIndex_o;
	end process;
	---VGAData_i<="0000000"&color;
	process(VGAAddr_o)
	begin
		if(ScreenBlockIndex_o<x"4B0")then
			VGAData_i<=ScreenBlockIndex_o(7 downto 0)&ScreenBlockIndex_o(7 downto 0);
		else
			VGAData_i<=color&color;
		end if;
	end process;
	led_out<=VGAAddr_o(3 downto 0)&ScreenBlockIndex_o;
end Behavioral;

