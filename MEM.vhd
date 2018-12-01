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
use work.DEFINE.ALL;

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
		
		reg_dest_i:in std_logic_vector(3 downto 0);		---inherit
		mem_wr_i:in std_logic;									---connect to reg between parts,write signal
		mem_rd_i:in std_logic;									---connect to reg between parts,read signal
		ALU_result_i:in  std_logic_vector(15 downto 0);		---connect to reg between parts,ALU result
		mem_wdata_i:in  std_logic_vector(15 downto 0);		---connect to reg beween parts,oper2
		writeback_mux_i:in std_logic;
		
		mem_wr_o:out std_logic;									---connect to memory unit
		mem_rd_o:out std_logic;									---connect to memory unit
		mem_addr_o:out  std_logic_vector(15 downto 0);		---connect to memory unit
		mem_wdata_o:out std_logic_vector(15 downto 0);		---connect to memory unit
		mem_rdata_i:in std_logic_vector(15 downto 0);		---connect to memory unit
		
		reg_dest_o:out std_logic_vector(3 downto 0);		---inherit
		writeback_data_o: out std_logic_vector(15 downto 0)----connect to reg between parts
	);
end mem;

architecture Behavioral of MEM is
begin
	process(writeback_mux_i,mem_rdata_i,ALU_result_i)
	begin
		case writeback_mux_i is
			when MEM_MUX_ALU_RESULT		=>writeback_data_o<=ALU_result_i;
			when MEM_MUX_MEM_OUT			=>writeback_data_o<=mem_rdata_i;
			when others	=>writeback_data_o<=ZeroWord;
		end case;
	end process;
	
	
	process(rst, mem_wdata_i, ALU_result_i, mem_wdata_i, mem_wr_i, mem_rd_i, mem_rdata_i, reg_dest_i)
	begin
		if(rst = LOW) then
			mem_wr_o <= LOW;
			mem_rd_o <= LOW;
			reg_dest_o <= RegAddrNOP;
			mem_addr_o <= ZeroWord;
			mem_wdata_o <= ZeroWord;
		else			
			mem_wr_o <= mem_wr_i;
			mem_rd_o <= mem_rd_i;
			reg_dest_o <= reg_dest_i;
			mem_addr_o <= ALU_result_i;
			mem_wdata_o <= mem_wdata_i;
		end if;
	end process;

end Behavioral;

