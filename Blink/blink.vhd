library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity blink is
port(	clk: in std_logic;
		rst: in std_logic;
		led: out std_logic);
end blink;

architecture Behavioral of blink is
	type state is(H, L);
	signal c_state, n_state: state;
	signal counter, n_counter: std_logic_vector(25 downto 0);
begin

	process(c_state, counter) is
	begin
		n_counter <= counter + 1;
		n_state <= c_state;
		
		case c_state is
		when L =>
			led <= '0';
			if(conv_integer(counter)=50000000) then
				n_counter <= (others => '0');
				n_state <= H;
			end if;
		when H =>
			led <= '1';
			if(conv_integer(counter)=50000000) then
				n_counter <= (others => '0');
				n_state <= L;
			end if;
		when others => null;
		end case;
	end process;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= L;
				counter <= (others => '0');
			else
				c_state <= n_state;
				counter <= n_counter;
			end if;
		end if;
	end process;

end Behavioral;

