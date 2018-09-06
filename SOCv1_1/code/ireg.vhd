library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ireg is
port( clk: in std_logic;
		rst: in std_logic;
		input: in std_logic_vector(12 downto 0);
		output: out std_logic_vector(12 downto 0));
end ireg;

architecture Behavioral of ireg is
begin
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				output <= (others => '0');
			else
				output <= input;
			end if;
		end if;
	end process;

end Behavioral;

