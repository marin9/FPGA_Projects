library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_pwm is
port(	clk: in std_logic;
		rst: in std_logic;
		plus: in std_logic;
		minus: in std_logic;
		led: out std_logic);
end test_pwm;

architecture Behavioral of test_pwm is
	component pwm is
	generic(width: positive := 8);
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic);
	end component;
	
	component debouncer is
	port(	clk: in std_logic;
			rst: in std_logic;
			input: in std_logic;
			output: out std_logic);
	end component;
	
	signal wr, btn_plus, btn_minus: std_logic;
	signal reg: std_logic_vector(7 downto 0);
begin

	d0: debouncer port map(clk, rst, plus, btn_plus);
	d1: debouncer port map(clk, rst, minus, btn_minus);
	p: pwm port map(clk, rst, wr, reg, led);

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg <= (others => '0');
				wr <= '1';
			elsif(btn_plus='1') then
				reg <= reg + 11;
				wr <= '1';
			elsif(btn_minus='1') then
				reg <= reg - 11;
				wr <= '1';
			else
				wr <= '0';
			end if;
		end if;
	end process;

end Behavioral;

