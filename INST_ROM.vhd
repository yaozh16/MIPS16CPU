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
use WORK.DEFINE.ALL;

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
		
		---flash component
		FlashLoad_Complete:out std_logic;
		FlashLoad_clk:out std_logic;
		FlashAddr_o: out std_logic_vector(22 downto 0);
		FlashData_i: in std_logic_vector(15 downto 0);
		
		---VGA
		VGAAddr:in std_logic_vector(17 downto 0);	---VGAData addr in ram2
		VGAData:out std_logic_vector(15 downto 0);	---VGAData in ram2(pixel image)
		
		--serial
		se_wrn_o,se_rdn_o:out std_logic;
		se_tbre_i,se_tsre_i,se_data_ready_i:in std_logic
		);
			
end INST_ROM;

architecture Behavioral of INST_ROM is
	signal LoadComplete: std_logic:=LOW;
	signal serial_write:std_logic:=LOW;
	signal serial_read:std_logic:=LOW;
	signal clk_2:std_logic:=LOW;
	signal FlashAddr:std_logic_vector(22 downto 0);
	
begin
	FlashLoad_clk<=clk_2;
	FlashAddr_o<=FlashAddr;
	Ram2EN<=LOW;
	process(rst,clk,clk_2,LoadComplete)
	begin
		if(rst=LOW)then
			LoadComplete<=LOW;
			FlashAddr<=(others=>'1');
		else
			if(LoadComplete=LOW)then
				if(clk'event and clk=LOW and clk_2=HIGH)then	---down side
					if(FlashAddr<"00001"&"1111111111111110")then
						FlashAddr<=FlashAddr+1;
					else
						FlashAddr<=FlashAddr+1;
						---LoadComplete<=HIGH;
					end if;
				end if;
			end if;
		end if;
	end process;
	FlashLoad_Complete<=LoadComplete;
	
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

	process(mem_addr_i) 
	begin
		if(LoadComplete=LOW and FlashAddr<x"8000")then
			Ram1Addr<=(FlashAddr(17 downto 0));
		elsif(((mem_wr_i or mem_rd_i)=HIGH))then
			Ram1Addr<="00"&mem_addr_i;
		else
			Ram1Addr<="00"&id_addr_i;
		end if;
	end process;
	
	
	
	
	Ram1_data:process(rst,clk,FlashData_i)
	begin
		if(rst=LOW)then
			Ram1Data<=(others=>'Z');
		elsif(LoadComplete=LOW)then
			Ram1Data<=FlashData_i;
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
							LoadComplete,
							clk_2,
							FlashAddr,
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
			if(LoadComplete=LOW and FlashAddr<x"8000")then
				Ram1WE<=clk_2 or clk;
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

	
	
	
			
	
						
	Inst_out: process(rst,Ram2Data,LoadComplete,mem_rd_i,mem_wr_i,Ram1Data) ---id out
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
	Ram2WE_control: process(rst, clk,clk_2, LoadComplete) ---Ram2
	begin
		if(rst=LOW) then
			Ram2WE <= HIGH;
		elsif(LoadComplete=LOW)then
			Ram2WE<=clk_2 or clk;
		else
			Ram2WE <= HIGH;
		end if;
	end process;
	-----ROM access
	Ram2_ctrl: process(rst, LoadComplete,clk,mem_wr_i,mem_wdata_i,FlashData_i) ---Ram2ѡ
	begin
		if (rst = LOW) then
			Ram2OE <= HIGH;
			Ram2Addr<="00"&ZeroWord;
			Ram2Data <= (others => 'Z');
			VGAData<=ZeroWord;
		else ---work
			if (LoadComplete = LOW) then---Load from Flash
				VGAData<=ZeroWord;
				Ram2Data<=FlashData_i;
				Ram2Addr<=FlashAddr(17 downto 0);
				Ram2OE <= HIGH;
			else
				VGAData<=Ram2Data;
				Ram2Data<=(others=>'Z');		---read VGA Data
				Ram2Addr<=VGAAddr;		---from vga component
				Ram2OE<=LOW;
			end if;
		end if;
	end process;
end Behavioral;