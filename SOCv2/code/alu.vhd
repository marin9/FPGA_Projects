library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity alu is
port(	inl: in std_logic_vector(7 downto 0);
		inr: in std_logic_vector(7 downto 0);
		sel: in std_logic_vector(1 downto 0);
		res: out std_logic_vector(7 downto 0);
		carry: out std_logic);
end alu;

architecture Behavioral of alu is
	signal left, right, result: std_logic_vector(8 downto 0);
begin

	left <= '0' & inl;
	right <= '0' & inr;
	res <= result(7 downto 0);
	
	with sel select result <=
	left + right	when "00",
	left - right	when "01",
	left and right	when "10",
	left xor right	when others;
	
	carry <= result(8);

end Behavioral;