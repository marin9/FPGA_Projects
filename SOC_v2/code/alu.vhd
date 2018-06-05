library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity alu is
port( in1: in std_logic_vector(7 downto 0);
		in2: in std_logic_vector(7 downto 0);
		op: in std_logic_vector(2 downto 0);
		output: out std_logic_vector(7 downto 0);
		z: out std_logic;
		c: out std_logic);
end alu;

architecture Behavioral of alu is
	signal s_in1: std_logic_vector(8 downto 0);
	signal s_in2: std_logic_vector(8 downto 0);
	signal s_output: std_logic_vector(8 downto 0);
begin
	s_in1(8) <= '0';
	s_in1(7 downto 0) <= in1(7 downto 0);
	s_in2(8) <= '0';
	s_in2(7 downto 0) <= in2(7 downto 0);

	with op select s_output <=
	s_in1 + 		s_in2 when "000",
	s_in1 - 		s_in2 when "001",
	s_in1 and 	s_in2 when "010",
	s_in1 or 	s_in2 when "011",
	s_in1 xor 	s_in2 when "100",
	s_in2 when others;
		
	with s_output(7 downto 0) select z <=
	'1' when "00000000",
	'0' when others;
	
	c <= s_output(8);	
	output <= s_output(7 downto 0);
	
end Behavioral;
