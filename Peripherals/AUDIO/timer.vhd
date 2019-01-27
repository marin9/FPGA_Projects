library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity timer is
port(	clk: in std_logic;
		rst: in std_logic;
		tick: out std_logic);
end timer;

architecture Behavioral of timer is
	signal counter, n_counter: std_logic_vector(11 downto 0);
begin

	process(counter) is
	begin
		if(counter=x"C34") then
			tick <= '1';
			n_counter <= (others => '0');
		else
			tick <= '0';
			n_counter <= counter + 1;
		end if;
	end process;
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				counter <= (others => '0');
			else
				counter <= n_counter;
			end if;
		end if;	
	end process;
	
end Behavioral;