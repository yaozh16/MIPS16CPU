----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:52:58 11/29/2018 
-- Design Name: 
-- Module Name:    INST_ROM - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use DEFINES.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity INST_ROM is
	Port(
		clk:in std_logic;
		rst:in std_logic;
		
		ce_id:in std_logic;
		addr_id:in std_logic_vector (15 downto 0);
		inst_id:out std_logic_vector (15 downto 0);
		
		mem_wr_i:in std_logic;
		mem_rd_i:in std_logic;
		mem_addr_i:in  std_logic_vector(15 downto 0);	
		mem_wdata_i:in  std_logic_vector(15 downto 0);
		mem_rdata_i:out std_logic_vector(15 downto 0);
		
		Ram1Addr: out std_logic_vector(17 downto 0);
		Ram1Data: inout std_logic_vector(15 downto 0);
		Ram1OE: out std_logic;
		Ram1WE: out std_logic;
		Ram1EN: out std_logic;
		
		Ram2Addr: out std_logic_vector(17 downto 0);
		Ram2Data: inout std_logic_vector(15 downto 0);
		Ram2OE: out std_logic;
		Ram2WE: out std_logic;
		Ram2EN: out std_logic
		
		);
		
		
		
		
end INST_ROM;

architecture Behavioral of INST_ROM is
	signal LoadComplete: std_logic;
	signal FlashDataOut: std_logic_vector(15 downto 0);
	signal isUser: std_logic;
begin
	Ram1_cltr:process(rst, clk) ---Ram1数据选择
	begin
		if(rst = Disable) then
			Ram1EN <= Disable;
			Ram1OE <= Enable;
			Ram1Addr <= (others => Disable);
			Ram1Data <= (others => 'Z');
		else
			if((mem_wr_i = Disable) and (mem_rd_i = Disable)) then
				Ram1Addr <= "00" & addr_id;
			end if;
			if((mem_wr_i = Disable) and (mem_rd_i = Disable)) then ---都不能
				Ram1Data <= (others => 'Z');
				if(clk'event and clk = '0') then
					Ram1EN <= Disable;
					Ram1OE <= Disable;
				end if;
			elsif(mem_wr_i = Enable) then ---mem可写
				Ram1OE <= Enable;
				Ram1EN <= Disable;
				Ram1Data <= mem_wdata_i;
			elsif(mem_rd_i = Enable) then ---mem可读
				Ram1Data <= (others => 'Z');
				if(clk'event and clk = '0') then
					Ram1EN <= Disable;
					Ram1OE <= Disable;
				end if;
			else ---rd wr同时enable 到不了这
				
			end if;
		end if;
	end process;
	
	Ram1WE_control: process(rst, clk, mem_wr_i, mem_rd_i) ---Ram1写使能控制
	begin
		if ((rst = Enable) or (mem_rd_i= Disable)) then
			Ram1WE <= '1';
		elsif (mem_wr_i = Enable) then
			Ram1WE <= clk;
		else 
			Ram1WE <= '1';
		end if;
	end process;
	
	Ram2WE_control: process(rst, clk, LoadComplete) ---Ram2写使能控制
	begin
		if (rst = Enable) then
			Ram2WE <= '1';
		elsif (LoadComplete = '1') then
			Ram2WE <= '0';
		else 
			Ram2WE <= '1';
		end if;
	end process;
	
	Ram2_Data: process(rst, LoadComplete, FlashDataOut) ---Ram2数据选择
	begin
		if (rst = Disable) then
			Ram2OE <= '1';
			Ram2Data <= (others => 'Z');
		else
			if (LoadComplete = '1') then
				Ram2OE <= '0';
				Ram2Data <= (others => 'Z');
			else
				Ram2Data <= FlashDataOut;
				Ram2OE <= '1';
			end if;
		end if;
	end process;
	
	Ram2_addr: process(mem_addr_i, mem_rd_i, mem_wr_i, addr_id, isUser) ---Ram2地址选择
	begin
		if(isUser = Enable and ((mem_rd_i = Enable) or (mem_wr_i = Enable))) then
			Ram2Addr <= "00" & mem_addr_i;
		else
			Ram2Addr <= "00" & addr_id;
		end if;
	end process;
			
	IsUser:process(mem_addr, isUser) ---是否在user范围内
	begin
		if((mem_addr > x"4000") and (mem_addr < x"8000")) then
			isUser <= Enable;
		else
			isUser <= Disable;
		end if;
	end process;
						
	Inst: process(rst,ce_id,rom_ready,Ram2Data,LoadComplete, isUser) ---id out部分
	begin
		if(rst = Disable) then
			if(isUser = Enable and ((mem_rd_i = Enable) or (mem_wr_i = Enable))) then
				inst_id <= NopInst;
			else
				inst_id <= Ram2Data;
			end if;
		end if;
	end process;
	
	Mem_read : process(rst,addr_id,addr_mem,re_mem,wdata_mem,Ram1Data) ---mem out部分
	begin
		if(rst = Disable) then
			if(isUser = Enable and ((mem_rd_i = Enable) or (mem_wr_i = Enable))) then
				mem_rdata_i <= Ram2Data;
			else
				mem_rdata_i <= Ram1Data;
			end if;
		end if;
	end process;
end Behavioral;