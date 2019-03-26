library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_module is
port(	clk: in std_logic;
		rst: in std_logic;
		btn1: in std_logic;
		e: out std_logic;
		i: out std_logic;
		f: out std_logic;
		rx: in std_logic;
		tx: out std_logic);
end test_module;

architecture Behavioral of test_module is
	component debouncer is
	port(	clk: in std_logic;
			rst: in std_logic;
			btn: in std_logic;
			outlevel: out std_logic);
	end component;

	component edgedetect is
	port(	clk: in std_logic;
			rst: in std_logic;
			input: in std_logic;
			output: out std_logic);
	end component;

	component uart is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			rd: in std_logic;
			rx_empty: out std_logic;
			rx_full: out std_logic;
			tx_full: out std_logic;
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0);
			tx: out std_logic;
			rx: in std_logic);
	end component;

	
	signal btn1_db, btn1_ed: std_logic;
	signal data: std_logic_vector(7 downto 0);
begin

	comp0: debouncer port map(clk, rst, btn1, btn1_db);
	comp1: edgedetect port map(clk, rst, btn1_db, btn1_ed);

	comp2: uart port map(clk, rst, btn1_ed, btn1_ed, e, i, f, data, data, tx, rx);


end Behavioral;

