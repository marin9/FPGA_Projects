library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- clk = clk / s^DV
entity delay is
generic(DV: integer := 5);
port( clk: in std_logic;
		rst: in std_logic;
		ck_out: out std_logic);
end delay;

architecture Behavioral of delay is
	signal count: std_logic_vector(DV downto 0);
begin

	process(clk, rst) is
	begin
		if(rst='1') then
			count <= (others => '0');
		elsif(rising_edge(clk)) then
			count <= count + 1;
		end if;
	end process;
	
	ck_out <= count(DV);

end Behavioral;