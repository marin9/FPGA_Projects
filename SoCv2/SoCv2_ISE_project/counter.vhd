library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity counter is
generic(W: integer := 8; INIT: integer := 0);
port( clk: in std_logic;
		rst: in std_logic;
		en: in std_logic;
		output: out std_logic_vector(W-1 downto 0));
end counter;

architecture Behavioral of counter is
	signal reg: std_logic_vector(W-1 downto 0);
begin

	process(clk, rst, en) is
	begin
		if(rst='1') then
			reg <= std_logic_vector(to_unsigned(INIT, W));
		elsif(rising_edge(clk) and en='1') then
			reg <= reg + 1;
		end if;
	end process;

	output <= reg;
	
end Behavioral;