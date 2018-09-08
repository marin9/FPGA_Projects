library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity selector is
port(	prog: in std_logic;
		rdy: out std_logic;
		ss: out std_logic;
		sck: out std_logic;
		si: out std_logic;
		so: in std_logic;
		ss0: in std_logic;
		sck0: in std_logic;
		si0: in std_logic;
		so0: out std_logic;
		ss1: in std_logic;
		sck1: in std_logic;
		si1: in std_logic;
		so1: out std_logic);
end selector;

architecture Behavioral of selector is
begin
	rdy <= not prog;

	with prog select ss <=
	ss0 when '1',
	ss1 when others;
	
	with prog select sck <=
	sck0 when '1',
	sck1 when others;

	with prog select si <=
	si0 when '1',
	si1 when others;

	so0 <= so;
	so1 <= so;

end Behavioral;
