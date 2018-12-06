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
	
		se_rw_stall_o:out std_logic;	----serial write install 
		
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
		
		keycode_i:in std_logic_vector(15 downto 0);		---connect to PS2
		
		Screen_posi_o:out std_logic_vector(11 downto 0);
		Screen_data_o:out std_logic_vector(17 downto 0);		----AddrOffset
		Screen_we_o:out STD_LOGIC_VECTOR(0 DOWNTO 0);
		
		VGAAddr_i:in std_logic_vector(17 downto 0);
		VGAData_o:out std_logic_vector(15 downto 0);
		
		
		---communicate with devices
		Ram1Addr: out std_logic_vector(17 downto 0);
		Ram1Data: inout std_logic_vector(15 downto 0);
		Ram1OE: out std_logic;
		Ram1WE: out std_logic;
		Ram1EN: out std_logic;
		
		
		---communicate with devices
		Ram2Addr: out std_logic_vector(17 downto 0);
		Ram2Data: inout std_logic_vector(15 downto 0);
		Ram2OE: out std_logic;
		Ram2WE: out std_logic;
		Ram2EN: out std_logic;
		
		
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
	signal FlashAddr:std_logic_vector(22 downto 0);
	signal Ram1OE_t:std_logic;
	signal Ram2OE_t:std_logic;
	signal se_rw_stall_state:integer:=0;
	signal se_rw_stall:std_logic;
	signal random_data:std_logic_vector(15 downto 0);
