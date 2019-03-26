library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_counter is
port( clk: in std_logic;
		rst: in std_logic;
		led1: out std_logic);
end test_counter;

architecture Behavioral of test_counter is
	component counter is
	generic(waitclk: natural:=1000; nbits: natural:=10);
	port(	clk: in std_logic;
			rst: in std_logic;
			tick: out std_logic);
	end component;
	
	signal tick, reg: std_logic;
begin

	c: counter generic map(25000000, 25) port map(clk, rst, tick);

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg <= '0';
			elsif(tick='1') then
				reg <= not reg;
			end if;
		end if;
	end process;
	
	led1 <= reg;

end Behavioral;

