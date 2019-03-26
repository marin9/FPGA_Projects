library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm is
generic(width: positive := 8);
port(	clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic;
		input: in std_logic_vector(width-1 downto 0);
		output: out std_logic);
end pwm;

architecture Behavioral of pwm is
	signal reg, cnt: std_logic_vector(width-1 downto 0);
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				output <= '0';
				reg <= (others => '0');
				cnt <= (others => '0');
			elsif(wr='1') then
				reg <= input;
			else
				cnt <= cnt + 1;
				if(cnt >= reg) then
					output <= '0';
				else
					output <= '1';
				end if;	
			end if;
		end if;
	end process;

end Behavioral;
