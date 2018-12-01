----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:08:14 11/29/2018 
-- Design Name: 
-- Module Name:    SIMU_RAM - Behavioral 
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
use work.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SIMU_RAM is
	port(
		rst:in std_logic;
		addr:in std_logic_vector(17 downto 0);
		data:inout std_logic_vector(15 downto 0);
		WE:in std_logic;
		OE:in std_logic;
		EN:in std_logic
	);
end SIMU_RAM;

architecture Behavioral of SIMU_RAM is
	TYPE RAMDATA is ARRAY(0 to 31)of STD_LOGIC_VECTOR(15 downto 0);
	signal RAM:RAMDATA;
begin
	process(rst,WE,EN,OE,data,addr,RAM)
		variable i:integer;
	begin
		if(rst=LOW)then
			RAM(0)<="01101"&"000"&"00000001";	---LI R0 1			R0=1	
			RAM(1)<="11011"&"001"&"011"&"00000";	---SW R3,R1,0			MEM[1]=R3=4
			RAM(2)<="01101"&"001"&"00000001";	---LI R1 1			R1=1
			RAM(3)<="11100"&"000"&"001"&"010"&"01";	---ADDU R2,R0,R1	R2=2
			RAM(4)<="11100"&"001"&"010"&"000"&"01";	---ADDU R0,R1,R2	R0=3
			RAM(5)<="11100"&"010"&"010"&"011"&"01";	---ADDU R3,R2,R2	R3=4
			RAM(6)<="11011"&"001"&"011"&"00000";	---SW R3,R1,0			MEM[1]=R3=4
			for i in 7 to 31 loop
				RAM(i)<=NopInst;
			end loop;
		else
			if(EN=HIGH)then
				data<=(others => 'Z');
			else
				if(OE=LOW)then
					data<=RAM(CONV_INTEGER(addr(4 downto 0)));
				elsif(WE=LOW)then
					RAM(CONV_INTEGER(addr(4 downto 0)))<=data;
				else
					data<=(others => 'Z');
				end if;
			end if;
		end if;
	end process;

end Behavioral;

