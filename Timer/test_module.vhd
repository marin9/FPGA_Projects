library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_module is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic;
		rd: in std_logic;
		int: out std_logic;
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0));
end test_module;

architecture Behavioral of test_module is
	component timer is
	generic(WIDTH: positive := 8);
	port(	clk: in std_logic;
			rst: in std_logic;
			tick: in std_logic;
			wr: in std_logic;
			rd: in std_logic;
			int: out std_logic;
			input: in std_logic_vector(WIDTH-1 downto 0);
			output: out std_logic_vector(WIDTH-1 downto 0));
	end component;

	component counter is
	generic(waitclk: natural := 1000; nbits: natural := 10);
	port(	clk: in std_logic;
			rst: in std_logic;
			tick: out std_logic);
	end component;

	component debouncer is
	port(	clk: in std_logic;
			rst: in std_logic;
			input: in std_logic;
			output: out std_logic);
	end component;


	signal clk2, tick, wr2, rd2: std_logic;
begin
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			clk2 <= not clk2;
		end if;
	end process;

	db0: debouncer port map(clk2, rst, wr, wr2);
	db1: debouncer port map(clk2, rst, rd, rd2);
	cnt: counter generic map(25000000, 25) port map(clk2, wr2, tick);
	tmr: timer port map(clk2, rst, tick, wr2, rd2, int, input, output);

end Behavioral;

