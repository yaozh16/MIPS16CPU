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
use DEFINE.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FLASH is
	Port(
			  clk : in std_logic;
			  rst : in std_logic;
			  
			  addr:in STD_LOGIC_VECTOR(21 downto 0);
           data_out:out STD_LOGIC_VECTOR(15 downto 0);
			  
			  flash_byte : out std_logic;
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  flash_addr : out std_logic_vector(21 downto 0);
			  flash_data : inout std_logic_vector(15 downto 0);
			  
           ctl_read : in  STD_LOGIC
	);
end FLASH;

architecture Behavioral of FLASH is
	type flash_state is (
		waiting, read1, read2, read3, read4, read5, done
	);
	signal state : flash_state := waiting;
	signal ctl_read_last : std_logic;
begin
	flash_byte <= '1';
	flash_vpen <= '1';
	flash_ce <= '0';
	flash_rp <= '1';
	
	process(rst, clk, ctl_read)
	begin
		if(rst = LOW) then
			flash_we <= '1';
         flash_oe <= '1';
			
			ctl_read_last <= ctl_read;
			state <= waiting;
		elsif (clk'event and clk = '1') then
			case state is
				when waiting=>
					if (ctl_read /= ctl_read_last) then
						flash_we <= '0';
						state <= read1;
						ctl_read_last <= ctl_read;
					end if;
				when read1=>
					flash_we <= LOW;
					state<=read2;
				when read2=>
					flash_data <= x"00FF";
					state <= read3;
				when read3=>
					flash_we <= HIGH;
					state <= read4;
				when read4=>	
					flash_oe <= LOW;
					flash_addr <= addr;
					flash_data <= (others => 'Z');
					state <= read5;
				when read5=>
					data_out <= flash_data;
					flash_oe <= HIGH;
					state <= done;
				when others=>
					flash_oe <= HIGH;
					flash_we <= HIGH;
					flash_data <= (others => 'Z');
					state <= waiting;
			end case;
		end if;
	end process;
end Behavioral;

