----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:48:33 12/04/2018 
-- Design Name: 
-- Module Name:    screen_mem - Behavioral 
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

entity screen_mem is
	port(
		clk:in std_logic;
		rst:in std_logic;
		
		modify_pos_i:in std_logic_vector(15 downto 0);
		modify_color_i:in std_logic_vector(15 downto 0);
		modify_i:in std_logic;
		
		---hardware
		Rs:out std_logic_vector(2 downto 0);
		Gs:out std_logic_vector(2 downto 0);
		Bs:out std_logic_vector(2 downto 0);
		Hs:out std_logic;
		Vs:out std_logic
		
	);
end screen_mem;

architecture Behavioral of screen_mem is
	TYPE SCREENData is ARRAY(0 to 204799)of STD_LOGIC_VECTOR(15 downto 0);
	signal screen_data:SCREENData;
	signal clk_2:std_logic;
	signal colX:integer;
	signal rowY:integer;
	
begin
process(colX)
	begin
		if(colX<656 or colX>=752)then
			Hs<='1';
		else
			Hs<='0';
		end if;
	end process;
	
	process(rowY)
	begin
		if(rowY<490 or rowY>=492)then
			Vs<='1';
		else
			Vs<='0';
		end if;
	end process;

	process(colX,rowY)
	begin
		if((colX<640) and (rowY<480))then
				Rs<=screen_data(colX+rowY*640)(8 downto 6);
				Gs<=screen_data(colX+rowY*640)(5 downto 3);
				Bs<=screen_data(colX+rowY*640)(2 downto 0);
		else				
				Rs<="000";
				Gs<="000";
				Bs<="000";
		end if;
	end process;

	process(rst,clk,modify_i)
		variable pos_v:integer:=0;
	begin
		if(rst='0')then
			for i in 0 to 204799 loop
				if(i<640*160)then
					screen_data(i)<="0000000"&"001001111";
				elsif(i<640*320)then
					screen_data(i)<="0000000"&"001111001";
				else
					screen_data(i)<="0000000"&"111001001";
				end if;
			end loop;
		else
			if(clk'event and clk='0')then
				---divide to 40x40
				---640x480=16x12
				if(modify_i='1')then
					pos_v:=conv_integer(modify_pos_i);
					--if(pos_v<
				end if;
			end if;
		end if;
	end process;

end Behavioral;

