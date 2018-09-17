library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_module is
port(	clk: in std_logic;
		rst: in std_logic;
		value: in std_logic_vector(7 downto 0);
		led: out std_logic);
end test_module;

architecture Behavioral of test_module is
	component timer is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;
	
	signal wr: std_logic;
	signal led_ff: std_logic;
	signal output: std_logic_vector(7 downto 0);
begin
	
	led <= led_ff;
	
	tm: timer port map(clk, rst, wr, value, output);
	
	with output select wr <=
	'1' when "00000000",
	'0' when others;
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				led_ff <= '0';
			elsif(output="00000000") then
				led_ff <= not led_ff;
			end if;
		end if;
	end process;
	
end Behavioral;

