library IEEE;
use IEEE.STD_LOGIC_1164.all;

package instr is
	constant NOP:   std_logic_vector(3 downto 0) := "0000";
	constant JMP:   std_logic_vector(3 downto 0) := "0001";
	constant TST:   std_logic_vector(3 downto 0) := "0010";
	constant STA:   std_logic_vector(3 downto 0) := "0011";	
		
	constant LDA_K: std_logic_vector(3 downto 0) := "0100";
	constant ADD_K: std_logic_vector(3 downto 0) := "0101";
	constant SUB_K: std_logic_vector(3 downto 0) := "0110";
	constant AND_K: std_logic_vector(3 downto 0) := "0111";
	constant ORR_K: std_logic_vector(3 downto 0) := "1000";
	constant XOR_K: std_logic_vector(3 downto 0) := "1001";
	
	constant LDA_A: std_logic_vector(3 downto 0) := "1010";
	constant ADD_A: std_logic_vector(3 downto 0) := "1011";
	constant SUB_A: std_logic_vector(3 downto 0) := "1100";
	constant AND_A: std_logic_vector(3 downto 0) := "1101";
	constant ORR_A: std_logic_vector(3 downto 0) := "1110";
	constant XOR_A: std_logic_vector(3 downto 0) := "1111";

	constant NZ:	std_logic_vector(3 downto 0) := "0000";
	constant Z:	std_logic_vector(3 downto 0) := "0100";
	constant NC:	std_logic_vector(3 downto 0) := "1000";
	constant C:	std_logic_vector(3 downto 0) := "1100";	
end instr;

package body instr is
end instr;
