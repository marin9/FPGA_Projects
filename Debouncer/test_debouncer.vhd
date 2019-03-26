library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_debouncer is
port(	clk: in std_logic;
		rst: in std_logic;
		btn1: in std_logic;
		btn2: in std_logic;
		leds: out std_logic_vector(7 downto 0));
end test_debouncer;

architecture Behavioral of test_debouncer is
	component debouncer is
	port(	clk: in std_logic;
			rst: in std_logic;
			input: in std_logic;
			output: out std_logic);
	end component;
	
	signal b1, b2: std_logic;
	signal reg: std_logic_vector(7 downto 0);
begin

	db1: debouncer port map(clk, rst, btn1, b1);
	db2: debouncer port map(clk, rst, btn2, b2);

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg <= "00000001";
			elsif(b1='1') then
				reg <= reg(6 downto 0) & reg(7);
			elsif(b2='1') then
				reg <= reg(0) & reg(7 downto 1);
			end if;
		end if;
	end process;
	
	leds <= reg;
	
end Behavioral;

