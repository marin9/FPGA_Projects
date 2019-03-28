library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_module is
port(	clk: in std_logic;
		rst: in std_logic;
		btn1: in std_logic;
		btn2: in std_logic;
		rdy: out std_logic;
		input: in std_logic_vector(3 downto 0);
		output: out std_logic_vector(7 downto 0));
end test_module;

architecture Behavioral of test_module is
	component multiplier is
	generic(WIDTH: positive := 4);
	port(	clk: in std_logic;
			rst: in std_logic;
			wr1: in std_logic;
			wr2: in std_logic;
			rdy: out std_logic;
			input: in std_logic_vector(WIDTH-1 downto 0);
			outH: out std_logic_vector(WIDTH-1 downto 0);
			outL: out std_logic_vector(WIDTH-1 downto 0));
	end component;
	
	component debouncer is
	port(	clk: in std_logic;
			rst: in std_logic;
			input: in std_logic;
			output: out std_logic);
	end component;

	signal wr1, wr2: std_logic;
	signal outH, outL: std_logic_vector(3 downto 0);
begin

	b0: debouncer port map(clk ,rst, btn1, wr1);
	b1: debouncer port map(clk, rst, btn2, wr2);
	ml: multiplier generic map(4) port map(clk, rst, wr1, wr2, rdy, input, outH, outL);
	output <= outH & outL;
	
end Behavioral;

