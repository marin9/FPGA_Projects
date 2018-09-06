library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mcu is
port(	clk50: in std_logic;
		reset: in std_logic;
		ioport: inout std_logic_vector(7 downto 0));
end mcu;

architecture Behavioral of mcu is
	component cpu is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			addr: out std_logic_vector(11 downto 0);
			din: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;

	component ram is
	port(	clk: in std_logic;
			wr:in std_logic;
			addr: in std_logic_vector(11 downto 0);
			din: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;

	component timer is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;

	component gpio is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr_mode: in std_logic;
			wr_din: in std_logic;			
			input: in std_logic;
			output: out std_logic;
			gpio: inout std_logic);
	end component;

	signal clk: std_logic := '0';
	signal clk1: std_logic := '0';
	signal rst, wr: std_logic;
	signal addr: std_logic_vector(11 downto 0);
	signal data_in, data_out: std_logic_vector(7 downto 0);
	signal ram_out: std_logic_vector(7 downto 0);
	signal tmr_wr: std_logic;
	signal tmr_out: std_logic_vector(7 downto 0);
	signal gpio_mod, gpio_wr: std_logic;
	signal gpio_out: std_logic_vector(7 downto 0);
begin

	clk_div: process(clk50) is
	begin
		if(falling_edge(clk50)) then
			clk <= clk1;
			clk1 <= not clk;
		end if;
	end process;

	reset_ff: process(clk) is
	begin
		if(falling_edge(clk)) then
			rst <= reset;
		end if;
	end process;

	processor: cpu port map(clk, rst, wr, addr, data_in, data_out);

	memory: ram port map(clk, wr, addr, data_out, ram_out);

	timer0: timer port map(clk, rst, tmr_wr, data_out, tmr_out);

	gpion: for i in 0 to 7 generate
		gpio_n: gpio port map(clk, rst, gpio_mod, gpio_wr, data_out(i), gpio_out(i), ioport(i));
   end generate gpion;
	
	with addr select data_in <=
	tmr_out	when x"FFF",
	gpio_out	when x"FFE",
	ram_out	when others;
	
	with addr select tmr_wr <=
	'1' when x"FFD",
	'0' when others;
	
	with addr select gpio_mod <=
	'1' when x"FFC",
	'0' when others;
	
	with addr select gpio_wr <=
	'1' when x"FFB",
	'0' when others;

end Behavioral;

