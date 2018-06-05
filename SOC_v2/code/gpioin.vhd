library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity gpioin is
port( clk: in std_logic;
		rst: in std_logic;
		data: out std_logic_vector(7 downto 0);
		pinout: in std_logic_vector(7 downto 0));
end gpioin;

architecture Behavioral of gpioin is
begin
	
	process(clk, rst) is
	begin
		if(rst='1') then
			data <= (others => '0');
		elsif(rising_edge(clk)) then
			data <= pinout;
		end if;
	end process;

end Behavioral;

