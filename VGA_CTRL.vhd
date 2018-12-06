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
end VGA_CTRL;

architecture Behavioral of VGA_CTRL is
	signal VGAdata_current:std_logic_vector(15 downto 0);
	signal VGAdata:std_logic_vector(15 downto 0);
	signal VGAAddr:std_logic_vector(17 downto 0);
	signal VGAaddr_next_x:std_logic_vector(11 downto 0):=x"000";
	signal VGAaddr_next_y:std_logic_vector(11 downto 0):=x"000";
	constant maxX:std_logic_vector(11 downto 0):=conv_std_logic_vector(799,12);
	constant maxY:std_logic_vector(11 downto 0):=conv_std_logic_vector(524,12);
	constant C752:std_logic_vector(11 downto 0):=conv_std_logic_vector(752,12);
	constant C656:std_logic_vector(11 downto 0):=conv_std_logic_vector(656,12);
	constant C490:std_logic_vector(11 downto 0):=conv_std_logic_vector(490,12);
	constant C492:std_logic_vector(11 downto 0):=conv_std_logic_vector(492,12);
	constant C640:std_logic_vector(11 downto 0):=conv_std_logic_vector(640,12);
	constant C480:std_logic_vector(11 downto 0):=conv_std_logic_vector(480,12);
	
	signal rowY:std_logic_vector(11 downto 0):=x"000";
	signal colX:std_logic_vector(11 downto 0):=x"000";
	
	signal blockY:std_logic_vector(5 downto 0):="000000";
	signal blockX:std_logic_vector(7 downto 0):="00000000";
	signal clk_2:std_logic:='0';
	
	
begin
	
	process(clk)
	begin
		if(clk'event and clk='0')then
			clk_2<=not clk_2;
		end if;
	end process;
	
	VGAAddr_o<=VGAAddr;
	VGAdata<=VGAdata_i;
-- 640 * 480 @60MHz
-- divided into 8 * 16 blocks;
-- 	total:    80 * 30;
	
	---blockIndex_o=(y/16)*480+(x/8)
	---result in ScreenOffset_i changes
	blockY<=VGAAddr_next_y(9 downto 4);	---y/16
	blockX<=VGAAddr_next_x(10 downto 3);	---x/8
	
	
	ScreenBlockIndex_o<=	(blockY&  "000000")+		---blockY*64
								("00"&blockY&"0000")+		---blockY*16
								("0000"&blockX);			---blockX
	process(ScreenOffset_i,VGAaddr_next_y,VGAaddr_next_x)
	begin
		---Addr=offset + ((y mod 16)*8+(x mod 8))/2
		---Addr=offset + (y mod 16)*4	+ (x mod 8)/2
		VGAAddr<=(ScreenOffset_i(13 downto 0)&"0000")
					--+(x"000"&(VGAaddr_next_y(3 downto 0))&"00")
					--+(x"0000"&(VGAaddr_next_x(2 downto 1)))
					;
	end process;
	

	process(colX)
	begin
		if(colX<C656 or colX>=C752)then
			Hs<='1';
		else
			Hs<='0';
		end if;
	end process;
	
	process(rowY)
	begin
		if(rowY<C490 or rowY>=C492)then
			Vs<='1';
		else
			Vs<='0';
		end if;
	end process;
	
	
	
	process(rst,clk_2,rowY,colX)
	begin
		if(rst=LOW)then
			colX<=x"000";
			rowY<=x"000";
		else
			---next
			if(colX=maxX)then
				VGAaddr_next_x<=x"000";
				if(rowY=maxY)then
					VGAaddr_next_y<=x"000";
				else
					VGAaddr_next_y<=rowY+x"001";
				end if;
			else
				VGAaddr_next_x<=colX+(x"001");
				VGAaddr_next_y<=rowY;
			end if;
			---colX and rowY change,VGAdata_current lock
			if(clk_2'event and clk_2='1')then
				if(colX<maxX)then
					colX<=colX+(x"001");
				else
					colX<=x"000";
					if(rowY<maxY)then
						rowY<=rowY+x"001";
					else
						rowY<=x"000";
					end if;
				end if;
			end if;
			if(clk_2'event and clk_2='0')then
				VGAdata_current<=VGAdata;
			end if;
		end if;
	end process;
	
	
	RGBoutput:process(VGAdata_current,rowY,colX)
	begin
		if((colX<C640) and (rowY<C480))then
			
			Rs<="111";
			Gs<="111";
			Bs<="000";
			if(colX(0) = '0')then
				Rs<=VGAdata_current(15 downto 13);
				Gs<=VGAdata_current(12 downto 10);
				Bs<=VGAdata_current(9 downto 8)&"0";
			else
				Rs<=VGAdata_current(7 downto 5);
				Gs<=VGAdata_current(4 downto 2);
				Bs<=VGAdata_current(1 downto 0)&"0";
			end if;
		else
			Rs<="000";
			Gs<="000";
			Bs<="000";
		end if;
	end process;
end Behavioral;

