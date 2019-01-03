library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity rom is
port(	clk: in std_logic;
		en: in std_logic;
		wr: in std_logic;
		addr_in: in std_logic_vector(11 downto 0);
		addr_out: in std_logic_vector(11 downto 0);
		input: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(15 downto 0));
end rom;

architecture Behavioral of rom is
	type memory is array(0 to 2**12-1) of std_logic_vector(15 downto 0);
	signal mem: memory;
begin

	process(clk, en) is
	begin
		if(falling_edge(clk) and en='1') then
			if(wr='1') then
				mem(conv_integer(addr_in)) <= input;
			else
				output <= mem(conv_integer(addr_out));
			end if;
		end if;
	end process;

end Behavioral;