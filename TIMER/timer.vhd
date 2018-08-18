library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity timer is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic;
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0));
end timer;

architecture Behavioral of timer is
	signal counter10ms, next_counter10ms: std_logic_vector(7 downto 0);
	signal counterTick, next_counterTick: std_logic_vector(18 downto 0);
begin

	output <= counter10ms;
	
	process(counterTick, counter10ms, input, wr) is
	begin
		if(wr='1') then
			next_counter10ms <= input;
			next_counterTick <= (others => '0');
		else
			next_counter10ms <= counter10ms;			
			if(counterTick=x"7A120") then
				next_counterTick <= (others => '0');			
				if(counter10ms="00000000") then
					next_counter10ms <= counter10ms;
				else
					next_counter10ms <= counter10ms - 1;
				end if;
			else
				next_counterTick <= counterTick + 1;
			end if;
		end if;	
	end process;
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				counter10ms <= (others => '0');
				counterTick <= (others => '0');
			else
				counter10ms <= next_counter10ms;
				counterTick <= next_counterTick;
			end if;
		end if;	
	end process;
	
end Behavioral;

