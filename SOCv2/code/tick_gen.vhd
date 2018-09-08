library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity tick_gen is
port( clk: in std_logic;
		rst: in std_logic;
		tick: out std_logic);
end tick_gen;

architecture Behavioral of tick_gen is
	signal counter: std_logic_vector(5 downto 0);
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				counter <= (others => '0');
				tick <= '0';
			elsif(counter="11011") then
				counter <= (others => '0');
				tick <= '1';
			else
				counter <= counter + 1;
				tick <= '0';
			end if;
		end if;
	end process;

end Behavioral;
