library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shiftreg_si is
generic(W: integer := 24);
port( clk: in std_logic;
		rst: in std_logic;
		en: in std_logic;
		si: out std_logic);
end shiftreg_si;

architecture Behavioral of shiftreg_si is
	signal reg: std_logic_vector(W-1 downto 0);
begin

	process(clk, rst, en) is
	begin
		if(rst='1') then
			reg <= x"030000";
		elsif(falling_edge(clk) and en='1')then
			reg <= reg(W-2 downto 0) & reg(W-1);
		end if;
	end process;

	si <= reg(23);

end Behavioral;