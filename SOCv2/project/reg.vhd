library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reg is
generic(W: integer := 8);
port( clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic;
		input: in std_logic_vector(W-1 downto 0);
		output: out std_logic_vector(W-1 downto 0));
end reg;

architecture Behavioral of reg is
begin

	process(clk, rst, wr) is
	begin
		if(rst='1') then
			output <= (others => '0');
		elsif(falling_edge(clk) and wr='1') then
			output <= input;
		end if;
	end process;

end Behavioral;

