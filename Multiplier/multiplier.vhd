library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier is
generic(WIDTH: positive := 4);
port(	clk: in std_logic;
		rst: in std_logic;
		wr1: in std_logic;
		wr2: in std_logic;
		rdy: out std_logic;
		input: in std_logic_vector(WIDTH-1 downto 0);
		outH: out std_logic_vector(WIDTH-1 downto 0);
		outL: out std_logic_vector(WIDTH-1 downto 0));
end multiplier;

architecture Behavioral of multiplier is
	type state is(INSERT, TEST, ADD, SHIFT, CHECK);
	signal c_state, n_state: state;
	signal n, n_n: std_logic_vector(WIDTH-1 downto 0);
	signal q, n_q: std_logic_vector(WIDTH-1 downto 0);
	signal b, n_b: std_logic_vector(WIDTH-1 downto 0);
	signal a, n_a: std_logic_vector(WIDTH downto 0);
begin

	outH <= a(WIDTH-1 downto 0);
	outL <= q;
	
	process(c_state, wr1, wr2, q, b, a, n, input) is
	begin
		rdy <= '0';
		n_state <= c_state;		
		n_a <= a;
		n_n <= n;
		n_b <= b;
		n_q <= q;

		case c_state is
		when INSERT =>
			rdy <= '1';
			if(wr1='1') then
				n_q <= input;
			end if;
			if(wr2='1') then
				n_b <= input;
				n_a <= (others => '0');
				n_n <= (others => '1');
				n_state <= TEST;
			end if;
		when TEST =>
			if(q(0)='1') then
				n_state <= ADD;
			else
				n_state <= SHIFT;
			end if;
		when ADD =>	
			n_a <= a + b;
			n_state <= SHIFT;
		when SHIFT =>
			n_a <=  "0" & a(WIDTH downto 1);
			n_q <= a(0) & q(WIDTH-1 downto 1);				
			n_n <=  "0" & n(WIDTH-1 downto 1);							
			n_state <= CHECK;		
		when CHECK =>
			if(conv_integer(n)=0) then
				n_state <= INSERT;
			else
				n_state <= TEST;
			end if;
		when others => null;
		end case;
	end process;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= n_state;
			else
				c_state <= n_state;
				a <= n_a;
				q <= n_q;
				b <= n_b;					
				n <= n_n;
			end if;
		end if;
	end process;

end Behavioral;
