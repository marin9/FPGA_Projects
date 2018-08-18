library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity gpioout is
generic(ADR: std_logic_vector(7 downto 0) := (others => '1'));
port( clk: in std_logic;
		rst: in std_logic;
		addr: in std_logic_vector(7 downto 0);
		data: in std_logic_vector(7 downto 0);
		pinout: out std_logic_vector(7 downto 0));
end gpioout;

architecture Behavioral of gpioout is
begin
	
	process(clk, rst, addr) is
	begin
		if(rst='1') then
			pinout <= (others => '0');
		elsif(rising_edge(clk) and addr=ADR) then
			pinout <= data;
		end if;
	end process;

end Behavioral;

