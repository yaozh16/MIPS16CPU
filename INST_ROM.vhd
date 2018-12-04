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
-- Uncomment the fol'0'ing library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the fol'0'ing library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;




entity INST_ROM is
	Port(
	
		serial_rw_install_o:out std_logic;	----serial write install 
		
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
		
		
		---flash component
		FlashLoadComplete_o:out std_logic;
		Flash_clk2:in std_logic;
		FlashAddr_o: out std_logic_vector(22 downto 0);
		FlashData_i: in std_logic_vector(15 downto 0);
		
		
		--serial
		se_wrn_o:out std_logic;
		se_rdn_o:out std_logic;
		se_tbre_i:in std_logic;
		se_tsre_i:in std_logic;
		se_data_ready_i:in std_logic
		);
			
end INST_ROM;

architecture Behavioral of INST_ROM is
	signal LoadComplete: std_logic:='0';
	signal serial_write:std_logic:='0';
	signal serial_read:std_logic:='0';
	signal serial_rw_install:std_logic:='0';
	signal FlashAddr:std_logic_vector(22 downto 0);
begin
	FlashLoadComplete_o<=LoadComplete;
	FlashAddr_o<=FlashAddr;
	
	---clk  	 	-|_|-|_|
	---clk_2	 	___|---|
	---ramWE	 	-|_|----
	---FlashWE	-----|_|
	---FlashOE	-|_|----
	---FlashDa	-|Z  |0F
	---addr_in	ad1  |ad2
	process(rst,clk,Flash_clk2,LoadComplete)
	begin
		if(rst='0')then
			LoadComplete<='1';
			FlashAddr<="1111"&"1111"&"1111"&"1111"&"1111"&"110";
		else
			if(LoadComplete='0')then
				if(clk'event and clk='0' and Flash_clk2='1')then	---down side
					if(FlashAddr="0000000"&x"FFFF")then
						FlashAddr<=FlashAddr+((x"00000")&"001");
						LoadComplete<='1';
					else
						FlashAddr<=FlashAddr+((x"00000")&"001");
					end if;
				end if;
			end if;
		end if;
	end process;
	


	process(mem_addr_i,FlashAddr,LoadComplete,id_addr_i,mem_rd_i,mem_wr_i) 
	begin
		if(LoadComplete='0')then
			Ram1Addr<=FlashAddr(18 downto 1);
		elsif(((mem_wr_i or mem_rd_i)='1'))then
			Ram1Addr<="00"&mem_addr_i;
		else
			Ram1Addr<="00"&id_addr_i;
		end if;
	end process;
	
	serial_rw_install_o<=serial_rw_install;
	process(clk,se_tbre_i,se_tsre_i)
	begin
		if((se_tbre_i='0') or (se_tsre_i='0'))then
			serial_rw_install<=not (se_tbre_i and se_tsre_i );
		elsif(clk'event and clk='1')then
			serial_rw_install<=not (se_tbre_i and se_tsre_i);
		end if;
	end process;
	Ram1_data:process(rst,clk,FlashData_i,LoadComplete)
	begin
		if(rst='0')then
			Ram1Data<=(others => 'Z');
		elsif(LoadComplete='0')then
			Ram1Data<=FlashData_i;
		else
			if(clk'event and clk='0')then
				if(serial_rw_install = '0')then
					if(mem_wr_i = '1') then
						Ram1Data <= mem_wdata_i;
					else
						Ram1Data <= (others => 'Z');
					end if;
				end if;
			end if;
		end if;
	end process;
	---Ram1 WE EN OE
	---serial_write
	---serial_read
	Ram1_cltr:process(rst, clk,
							LoadComplete,
							Flash_clk2,
							FlashAddr,
							mem_wdata_i,
							mem_wr_i,mem_rd_i,
							serial_rw_install,
							se_tbre_i,
							se_tsre_i
							)
	begin
		if(rst = '0') then
			Ram1WE <= '1';
			Ram1EN <= '0';
			Ram1OE <= '1';
			serial_write<='0';
			serial_read <='0';
		else	--- work
			if(LoadComplete='0')then
				Ram1WE<=Flash_clk2 or clk;
				Ram1EN<='0';
				Ram1OE<='1';
				serial_write<='0';
				serial_read <='0';
			else
				---mem
				if(serial_rw_install='1')then
					Ram1WE<='1';
					Ram1EN<='1';
					Ram1OE<='1';
				elsif(mem_wr_i = '1') then ---write
					if(se_tbre_i='0' or mem_addr_i=x"BF00")then			---write_serial
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE<='1';
						serial_write<='1';
						serial_read <='0';
					else										---write_Ram1
						Ram1WE<=clk;
						Ram1EN<='0';
						Ram1OE<='1';
						serial_write<='0';
						serial_read <='0';
					end if;
				elsif(mem_rd_i = '1') then ---read
					if(mem_addr_i=x"BF00")then	---read_serial
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE<='1';
						serial_write<='0';				
						serial_read <='1';
					elsif(mem_addr_i=x"BF01")then	---read_serial_flag
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE<='1';
						serial_write<='0';				
						serial_read <='0';	---do not need to read flag
					else 									---read_Ram1
						Ram1EN <= '0';				
						Ram1OE <= '0';	
						Ram1WE <= '1';
						serial_write<='0';				
						serial_read <='0';
					end if;		
				else 									---read_Ram1 for id
					Ram1EN <= '0';				
					Ram1OE <= '0';	
					Ram1WE <= '1';
					serial_write<='0';				
					serial_read <='0';
				end if;
			end if;
		end if;
	end process;

	
	
	
			
	
						
	Inst_out: process(rst,LoadComplete,mem_rd_i,mem_wr_i,Ram1Data,serial_rw_install) ---id out
	begin
		if(rst='1' and LoadComplete='1' and ((mem_rd_i or mem_wr_i or serial_rw_install)='0'))then
			id_inst_o<=Ram1Data;
			id_succ_o<='1';
		else
			id_inst_o<=NopInst;
			id_succ_o<='0';
		end if;
	end process;
	
	
	Mem_out : process(rst,id_addr_i,mem_rd_i,Ram1Data,LoadComplete,mem_addr_i,se_data_ready_i) ---mem out
	begin
		if((rst and mem_rd_i)='1')then ---working state and need output
			if(LoadComplete='0') then
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
	process(rst,clk,serial_read,serial_write,se_tbre_i,se_tsre_i)
	begin
		if(rst='0')then
			se_wrn_o<='1';
			se_rdn_o<='1';
		else
			if(serial_read='1')then
				se_rdn_o<=clk;
			else
				se_rdn_o<='1';
			end if;
			if(serial_write='1')then
				se_wrn_o<=clk or not(se_tbre_i and se_tsre_i);
			else
				se_wrn_o<='1';
			end if;
		end if;
	end process;
	
end Behavioral;