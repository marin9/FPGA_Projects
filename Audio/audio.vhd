library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity audio is
port(	clk: in std_logic;
		rst: in std_logic;
		pause: in std_logic;
		wr: in std_logic;
		full: out std_logic;
		empty: out std_logic;
		input: in std_logic_vector(7 downto 0);
		output: out std_logic);
end audio;

architecture Behavioral of audio is
	component counter is
	generic(waitclk: natural := 1000; nbits: natural := 10);
	port(	clk: in std_logic;
			rst: in std_logic;
			tick: out std_logic);
	end component;

	component fifo is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			rd: in std_logic;
			full: out std_logic;
			empty: out std_logic;
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;
	
	component pwm is
	generic(width: positive := 8);
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic);
	end component;
	
	component edgedetect is
	port(	clk: in std_logic;
			rst: in std_logic;
			x: in std_logic;
			y: out std_logic);
	end component;
	
	signal clk2, tick, tick2, wr2: std_logic;
	signal d_bus: std_logic_vector(7 downto 0);
begin
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			clk2 <= not clk2;
		end if;
	end process;

	tick2 <= pause and tick;
	cnt: counter generic map(3125 , 12) port map(clk2, rst, tick);
	ed: edgedetect port map(clk2, rst, wr, wr2);
	buff: fifo port map(clk2, rst, wr2, tick2, full, empty, input, d_bus);
	pwmc: pwm port map(clk2, rst, tick2, d_bus, output);

end Behavioral;

