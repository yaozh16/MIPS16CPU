
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.DEFINE.ALL;

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
			RAM(0)<="01101"&"110"&"10111111";			---LI R6 0x00BF
			RAM(1)<="00110"&"110"&"110"&"000"&"00";	---SLL R6 R6 0x0000
 			RAM(2)<="01001"&"110"&"00000001";			---ADDIU R6 0x0001
			RAM(3)<="10011"&"110"&"000"&"00000";		---LW R6 R0 0x0000
			RAM(4)<="01101"&"110"&"00000010";			---LI R6 0x0002
			RAM(5)<="11101"&"000"&"110"&"01100";		---AND R0 R6
			RAM(6)<="00100"&"000"&"11111001";			---BEQZ R0 F9
			RAM(7)<="00010"&"11111111000";			---BEQZ R0 FA
			for i in 8 to 31 loop
				RAM(i)<=NopInst;
			end loop;
		elsif(EN=HIGH)then
				data<=(others => 'Z');
		elsif(OE=LOW)then
				data<=RAM(CONV_INTEGER(addr(4 downto 0)));
		elsif(WE=LOW)then
				RAM(CONV_INTEGER(addr(4 downto 0)))<=data;
		else
				data<=(others => 'Z');
		end if;
	end process;

end Behavioral;

