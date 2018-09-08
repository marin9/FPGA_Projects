library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bootloader is
port(
	clk: in std_logic;
	rst: in std_logic;
	sck: out std_logic;
	ss: out std_logic;
	si: out std_logic;
	so: in std_logic;
	en: out std_logic;
	wr: out std_logic;
	addr: out std_logic_vector(12 downto 0);
	data: out std_logic_vector(7 downto 0);
	fin: out std_logic);
end bootloader;

architecture Behavioral of bootloader is
	type stanje is(START, SEND, RECV, MEM, FINISH);
	signal trenutno, sljedece: stanje;
	
	signal request: std_logic_vector(23 downto 0);
	signal counter_bit: std_logic_vector(4 downto 0);
	signal counter_bit_next: std_logic_vector(4 downto 0);
	signal counter_byte: std_logic_vector(12 downto 0);
	signal counter_byte_next: std_logic_vector(12 downto 0);
	signal data_t: std_logic_vector(7 downto 0);
	signal en_sck: std_logic;
	
	signal clk0: std_logic;
	signal clk_div: std_logic_vector(50 downto 0);
begin

	clk0 <= clk_div(50);
	sck <= clk0 and en_sck;
	addr <= counter_byte;
	data <= data_t;
	request <= "000000000000000011000000";

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				clk_div <= (0 => '1', others => '0');
			else
				clk_div <= clk_div(49 downto 0) & clk_div(16);
			end if;
		end if;
	end process;
	
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then			
				trenutno <= START;
				data_t <= (others => '0');
				counter_bit <= (others => '0');
				counter_byte <= (others => '0');
			elsif(clk0='1') then			
				trenutno <= sljedece;
				data_t <= data_t(6 downto 0) & so;
				counter_bit <= counter_bit_next;
				counter_byte <= counter_byte_next;
			end if;
		end if;
	end process;
	

	process(trenutno, request, counter_bit, counter_byte) is
	begin
		en_sck <= '0';
		ss <= '1';
		si <= '0';
		en <= '0';
		wr <= '0';
		fin <= '0';
		sljedece <= trenutno;
		counter_bit_next <= counter_bit;
		counter_byte_next <= counter_byte;
		
		case trenutno is
		when START =>
			sljedece <= SEND;
			counter_bit_next <= (others => '0');		
		when SEND =>
			ss <= '0';
			en_sck <= '1';
			counter_bit_next <= counter_bit + 1;
			si <= request(conv_integer(counter_bit));
			if(counter_bit="10111") then
				sljedece <= RECV;
				counter_bit_next <= (others => '0');
				counter_byte_next <= (others => '0');
			end if;
		when RECV =>
			ss <= '0';
			en_sck <= '1';
			counter_bit_next <= counter_bit + 1;
			if(counter_bit="111") then
				sljedece <= MEM;
			end if;		
		when MEM =>
			ss <= '0';
			counter_byte_next <= counter_byte + 1;
			en <= '1';
			wr <= '1';
			if(counter_byte="1111111111111") then
				sljedece <= FINISH;
			else
				sljedece <= RECV;
				counter_bit_next <= (others => '0');
			end if;	
		when FINISH =>
			ss <= '1';
			fin <= '1';
			en <= '1';	
		when others =>
			null;
		end case;
	end process;
	
end Behavioral;