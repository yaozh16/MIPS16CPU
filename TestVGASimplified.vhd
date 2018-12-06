----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:54:09 12/06/2018 
-- Design Name: 
-- Module Name:    TestVGASimplified - Behavioral 
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

entity TestVGASimplified is
	port(
		
		clk:in std_logic;
		rst:in std_logic;
		
		
		---hardware
		Rs:out std_logic_vector(2 downto 0);
		Gs:out std_logic_vector(2 downto 0);
		Bs:out std_logic_vector(2 downto 0);
		Hs:out std_logic;
		Vs:out std_logic
	);
end TestVGASimplified;

architecture Behavioral of TestVGASimplified is
	signal colX,rowY:integer:=0;
	signal clk_2:std_logic:='0';
	
	constant maxX:integer:=799;
	constant maxY:integer:=524;
begin
	process(clk)
	begin
		if(rst='0')then
			clk_2<='0';
		elsif(clk'event and clk='1')then
			clk_2<=not clk_2;
		end if;
	end process;
	---colX
	process(colX)
	begin
		if(colX<656 or colX>=752)then
			Hs<='1';
		else
			Hs<='0';
		end if;
	end process;
	---rowY
	process(rowY)
	begin
		if(rowY<490 or rowY>=492)then
			Vs<='1';
		else
			Vs<='0';
		end if;
	end process;
	
	---update
	process(clk_2)
	begin
		if(rst='0')then
			colX<=maxX-1;
			rowY<=maxY;
		else
			---colX and rowY change,VGAdata_current lock
			if(clk_2'event and clk_2='1')then
				if(colX<maxX)then
					colX<=colX+1;
				else
					colX<=0;
					if(rowY<maxY)then
						rowY<=rowY+1;
					else
						rowY<=0;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	RGBoutput:process(rowY,colX)
	begin
		if((colX<640) and (rowY<480))then
			Rs<="111";
			Gs<="111";
			Bs<="000";
		else
			Rs<="000";
			Gs<="000";
			Bs<="000";
		end if;
	end process;
end Behavioral;

