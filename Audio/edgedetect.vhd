library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edgedetect is
port(	clk: in std_logic;
		rst: in std_logic;
		x: in std_logic;
		y: out std_logic);
end edgedetect;

architecture Behavioral of edgedetect is
	type state is(S1, S2, S3);
	signal c_state, n_state: state;
begin

	process(c_state, x) is
	begin
		case c_state is
		when S1 =>
			y <= '0';
			if(x='1') then
				n_state <= S2;
			else
				n_state <= S1;
			end if;
		when S2 =>
			y <= '1';
			n_state <= S3;
		when S3 =>
			y <= '0';
			if(x='0') then
				n_state <= S1;
			else
				n_state <= S3;
			end if;
		when others =>
			null;
		end case;
	end process;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= S1;
			else
				c_state <= n_state;
			end if;
		end if;
	end process;
	
end Behavioral;