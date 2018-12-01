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
use work.DEFINE.ALL;

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
		id_succ_o:out std_logic;
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
		Ram2EN: out std_logic;
		
		
		--serial
		se_wrn_o,se_rdn_o:out std_logic;
		se_tbre_i,se_tsre_i,se_data_ready_i:in std_logic
		);
		
		
		
		
end INST_ROM;

architecture Behavioral of INST_ROM is
	signal LoadComplete: std_logic;
	signal FlashDataOut: std_logic_vector(15 downto 0);
	signal FlashAddr:std_logic_vector(17 downto 0);
	signal serial_write:std_logic:=LOW;
	signal serial_read:std_logic:=LOW;
	signal clk_2:std_logic:=LOW;
	signal VGAAddr:std_logic_vector(17 downto 0);	---VGAData addr in ram2
	signal VGAData:std_logic_vector(15 downto 0);	---VGAData in ram2(pixel image)
	signal VGAData2:std_logic_vector(15 downto 0);	---VGAData in ram2
	signal VGAPos_unmapped:std_logic_vector(15 downto 0);	---VGAData send to pos(unmapped)
	signal VGAPos:std_logic_vector(15 downto 0);	---VGAData send to pos(actual Pos)
begin

	
	---addr src arrange
	Ram1_addr:process(mem_wr_i,mem_rd_i,id_addr_i,mem_addr_i)
	begin
		if(LoadComplete=LOW)then
			Ram1Addr<=FlashAddr;
		elsif(((mem_wr_i or mem_rd_i)=HIGH))then
			Ram1Addr<="00"&mem_addr_i;
		else
			Ram1Addr<="00"&id_addr_i;
		end if;
	end process;
	
	
	Ram2EN<=LOW;
	LoadComplete<='1';
	
	
	Ram1_data:process(rst,clk)
	begin
		if(rst=LOW)then
			Ram1Data<=(others=>'Z');
		elsif(LoadComplete=LOW)then
			Ram1Data<=FlashDataOut;
		else
			if(clk'event and clk=LOW)then
				if(mem_wr_i = Enable) then
					Ram1Data <= mem_wdata_i;
				else
					Ram1Data <= (others => 'Z');
				end if;
			end if;
		end if;
	end process;
	---Ram1 WE EN OE
	---serial_write
	---serial_read
	Ram1_cltr:process(rst, clk,
							mem_wdata_i,
							mem_wr_i,mem_rd_i
							)
	begin
		if(rst = LOW) then
			Ram1WE <= HIGH;
			Ram1EN <= HIGH;
			Ram1OE <= HIGH;
			Ram1Data <= (others => 'Z');
			serial_write<=LOW;
			serial_read <=LOW;
		else	--- work
			if(LoadComplete=LOW)then
				Ram1WE<=clk_2;
				Ram1EN<=LOW;
				Ram1OE<=HIGH;
				serial_write<=LOW;
				serial_read <=LOW;
			else
				---mem
				if(mem_wr_i = Enable) then ---write
					if(mem_addr_i=x"BF00")then			---write_serial
						Ram1WE<=HIGH;
						Ram1EN<=HIGH;
						Ram1OE<=HIGH;
						serial_write<=HIGH;
						serial_read <=LOW;
					else										---write_Ram1
						Ram1WE<=clk;
						Ram1EN<=LOW;
						Ram1OE<=HIGH;
						serial_write<=LOW;
						serial_read <=LOW;
					end if;
				elsif(mem_rd_i = Enable) then ---read
					if(mem_addr_i=x"BF00")then	---read_serial
						Ram1WE<=HIGH;
						Ram1EN<=HIGH;
						Ram1OE<=HIGH;
						serial_write<=LOW;				
						serial_read <=HIGH;
					elsif(mem_addr_i=x"BF01")then	---read_serial_flag
						Ram1WE<=HIGH;
						Ram1EN<=HIGH;
						Ram1OE<=HIGH;
						serial_write<=LOW;				
						serial_read <=LOW;	---do not need to read flag
					else 									---read_Ram1
						Ram1EN <= LOW;				
						Ram1OE <= LOW;	
						Ram1WE <= HIGH;
						serial_write<=LOW;				
						serial_read <=LOW;
					end if;		
				else
				end if;
			end if;
		end if;
	end process;

	
	
	
			
	
						
	Inst_out: process(rst,Ram2Data,LoadComplete,mem_rd_i,mem_wr_i) ---id out
	begin
		if(rst=HIGH and LoadComplete=HIGH and ((mem_rd_i or mem_wr_i)=LOW))then
			id_inst_o<=Ram1Data;
			id_succ_o<=HIGH;
		else
			id_inst_o<=NopInst;
			id_succ_o<=LOW;
		end if;
	end process;
	
	Mem_out : process(rst,id_addr_i,mem_rd_i,Ram2Data,Ram1Data,LoadComplete,mem_addr_i) ---mem out
	begin
		if((rst and mem_rd_i)=HIGH)then ---working state and need output
			if(LoadComplete=LOW) then
				mem_rdata_o<=ZeroWord;
			elsif(mem_addr_i=x"BF00")then	---read_serial
				mem_rdata_o<=Ram1Data;
			elsif(mem_addr_i=x"BF01")then	---read_serial_flag
				mem_rdata_o<=Zero15&se_data_ready_i;
			else
				mem_rdata_o<=Ram1Data;		---read ram1
			end if;
		else
			mem_rdata_o<=ZeroWord;
		end if;
	end process;
	
	
	----serial port ctrl
	process(rst)
	begin
		if(rst=LOW)then
			se_wrn_o<=HIGH;
			se_rdn_o<=HIGH;
		else
			if(serial_read=HIGH)then
				se_rdn_o<=clk;
			else
				se_rdn_o<=HIGH;
			end if;
			if(serial_write=HIGH)then
				se_wrn_o<=clk;
			else
				se_wrn_o<=HIGH;
			end if;
		end if;
	end process;
	
	---VGA Rom ctrl
	-----ROM load
	Ram2WE_control: process(rst, clk, LoadComplete) ---Ram2
	begin
		if(rst=LOW) then
			Ram2WE <= HIGH;
		elsif(LoadComplete=LOW)then
			Ram2WE<=clk_2;
		else
			Ram2WE <= HIGH;
		end if;
	end process;
	-----ROM access
	Ram2_ctrl: process(rst, LoadComplete,clk,mem_wr_i,mem_wdata_i) ---Ram2ѡ
	begin
		if (rst = LOW) then
			Ram2OE <= HIGH;
			Ram2Addr<="00"&ZeroWord;
			Ram2Data <= (others => 'Z');
			VGAData<=ZeroWord;
		else ---work
			if (LoadComplete = LOW) then---Load from Flash
				VGAData<=ZeroWord;
				Ram2Data<=FlashDataOut;
				Ram2Addr<=FlashAddr;
				Ram2OE <= HIGH;
			else
				VGAData<=Ram2Data;
				Ram2Data<=(others=>'Z');		---read VGA Data
				Ram2Addr<=VGAAddr;		---vga component
				Ram2OE<=LOW;
			end if;
		end if;
	end process;
end Behavioral;