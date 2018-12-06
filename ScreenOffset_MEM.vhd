----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:30:06 12/07/2018 
-- Design Name: 
-- Module Name:    ScreenOffset_MEM - Behavioral 
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

entity ScreenOffset_MEM is
	PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
	);
end ScreenOffset_MEM;

architecture Behavioral of ScreenOffset_MEM is
	TYPE RAMDATA is ARRAY(0 to 2399)of STD_LOGIC_VECTOR(17 downto 0);
	signal screen_ram:RAMDATA;
begin
	doutb<=screen_ram(conv_integer(addrb));
	process(wea,clka)
		variable i:integer:=0;
	begin
		if(clka='0')then
			for i in 0 to 2399 loop
				screen_ram(i)<="00"&x"0800";
			end loop;
		elsif(wea'event and wea="1")then
			screen_ram(conv_integer(addra))<=dina;
		end if;
	end process;

end Behavioral;

