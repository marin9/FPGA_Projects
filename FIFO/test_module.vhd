library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_module is
port(	clk: in std_logic;
		rst: in std_logic;
		btn1: in std_logic;
		btn2: in std_logic;
		btn3: in std_logic;
		full: out std_logic;
		empty: out std_logic;
		input: in std_logic_vector(7 downto 0);
		leds: out std_logic_vector(7 downto 0));
end test_module;

architecture Behavioral of test_module is
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


	signal btn1_db, btn1_ed: std_logic;
	signal btn2_db, btn2_ed: std_logic;
	signal btn3_db, btn3_ed: std_logic;
	signal b1, b2: std_logic;
begin

	comp0: debouncer port map(clk, rst, btn1, btn1_db);
	comp1: debouncer port map(clk, rst, btn2, btn2_db);
	comp2: debouncer port map(clk, rst, btn3, btn3_db);
	comp3: edgedetect port map(clk, rst, btn1_db, btn1_ed);
	comp4: edgedetect port map(clk, rst, btn2_db, btn2_ed);
	comp5: edgedetect port map(clk, rst, btn3_db, btn3_ed);
	
	b1 <= btn1_ed or btn3_ed;
	b2 <= btn2_ed or btn3_ed;

	comp6: fifo port map(clk, rst, b1, b2, full, empty, input, leds);

end Behavioral;

