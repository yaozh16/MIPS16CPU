----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:46:23 12/02/2018 
-- Design Name: 
-- Module Name:    PS2 - Behavioral 
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
use WORK.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PS2 is
	port(
		clk_ps2:in std_logic;
		data_ps2:in std_logic;
		rst:in std_logic;
		clk:in std_logic;
		
		
		keycode:out std_logic_vector(15 downto 0)	
		---7 downto 0 is keycode
		---15 16 is pressed
	);
end PS2;

architecture Behavioral of PS2 is
	
	TYPE keySerial is ARRAY(0 to 10)of STD_LOGIC;
	signal keydata:keySerial;
	signal dataCount:integer range 0 to 10:=0;
	signal clk_1:std_logic:='0';---used to format clk_ps2
	signal clk_2:std_logic:='0';---used to format clk_ps2
	signal clk_f:std_logic:='0';---used to format clk_ps2
	signal release:std_logic:='0';---used to format clk_ps2
	signal keycode_local:std_logic_vector(15 downto 0);
	signal keycode_current:std_logic_vector(7 downto 0);
begin
	clk_1<=clk_ps2 when rising_edge(clk);
	clk_2<=clk_1 when rising_edge(clk);
	clk_f<=not(clk_1) and clk_2;
	keycode<=keycode_local;
	
	
	keycode_current<=	keydata(0)&keydata(1)&keydata(2)&keydata(3)
							&keydata(4)&keydata(5)&keydata(6)&keydata(7);
	process(rst,clk,clk_f)
	begin
		if(rst='0')then
			dataCount<=0;
			keycode_local<=ZeroWord;
			release<='0';
		else
			if(clk_f'event and clk_f=HIGH)then
				if(dataCount>0)then
					keydata(dataCount)<=data_ps2;
					if(dataCount=10)then
						if(keycode_current=x"07")then
							release<='1';
							---keycode_local<=(keycode_local(15)+"1")&'1'&"000000"&keycode_local(7 downto 0);
						elsif(release='1' or not (keycode_local(7 downto 0)=keycode_current))then
							keycode_local<=(keycode_local(15)+"1")&release&"000000"&keycode_current;
							release<='0';
						end if;
						dataCount<=0;
					else
						dataCount<=dataCount+1;
					end if;
				elsif(data_ps2=LOW)then
					dataCount<=1;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