begin
	FlashLoadComplete_o<=LoadComplete;
	FlashAddr_o<=FlashAddr;
	Ram1OE<=Ram1OE_t;
	---clk  	 	-|_|-|_|
	---clk_2	 	___|---|
	---ramWE	 	-|_|----
	---FlashWE	-----|_|
	---FlashOE	-|_|----
	---FlashDa	-|Z  |0F
	---addr_in	ad1  |ad2
	process(clk,rst)
	begin
		if(rst='0')then
			random_data<=x"0000";
		elsif(clk'event and clk='1')then
			random_data<=random_data+(x"00"&se_rw_stall&Ram1OE_t&id_addr_i(4 downto 0)&"1");
		end if;
	end process;
	
	
	process(rst,clk,Flash_clk2,LoadComplete)
	begin
		if(rst='0')then
			LoadComplete<='0';
			FlashAddr<="1111"&"1111"&"1111"&"1111"&"1111"&"110";
		else
			if(LoadComplete='0')then
				if(clk'event and clk='0' and Flash_clk2='1')then	---down side
					if(FlashAddr="000"&x"7FFFF")then
						FlashAddr<=FlashAddr+((x"00000")&"001");
						LoadComplete<='1';
					else
						FlashAddr<=FlashAddr+((x"00000")&"001");
					end if;
				end if;
			end if;
		end if;
	end process;
	


	Ram1addr_ctrl:process(mem_addr_i,FlashAddr,LoadComplete,id_addr_i,mem_rd_i,mem_wr_i) 
	begin
		if(LoadComplete='0')then
			Ram1Addr<=FlashAddr(18 downto 1);
		elsif(((mem_wr_i or mem_rd_i)='1'))then
			Ram1Addr<="00"&mem_addr_i;
		else
			Ram1Addr<="00"&id_addr_i;
		end if;
	end process;
	Ram1data_ctrl:process(rst,clk,FlashData_i,LoadComplete,
								mem_wdata_i,mem_wr_i,mem_addr_i,
								mem_rd_i,se_data_ready_i,keycode_i,
								random_data)
	begin
		if(rst='0')then
			Ram1Data<=(others => 'Z');
		elsif(LoadComplete='0')then
			Ram1Data<=FlashData_i;
		else
			if(mem_wr_i = '1') then
				Ram1Data <= mem_wdata_i;
			elsif(mem_addr_i=x"BF01" and mem_rd_i='1')then
				Ram1Data <= x"000"&"00"&(se_data_ready_i)&(se_tbre_i and se_tsre_i);
			elsif(mem_addr_i=x"BF07" and mem_rd_i='1')then
				Ram1Data <= keycode_i;
			elsif(mem_addr_i=x"BF08" and mem_rd_i='1')then
				Ram1Data <= random_data;
			else
				Ram1Data <= (others => 'Z');
			end if;
		end if;
	end process;
	
	
	
	Ram2EN<='0';
	Ram2OE<=Ram2OE_t;
	process(FlashAddr,VGAAddr_i,LoadComplete,Ram2Data)
	begin
		if(LoadComplete='0')then
			VGAData_o<=(others=>'1');
			Ram2Addr<=FlashAddr(18 downto 1);
		else
			VGAData_o<=Ram2Data;
			Ram2Addr<=VGAAddr_i;
		end if;
	end process;
	Ram2_ctrl:process(FlashAddr,LoadComplete,FlashData_i,Flash_clk2,clk,VGAAddr_i)
	BEGIN
		if(LoadComplete='0')then
			Ram2Data<=FlashData_i;
			Ram2WE<=Flash_clk2 or clk;
			Ram2OE_t<='1';
		else
			---as VGA data
			Ram2Data<=(others=>'Z');
			Ram2WE<='1';
			Ram2OE_t<='0';
		end if;
	end process;


	process(rst,clk,LoadComplete)
	begin
		if(rst='0')then
			Screen_we_o<="0";
		elsif(LoadComplete='0')then
			Screen_we_o<=""& (not clk);
			Screen_posi_o<=FlashAddr(11 downto 0);
			Screen_data_o<="00"&x"8000";
		elsif(mem_wr_i='1' and mem_addr_i=x"BF04")then
			Screen_we_o<="0";
			if(clk'event and clk='0')then
							-----block index	=y*80+x
							-----					=y*64+y*16+x
							-----	y=mem_wdata_i(5  downto 0)		:max 6 bit
							-----	x=mem_wdata_i(15  downto 8)		:max 8 bit
					Screen_posi_o<=((mem_wdata_i(5  downto 0))&"000000")
												+("00"&mem_wdata_i(5  downto 0)&"0000")
												+("0000"&mem_wdata_i(15  downto 8));	
			end if;
		elsif(mem_wr_i='1' and mem_addr_i=x"BF05")then
			Screen_we_o<="0";
			if(clk'event and clk='0')then
					Screen_data_o<=mem_wdata_i(13 downto 0)&"0000";
			end if;
		elsif(mem_wr_i='1' and mem_addr_i=x"BF05")then
			Screen_we_o<=""&(not clk);
		else
			Screen_we_o<="0";
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
							se_rw_stall,
							se_tbre_i,
							se_tsre_i,
							mem_addr_i
							)
	begin
		if(rst = '0') then
			Ram1WE <= '1';
			Ram1EN <= '0';
			Ram1OE_t <= '1';
			serial_write<='0';
			serial_read <='0';
		else	--- work
			if(LoadComplete='0')then
				Ram1WE<=Flash_clk2 or clk;
				Ram1EN<='0';
				Ram1OE_t<='1';
				serial_write<='0';
				serial_read <='0';
			else
				---mem
				if(mem_wr_i = '1') then ---write
					if(mem_addr_i=x"BF00")then			---write_serial
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE_t<='1';
						serial_write<='1';
						serial_read <='0';
					elsif(mem_addr_i=x"BF04")then			---write screen position
						Ram1WE<=clk;
						Ram1EN<='1';
						Ram1OE_t<='1';
						serial_write<='0';
						serial_read <='0';
						
					elsif(mem_addr_i=x"BF05")then			---write screen data offset
						Ram1WE<=clk;
						Ram1EN<='1';
						Ram1OE_t<='1';
						serial_write<='0';
						serial_read <='0';
					elsif(mem_addr_i=x"BF06")then			---write screen enable
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE_t<='1';
						serial_write<='0';
						serial_read <='0';
					else										---write_Ram1
						Ram1WE<=clk;
						Ram1EN<='0';
						Ram1OE_t<='1';
						serial_write<='0';
						serial_read <='0';
					end if;
				elsif(mem_rd_i = '1') then ---read
					if(mem_addr_i=x"BF00")then	---read_serial
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE_t<='1';
						serial_write<='0';				
						serial_read <='1';
					elsif(mem_addr_i=x"BF01")then	---read_serial_flag
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE_t<='1';
						serial_write<='0';				
						serial_read <='0';	---do not need to read flag
					elsif(mem_addr_i=x"BF07")then	---read_keycode
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE_t<='1';
						serial_write<='0';				
						serial_read <='0';
					elsif(mem_addr_i=x"BF08")then	---read_random
						Ram1WE<='1';
						Ram1EN<='1';
						Ram1OE_t<='1';
						serial_write<='0';				
						serial_read <='0';
					else 									---read_Ram1
						Ram1EN <= '0';				
						Ram1OE_t <= Ram1OE_t and clk;	--lock
						Ram1WE <= '1';
						serial_write<='0';				
						serial_read <='0';
					end if;		
				else 									---read_Ram1 for id
					Ram1EN <= '0';				
					Ram1OE_t <= clk and Ram1OE_t;	
					Ram1WE <= '1';
					serial_write<='0';				
					serial_read <='0';
				end if;
			end if;
		end if;
	end process;

	
	
	
			
	
						
	Inst_out: process(rst,LoadComplete,mem_rd_i,mem_wr_i,Ram1Data,se_rw_stall) ---id out
	begin
		if((rst='1') and (LoadComplete='1') and ((mem_rd_i or mem_wr_i or se_rw_stall)='0'))then
			id_inst_o<=Ram1Data;
			id_succ_o<='1';
		else
			id_inst_o<=NopInst;
			id_succ_o<='0';
		end if;
	end process;
	
	
	Mem_out : process(rst,id_addr_i,mem_rd_i,Ram1Data,LoadComplete) ---mem out
	begin
		if((rst and mem_rd_i)='1')then ---working state and need output
			if(LoadComplete='0') then
				mem_rdata_o<=ZeroWord;
			else
				mem_rdata_o<=Ram1Data;		---read ram1
			end if;
		else
			mem_rdata_o<=ZeroWord;
		end if;
	end process;
	
	
	----serial port ctrl
	---need the exe_mem register do not change while serial writing
	se_rw_stall_o<=se_rw_stall;
	process(rst,se_tbre_i,se_tsre_i,se_rw_stall,clk)
	begin
		if(rst='0')then
			se_rw_stall<='0';
			se_rw_stall_state<=0;
		elsif(clk'event and (clk='0'))then
			if(se_rw_stall_state=0)then
				--- down edge switch state
				if(serial_write='1')then
					se_rw_stall_state<=1;
					se_rw_stall<='1';
					se_wrn_o<='0';
				else
					se_rw_stall_state<=0;
					se_rw_stall<='0';
					se_wrn_o<='1';
				end if;
			else
				se_wrn_o<='1';
				if(se_rw_stall_state=1)then
					if((se_tbre_i='1'))then
						se_rw_stall_state<=se_rw_stall_state+1;
						se_rw_stall<='1';
					end if;
				elsif(se_rw_stall_state=2)then
					if((se_tbre_i='1') and (se_tsre_i='1'))then
						se_rw_stall_state<=se_rw_stall_state+1;
						se_rw_stall<='0';
					end if;
				elsif(se_rw_stall_state=3)then
					if((se_tbre_i='1') and (se_tsre_i='1'))then
						se_rw_stall_state<=0;
						se_rw_stall<='0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	process(rst,clk,serial_read)
	begin
		if(rst='0')then
			se_rdn_o<='1';
		else
			if(serial_read='1')then
				se_rdn_o<=clk;
			else
				se_rdn_o<='1';
			end if;
		end if;
	end process;
	
end Behavioral;