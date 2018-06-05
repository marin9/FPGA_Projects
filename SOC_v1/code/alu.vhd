library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity alu is
port( in1: in std_logic_vector(7 downto 0);
		in2: in std_logic_vector(7 downto 0);
		opr: in std_logic_vector(2 downto 0);
		output: out std_logic_vector(7 downto 0);
		flags: out std_logic_vector(1 downto 0));
end alu;

architecture Behavioral of alu is
	signal s_in1: std_logic_vector(8 downto 0);
	signal s_in2: std_logic_vector(8 downto 0);
	signal s_out: std_logic_vector(8 downto 0);
begin

	s_in1 <= "0" & in1;
	s_in2 <= "0" & in2;
	
	with opr select s_out <=
	s_in1 + s_in2   when "000", -- ADD
	s_in1 - s_in2   when "001", -- SUB
	s_in1 and s_in2 when "010", -- AND
	s_in1 or  s_in2 when "011", -- ORR
	s_in1 xor s_in2 when "100", -- XOR
	s_in2				 when others;
	
	output <= s_out(7 downto 0);
	
	-- Z flag
	with s_out(7 downto 0) select flags(0) <=
	'1' when "00000000",
	'0' when others;
	
	-- C flag
	flags(1) <= s_out(8); 

end Behavioral;

