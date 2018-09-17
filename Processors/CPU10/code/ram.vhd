library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library std;
use std.textio.all;

entity ram is
port(	clk: in std_logic;
		wr:in std_logic;
		addr: in std_logic_vector(10 downto 0);
		din: in std_logic_vector(7 downto 0);
		dout: out std_logic_vector(7 downto 0));
end ram;

architecture Behavioral of ram is
	type memory is array(0 to 2047) of std_logic_vector(7 downto 0);
	
	impure function read_program(filename : string) return memory is
		file f: text open read_mode is filename;
		variable byte: bit_vector(7 downto 0);
		variable trace_line : line;
		variable rom: memory;
		variable i: integer;
	begin
		i := 0;
		while not endfile(f) loop
			readline(f, trace_line);
			read(trace_line, byte);
			rom(i) := to_stdlogicvector(byte);
			i := i + 1;
		end loop;
		return rom;
	end function;

	signal ram: memory := read_program("prog.txt");
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(wr='1') then
				ram(conv_integer(addr)) <= din;
			end if;
		end if;
	end process;
	dout <= ram(conv_integer(addr));

end Behavioral;