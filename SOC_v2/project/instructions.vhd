library IEEE;
use IEEE.STD_LOGIC_1164.all;

package instructions is
	constant NOP	: std_logic_vector(4 downto 0) := "00000";
	constant RET	: std_logic_vector(4 downto 0) := "00001";
	constant RETK	: std_logic_vector(4 downto 0) := "00010";
	constant STA	: std_logic_vector(4 downto 0) := "00011";
	constant TST_NZ: std_logic_vector(4 downto 0) := "00100";
	constant TST_Z	: std_logic_vector(4 downto 0) := "00101";
	constant TST_NC: std_logic_vector(4 downto 0) := "00110";
	constant TST_C	: std_logic_vector(4 downto 0) := "00111";
	
	constant ADDK: std_logic_vector(4 downto 0) := "01000";
	constant SUBK: std_logic_vector(4 downto 0) := "01001";
	constant ANDK: std_logic_vector(4 downto 0) := "01010";
	constant ORRK: std_logic_vector(4 downto 0) := "01011";
	constant XORK: std_logic_vector(4 downto 0) := "01100";
	constant CMPK: std_logic_vector(4 downto 0) := "01101";
	constant LDAK: std_logic_vector(4 downto 0) := "01110";
	
	constant ADDA: std_logic_vector(4 downto 0) := "10000";
	constant SUBA: std_logic_vector(4 downto 0) := "10001";
	constant ANDA: std_logic_vector(4 downto 0) := "10010";
	constant ORRA: std_logic_vector(4 downto 0) := "10011";
	constant XORA: std_logic_vector(4 downto 0) := "10100";
	constant CMPA: std_logic_vector(4 downto 0) := "10101";
	constant LDAA: std_logic_vector(4 downto 0) := "10110";
	
	constant JMP : std_logic_vector(2 downto 0) := "110";
	constant CAL : std_logic_vector(2 downto 0) := "111";
end instructions;

package body instructions is
end instructions;
