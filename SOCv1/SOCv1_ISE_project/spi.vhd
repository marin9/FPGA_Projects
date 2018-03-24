library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity spi is
port( clk: in std_logic;
		rst: in std_logic;
		ss: out std_logic;
		sck: out std_logic;
		si: out std_logic;
		so: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(11 downto 0);
		data: out std_logic_vector(15 downto 0);
		fin: out std_logic);
end spi;

architecture Behavioral of spi is
	type stanje is(START, SS0, SEND, RECV, MEM, SS1);
	signal trenutno, sljedece: stanje;
	
	signal timer0: std_logic_vector(4 downto 0);
	signal timer1: std_logic_vector(11 downto 0);
	signal rst_t0: std_logic;
	signal rst_t1: std_logic;
	signal inc_t1: std_logic;
	
	constant request: std_logic_vector(23 downto 0) := x"0000c0";
	signal shift_reg: std_logic_vector(15 downto 0);
	signal shift_en: std_logic;
	
	signal sck_en: std_logic;
begin

	-- clock timer t0
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst_t0='1') then
				timer0 <= (others => '0');
			else
				timer0 <= timer0 + 1;
			end if;
		end if;
	end process;

	-- data timer t1
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst_t1='1') then
				timer1 <= (others => '0');
			elsif(inc_t1='1') then
				timer1 <= timer1 + 1;
			end if;
		end if;
	end process;

	-- data shift register
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(shift_en='1') then
				shift_reg <= shift_reg(14 downto 0) & so;
			end if;
		end if;
	end process;

	sck <= clk and sck_en;
	
	addr <= timer1;
	data <= shift_reg;

	-- state machine logic
	process(trenutno, timer0, timer1) is
	begin
		sljedece <= trenutno;
		rst_t0 <= '0';
		rst_t1 <= '0';
		inc_t1 <= '0';
		shift_en <= '0';
		sck_en <= '0';
		ss <= '0';
		si <= '0';
		wr <= '0';
		fin <= '1';
	
		case trenutno is
		when START =>
			ss <= '1';
			rst_t0 <= '1';
			rst_t1 <= '1';
			sljedece <= SS0;
			
		when SS0 =>
			if(timer0="00100") then
				rst_t0 <= '1';
				sljedece <= SEND;
			end if;
		
		when SEND =>
			sck_en <= '1';
			si <= request(conv_integer(timer0));
			if(timer0="10111") then
				rst_t0 <= '1';
				sljedece <= RECV;
			end if;
			
		when RECV =>
			sck_en <= '1';
			shift_en <= '1';
			if(timer0="01111") then
				rst_t0 <= '1';						
				sljedece <= MEM;				
			end if;
		
		when MEM =>
			wr <= '1';
			if(timer0="00000") then
				rst_t0 <= '1';
				inc_t1 <= '1';
				if(timer1=x"FFF") then
					sljedece <= SS1;
				else
					sljedece <= RECV;
				end if;
			end if;
		
		when SS1 =>
			ss <= '1';
			fin <= '0';
		
		when others =>
			null;
		end case;
	end process;

	-- state machine register
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				trenutno <= START;
			else
				trenutno <= sljedece;
			end if;
		end if;
	end process;

end Behavioral;

