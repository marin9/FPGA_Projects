library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ram is
port( clk: in std_logic;
		wr: in std_logic;
		addr: in std_logic_vector(7 downto 0);
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0));
end ram;

architecture Behavioral of ram is
	type memory is array(0 to 255) of std_logic_vector(7 downto 0);
	signal mem: memory;
begin

	process(clk, wr) is
	begin
		if(falling_edge(clk) and wr='1') then
			mem(conv_integer(addr)) <= input;
		end if;
	end process;
	
	output <= mem(conv_integer(addr));

end Behavioral;
