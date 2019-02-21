library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram is
generic(	ADDR_LEN: positive :=13;
			DATA_LEN: positive := 16);
port(	clk: in std_logic;
		wr:in std_logic;
		addr: in std_logic_vector(ADDR_LEN-1 downto 0);
		din: in std_logic_vector(DATA_LEN-1 downto 0);
		dout: out std_logic_vector(DATA_LEN-1 downto 0));
end ram;

architecture Behavioral of ram is
	type memory is array(0 to (2**ADDR_LEN)-1) of std_logic_vector(DATA_LEN-1 downto 0);
	signal ram: memory;
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(wr='1') then
				ram(conv_integer(addr)) <= din;
			else
				dout <= ram(conv_integer(addr));
			end if;
		end if;
	end process;

end Behavioral;