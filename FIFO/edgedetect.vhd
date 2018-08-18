library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity edgedetect is
port(	clk: in std_logic;
		rst: in std_logic;
		input: in std_logic;
		output: out std_logic);
end edgedetect;

architecture Behavioral of edgedetect is
	signal q: std_logic;
begin

	output <= input and (not q);

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				q <= '0';
			else 
				q <= input;
			end if;
		end if;
	end process;

end Behavioral;

