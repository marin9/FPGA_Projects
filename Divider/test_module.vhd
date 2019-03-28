library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_module is
port(	clk: in std_logic;
		rst: in std_logic;
		btn1: in std_logic;
		btn2: in std_logic;
		rdy: out std_logic;
		err: out std_logic;
		input: in std_logic_vector(3 downto 0);
		result: out std_logic_vector(3 downto 0);
		remainder: out std_logic_vector(3 downto 0));
end test_module;

architecture Behavioral of test_module is
	component divider is
	generic(WIDTH: positive := 4);
	port(	clk: in std_logic;
			rst: in std_logic;
			wr1: in std_logic;
			wr2: in std_logic;
			err: out std_logic;
			rdy: out std_logic;
			input: in std_logic_vector(WIDTH-1 downto 0);
			outQ: out std_logic_vector(WIDTH-1 downto 0);
			outR: out std_logic_vector(WIDTH-1 downto 0));
	end component;

	component debouncer is
	port(	clk: in std_logic;
			rst: in std_logic;
			input: in std_logic;
			output: out std_logic);
	end component;

	signal wr1, wr2: std_logic;
begin

	d0: debouncer port map(clk, rst, btn1, wr1);
	d1: debouncer port map(clk, rst, btn2, wr2);
	div: divider generic map(4) port map(clk, rst, wr1, wr2, err, rdy, input, result, remainder);

end Behavioral;

