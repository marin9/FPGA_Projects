library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity clkdiv is
generic(N: positive := 26);
port(	clk: in std_logic;
		clkn: out std_logic);
end clkdiv;

architecture Behavioral of clkdiv is
	signal reg: std_logic_vector(N-1 downto 0) := (others => '0');
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			reg <= reg + 1;
		end if;
	end process;

	clkn <= reg(N-1);
end Behavioral;
