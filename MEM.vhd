----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:50:42 11/28/2018 
-- Design Name: 
-- Module Name:    mem - Behavioral 
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

entity MEM is
	Port(
		rst:in std_logic;
		
		wdata_i:in  std_logic_vector(15 downto 0);
		wdata_o:out  std_logic_vector(15 downto 0);
		
		reg_dest_i:in std_logic_vector(3 downto 0);
		reg_dest_o:out std_logic_vector(3 downto 0);
		
		mem_wr_i:in std_logic;
		mem_wr_o:out std_logic;
		
		mem_rd_i:in std_logic;
		mem_rd_o:out std_logic;
		
		mem_addr_i:in  std_logic_vector(15 downto 0);
		mem_addr_o:out  std_logic_vector(15 downto 0);
		
		mem_wdata_i:in  std_logic_vector(15 downto 0);
		mem_wdata_o:out std_logic_vector(15 downto 0);
		
		mem_rdata_i:in std_lo gic_vector(15 downto 0);
		
		mem_ce_o:out std_logic
	);
end mem;

architecture Behavioral of mem is
	signal ce : STD_LOGIC;
begin
	process(rst, mem_wdata_i, mem_addr_i, wdata_i, mem_wr_i, mem_rd_i, mem_rdata_i, reg_dest_i)
	begin		
		mem_ce_o <= ce;
		if(rst = Enable) then
			mem_wr_o <= Disable;
			mem_rd_o <= Disable;
			reg_dest_o <= RegAddrZero;
			mem_addr_o <= ZeroWord;
			mem_wdata_o <= ZeroWord;
			wdata_o <= ZeroWord;
			ce <= Disable;
		else			
			wdata_o <= ZeroWord;
			reg_dest_o <= RegAddrZero;
			mem_wr_o <= mem_wr_i;
			mem_rd_o <= mem_rd_i;
			if(mem_wr_i = Enable) then ---Sָ
				ce <= Enable;
				mem_wdata_o <= mem_wdata_i;
				mem_addr_o <= mem_addr_i;	
			elsif(mem_rd_i = Enable) then ---Lָ
				ce <= Enable;
				wdata_o <= mem_rdata_i;
				mem_addr_o <= mem_addr_i;
				reg_dest_o <= reg_dest_i;				
			else ---ָ
				ce <= Disable;
				wdata_o <= wdata_i;
				reg_dest_o <= reg_dest_i;
			end if;
		end if;
	end process;

end Behavioral;

