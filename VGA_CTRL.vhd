----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:01 12/01/2018 
-- Design Name: 
-- Module Name:    VGA_CTRL - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


---clk  	 	-|_|-|_|
---clk_2	 	___|---|
---ramWE	 	-|_|----
---FlashWE	-----|_|
---FlashOE	-|_|----
---FlashDa	-|Z  |0F
---addr_in	ad1  |ad2
entity VGA_CTRL is
	port(
		VGAAddr_o:out std_logic_vector(22 downto 0);		---send to Flash
		VGAData_i:in std_logic_vector(15 downto 0);		---recv from Flash
		
		clk:in std_logic;
		rst:in std_logic;
		
		---hardware
		Rs:out std_logic_vector(2 downto 0);
		Gs:out std_logic_vector(2 downto 0);
		Bs:out std_logic_vector(2 downto 0);
		Hs:out std_logic;
		Vs:out std_logic
	);
end VGA_CTRL;

architecture Behavioral of VGA_CTRL is
	signal VGAdata_current:std_logic_vector(15 downto 0);
	signal VGAaddr_next_x:integer range 0 to 640:=0;
	signal VGAaddr_next_y:integer range 0 to 480:=0;
	constant maxX:integer:=799;
	constant startX:integer:=656;
	constant maxY:integer:=524;
	constant startY:integer:=490;
	signal rowY:integer:=0;
	signal colX:integer:=0;
	signal clk_2:std_logic:='0';
begin
	
-- 640 * 480 @60MHz
-- divided into 320 * 240 blocks;
	process(VGAaddr_next_x,VGAaddr_next_y)
	begin
		VGAAddr_o<="0000000"&"1000000000000000"+conv_std_logic_vector((VGAAddr_next_y/2)*160,18)+conv_std_logic_vector((VGAAddr_next_x/2),18);
	end process;
	process(clk)
	begin
		if(clk'event and clk='1')then
			clk_2<=not clk_2;
		end if;
	end process;

	process(colX)
	begin
		if(colX<656 or colX>=752)then
			Hs<=HIGH;
		else
			Hs<=LOW;
		end if;
	end process;
	
	process(rowY)
	begin
		if(rowY<490 or rowY>=492)then
			Vs<=HIGH;
		else
			Vs<=LOW;
		end if;
	end process;
	
	process(rst,clk_2)
	begin
		if(rst=LOW)then
			colX<=656;
			rowY<=490;
		else
			if(clk_2'event and clk_2=HIGH)then
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
	
	process(rst,clk_2,rowY,colX)
	begin
		if(rst=LOW)then
			VGAaddr_next_x<=0;
			VGAaddr_next_y<=0;
		else
			if(colX=maxX)then
				VGAaddr_next_x<=0;
				if(rowY=maxY)then
					VGAaddr_next_y<=0;
				else
					VGAaddr_next_y<=rowY+1;
				end if;
			else
				VGAaddr_next_x<=colX+1;
				VGAaddr_next_y<=0;
			end if;
		end if;
		if(clk_2'event and clk_2=HIGH)then
			VGAdata_current<=VGAData_i;
		end if;
	end process;
	
	
	RGBoutput:process(VGAdata_current,rowY,colX)
	begin
		if(colX<640 and rowY<480)then
			Rs<=VGAdata_current(8 downto 6);
			Gs<=VGAdata_current(5 downto 3);
			Bs<=VGAdata_current(2 downto 0);
		else
			Rs<="000";
			Gs<="000";
			Bs<="000";
		end if;
	end process;
end Behavioral;

