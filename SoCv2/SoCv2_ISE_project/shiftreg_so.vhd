library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shiftreg_so is
generic(W: integer := 16);
port( clk: in std_logic;
		rst: in std_logic;
		en: in std_logic;
		so: in std_logic;
		output: out std_logic_vector(W-1 downto 0));
end shiftreg_so;

architecture Behavioral of shiftreg_so is
	signal reg: std_logic_vector(W-1 downto 0);
begin

	process(clk, rst, en) is
	begin
		if(rst='1') then
			reg <= (others => '0');
		elsif(rising_edge(clk) and en='1') then
			reg <= reg(W-2 downto 0) & so;
		end if;
	end process;
	
	output <= reg;

end Behavioral;