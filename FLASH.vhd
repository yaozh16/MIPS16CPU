----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:08:45 11/29/2018 
-- Design Name: 
-- Module Name:    FLASH - Behavioral 
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
use WORK.DEFINE.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


---clk  	 		-|_|-|_|
---clk_2	 		___|---|
---ramWE	 		-|_|----
---FlashWE		-----|_|
---FlashOE		-|___|--
---FlashDa	    |Z  |0F
---addr_in	     ad1|ad2
					  ---change when clk down and clk_2=1
entity FLASH is
	Port(
			  clk : in std_logic;
			  FlashLoad_Complete:in std_logic;
			  Flash_clk2:out std_logic;
			  rst : in std_logic;
			  
			  
			  ---RAM
			  RAMAddr_i:in std_logic_vector(22 downto 0);
			  ---VGA
			  VGAAddr_i:in std_logic_vector(22 downto 0);	---VGAData addr in ram2
           FlashData_o:out std_logic_vector(15 downto 0);
			  
			  
			  flash_byte : out std_logic;
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;				---ce0
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  flash_addr : out std_logic_vector(22 downto 0);
			  flash_data : inout std_logic_vector(15 downto 0)
	);
end FLASH;
---
---
architecture Behavioral of FLASH is
	signal clk_2:std_logic;
begin
	Flash_clk2<=clk_2;
	process(clk)
	begin
		if (clk'event and clk=HIGH) then
			if(clk_2=HIGH)then
				clk_2<=LOW;
			else
				clk_2<=HIGH;
			end if;
		end if;
	end process;
	flash_byte <= '1';
	flash_vpen <= '1';
	flash_ce <= '0';
	flash_rp <= '1';
	flash_oe<=not rst;
	flash_we<=rst;
	process(FlashLoad_Complete,VGAAddr_i,RAMAddr_i)
	begin
		if(FlashLoad_Complete='0')then
			flash_addr<=RAMAddr_i;
		else
			flash_addr<=VGAAddr_i;
		end if;
	end process;
	
	FlashData_o<=flash_data;
	FlashDataControl:process(rst)
	begin
			if((rst)=LOW)then
				flash_data<=x"00FF";
			else
				flash_data<="ZZZZZZZZZZZZZZZZ";
			end if;
	end process;
end Behavioral;

