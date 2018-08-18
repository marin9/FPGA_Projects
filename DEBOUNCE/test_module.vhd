library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity test_module is
port( clk: in std_logic;
		rst: in std_logic;
		btn1: in std_logic;
		btn2: in std_logic;
		leds: out std_logic_vector(7 downto 0));
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


	signal btn1_db: std_logic;
	signal shift, shift_db: std_logic;
	signal data: std_logic_vector(7 downto 0);
begin

	comp0: debouncer port map(clk, rst, btn1, btn1_db);
	comp1: edgedetect port map(clk, rst, btn1_db, shift_db);
	
	shift <= btn2 or shift_db;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				data <= "00000001";
			elsif(shift='1') then
				data <= data(6 downto 0) & data(7);
			end if;
		end if;
	end process;
	
	leds <= data;

end Behavioral;

