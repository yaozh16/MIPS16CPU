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
use DEFINE.ALL;

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
		
		id_addr_i:in std_logic_vector (15 downto 0);	---pc
		id_inst_o:out std_logic_vector (15 downto 0);	---returned id
		
		mem_wr_i:in std_logic;		---mem ctrl signal
		mem_rd_i:in std_logic;		---mem ctrl signal
		mem_addr_i:in  std_logic_vector(15 downto 0);		---mem signal
		mem_wdata_i:in  std_logic_vector(15 downto 0);		---mem signal
		mem_rdata_o:out std_logic_vector(15 downto 0);
		
		---communicate with devices
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
	process(mem_addr_i, isUser) ---ǷuserΧ
	begin
		if((mem_addr_i > x"4000") and (mem_addr_i < x"8000")) then
			isUser <= Enable;
		else
			isUser <= Disable;
		end if;
	end process;
	
	Ram1Addr <="00"& mem_addr_i;
	
	
	Ram1_cltr:process(rst, clk,mem_wdata_i,mem_wr_i) ---Ram1ѡ
	begin
		if(rst = LOW) then
			Ram1EN <= HIGH;
			Ram1OE <= HIGH;
			Ram1Data <= (others => 'Z');
		else	--- work
			if(mem_wr_i = Enable) then ---mem write
				Ram1OE <= HIGH;
				Ram1EN <= LOW;
				if(clk'event and clk=LOW)then
					Ram1Data <= mem_wdata_i;
				end if;
			elsif(mem_rd_i = Enable) then ---mem read
				if(clk'event and clk=LOW)then
					Ram1Data <= (others => 'Z');
				end if;
				Ram1EN <= LOW;				
				Ram1OE <= clk;			
			else ---
				Ram1EN <= HIGH;
				Ram1OE <= HIGH;
			end if;
		end if;
	end process;
	
	Ram1WE_control: process(rst, clk, mem_wr_i, isUser) ---Ram1
	begin
		if ((rst=HIGH) and (mem_wr_i=HIGH) and (isUser=LOW)) then
			Ram1WE <= clk;
		else 
			Ram1WE <= HIGH;
		end if;
	end process;
	
	Ram2WE_control: process(rst, clk, LoadComplete,mem_wr_i,isUser) ---Ram2
	begin
		if(rst=LOW) then
			Ram2WE <= '1';
		elsif(LoadComplete=LOW)then
			Ram2WE<=clk;
		elsif(mem_wr_i=HIGH and isUser=HIGH) then
			Ram2WE<=clk;
		else
			Ram2WE <= '1';
		end if;
	end process;
	
	Ram2EN<=LOW;
	
	Ram2_ctrl: process(rst, LoadComplete, FlashDataOut,isUser,clk) ---Ram2ѡ
	begin
		if (rst = LOW) then
			Ram2OE <= '1';
			Ram2Data <= (others => 'Z');
		else ---work
			if (LoadComplete = HIGH) then
				if(isUser=HIGH and mem_wr_i=HIGH)then
					Ram2Data<=mem_wdata_i;
				else
					if(clk'event and clk=LOW)then
						Ram2Data <= (others => 'Z');
					end if;
				end if;
			else
				---work to do
				Ram2Data <= FlashDataOut;
				Ram2OE <= '1';
			end if;
		end if;
	end process;
	
	Ram2_addr:process(isUser,mem_wr_i,mem_rd_i,id_addr_i,mem_addr_i)
	begin
		if((isUser and (mem_wr_i or mem_rd_i))=HIGH)then
			Ram2Addr<="00"&mem_addr_i;
		else
			Ram2Addr<="00"&id_addr_i;
		end if;
	end process;
			
	
						
	Inst: process(rst,Ram2Data,LoadComplete, isUser,mem_rd_i,mem_wr_i) ---id out
	begin
		if(rst=HIGH and LoadComplete=HIGH and (((mem_rd_i or mem_wr_i) and isUser)=HIGH))then
			id_inst_o<=Ram2Data;
		else
			id_inst_o<=NopInst;
		end if;
	end process;
	
	Mem_read : process(rst,id_addr_i,mem_rd_i,Ram2Data,Ram1Data) ---mem out
	begin
		if((rst and mem_rd_i)=HIGH)then
			if(isUser=LOW) then
				mem_rdata_o<=Ram1Data;
			elsif(LoadComplete=HIGH)then
				mem_rdata_o<=Ram2Data;
			else
				mem_rdata_o<=ZeroWord;
			end if;
		else
			mem_rdata_o<=ZeroWord;
		end if;
	end process;
end Behavioral;