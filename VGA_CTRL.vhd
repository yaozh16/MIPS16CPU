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
use work.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_CTRL is
	port(
		VGAAddr_o:out std_logic_vector(17 downto 0);		---data addr in rom
		VGAData_i:in std_logic_vector(15 downto 0);		---data from rom
		clk:in std_logic;
		rst:in std_logic;
		Rs:out std_logic_vector(2 downto 0);
		Gs:out std_logic_vector(2 downto 0);
		Bs:out std_logic_vector(2 downto 0);
		Hs:out std_logic;
		Vs:out std_logic
	);
end VGA_CTRL;

architecture Behavioral of VGA_CTRL is
	signal VGAdata_current:std_logic_vector(15 downto 0);
	signal VGAaddr_next_x:std_logic_vector(15 downto 0);
	signal VGAaddr_next_y:std_logic_vector(15 downto 0);
	signal display:std_logic;
	constant maxX:std_logic_vector(15 downto 0):=conv_std_logic_vector(799,16);
	constant startX:std_logic_vector(15 downto 0):=conv_std_logic_vector(656,16);
	constant maxY:std_logic_vector(15 downto 0):=conv_std_logic_vector(524,16);
	constant startY:std_logic_vector(15 downto 0):=conv_std_logic_vector(490,16);
	constant HdisplayArea:std_logic_vector(15 downto 0):=conv_std_logic_vector(480,16);
	constant VdisplayArea:std_logic_vector(15 downto 0):=conv_std_logic_vector(640,16);
	signal rowY:std_logic_vector(15 downto 0);
	signal colX:std_logic_vector(15 downto 0);
begin
	
-- 640 * 480 @60MHz
-- divided into 320 * 240 blocks;
	process(VGAaddr_next_x,VGAaddr_next_y)
	begin
		VGAAddr_o<=x"8000"+(VGAAddr_next_y/2)*160+(VGAAddr_next_x/2);
	end process;


	process(colX)
	begin
		if(colX<conv_std_logic_vector(656,16) or colX>=conv_std_logic_vector(752,16))then
			Hs<=HIGH;
		else
			Hs<=LOW;
		end if;
	end process;
	
	process(rowY)
	begin
		if(rowY<conv_std_logic_vector(490,16) or rowY>=conv_std_logic_vector(492,16))then
			Hs<=HIGH;
		else
			Hs<=LOW;
		end if;
	end process;
	
	process(rst,clk)
	begin
		if(rst=LOW)then
			colX<=startX;
			rowY<=startY;
		else
			if(clk'event and clk=HIGH)then
				if(colX<maxX)then
					colX<=colX+1;
				else
					colX<=ZeroWord;
					if(rowY<maxY)then
						rowY<=rowY+1;
					else
						rowY<=ZeroWord;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	process(rst,clk)
	begin
		if(rst=LOW)then
			VGAaddr_next_x<=ZeroWord;
			VGAaddr_next_y<=ZeroWord;
		else
			if(colX=maxX)then
				VGAaddr_next_x<=ZeroWord;
				if(rowY=maxY)then
					VGAaddr_next_y<=ZeroWord;
				else
					VGAaddr_next_y<=rowY+OneWord;
				end if;
			else
				VGAaddr_next_x<=colX+OneWord;
				VGAaddr_next_y<=rowY;
			end if;
		end if;
		if(clk'event and clk=HIGH)then
			VGAdata_current<=VGAData_i;
		end if;
	end process;
	
	
	RGBoutput:process(VGAdata_current,rowY,colX)
	begin
		if(colX<HdisplayArea and rowY<VdisplayArea)then
			Rs<=VGAdata_current(8 downto 6);
			Gs<=VGAdata_current(5 downto 3);
			Bs<=VGAdata_current(2 downto 0);
		end if;
	end process;
end Behavioral;

