library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
generic(waitclk: natural := 1000; nbits: natural := 10);
port(	clk: in std_logic;
		rst: in std_logic;
		tick: out std_logic);
end counter;

architecture Behavioral of counter is
	signal reg: std_logic_vector(nbits-1 downto 0);
begin
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg <= (others => '0');
				tick <= '0';
			else		
				if(reg=std_logic_vector(to_unsigned(waitclk-1, nbits))) then
					reg <= (others => '0');
					tick <= '1';
				else
					reg <= reg + 1;
					tick <= '0';
				end if;
			end if;
		end if;
	end process;

end Behavioral;

