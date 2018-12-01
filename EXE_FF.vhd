----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:03:17 11/29/2018 
-- Design Name: 
-- Module Name:    EXE_Fastforward - Behavioral 
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
use work.DEFINE.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EXE_FF is
	port(
		---proxy for exe src input
		reg_src1_data_i:in std_logic_vector(15 downto 0);
		reg_src2_data_i:in std_logic_vector(15 downto 0);
		
		reg_exemem_dest_data_i:in std_logic_vector(15 downto 0);
		reg_memwb_dest_data_i:in std_logic_vector(15 downto 0);
		
		
		reg_src1_addr_i:in std_logic_vector(3 downto 0);
		reg_src2_addr_i:in std_logic_vector(3 downto 0);
		reg_exemem_dest_addr_i:in std_logic_vector(3 downto 0);
		reg_memwb_dest_addr_i:in std_logic_vector(3 downto 0);
		
		----warning!
		-- if the ALU result is not used as register data (instead it is used as mem addr)
		-- then we should pause the pipeline ahead in other module
		
		---output correct data
		reg_src1_data_o:out std_logic_vector(15 downto 0);
		reg_src2_data_o:out std_logic_vector(15 downto 0)
	);
end EXE_FF;

architecture Behavioral of EXE_FF is
	
begin	
	Data1:process(	reg_src1_data_i,
				reg_exemem_dest_data_i,
				reg_memwb_dest_data_i,
				reg_src1_addr_i,
				reg_exemem_dest_addr_i,
				reg_memwb_dest_addr_i)
	begin
		if(reg_src1_addr_i=RegAddrNOP)then
			reg_src1_data_o<=reg_src1_data_i;
		else
			if(reg_src1_addr_i=reg_exemem_dest_addr_i)then
				reg_src1_data_o<=reg_exemem_dest_data_i;
			elsif(reg_src1_addr_i=reg_memwb_dest_addr_i)then
				reg_src1_data_o<=reg_memwb_dest_data_i;
			else
				reg_src1_data_o<=reg_src1_data_i;
			end if;
		end if;
	end process;
	
	Data2:process(	reg_src2_data_i,
				reg_exemem_dest_data_i,
				reg_memwb_dest_data_i,
				reg_src2_addr_i,
				reg_exemem_dest_addr_i,
				reg_memwb_dest_addr_i)
	begin
		if(reg_src2_addr_i=RegAddrNOP)then
			reg_src2_data_o<=reg_src2_data_i;
		else
			if(reg_src2_addr_i=reg_exemem_dest_addr_i)then
				reg_src2_data_o<=reg_exemem_dest_data_i;
			elsif(reg_src2_addr_i=reg_memwb_dest_addr_i)then
				reg_src2_data_o<=reg_memwb_dest_data_i;
			else
				reg_src2_data_o<=reg_src2_data_i;
			end if;
		end if;
	end process;

end Behavioral;

