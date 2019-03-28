library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity divider is
generic(WIDTH: positive := 4);
port(	clk: in std_logic;
		rst: in std_logic;
		wr1: in std_logic;
		wr2: in std_logic;
		err: out std_logic;
		rdy: out std_logic;
		input: in std_logic_vector(WIDTH-1 downto 0);
		outQ: out std_logic_vector(WIDTH-1 downto 0);
		outR: out std_logic_vector(WIDTH-1 downto 0));
end divider;

architecture Behavioral of divider is
	type state is(INSERT, CHECK, COMP, NOSUB, SUB, TEST, SHIFT);
	signal c_state, n_state: state;
	signal a, n_a: std_logic_vector(2*WIDTH-2 downto 0);
	signal b, n_b: std_logic_vector(2*WIDTH-2 downto 0);
	signal r, n_r:	std_logic_vector(WIDTH-1 downto 0);
	signal c, n_c: std_logic_vector(WIDTH-2 downto 0);
	signal eflg, n_eflg: std_logic;
	signal rflg, n_rflg: std_logic;
begin

	err <= eflg;
	rdy <= rflg;
	outQ <= r;
	outR <= a(WIDTH-1 downto 0);

	process(c_state, a, b, r, c, eflg, rflg, wr1, wr2, input) is
	begin
		n_state <= c_state;
		n_a <= a;
		n_b <= b;
		n_c <= c;
		n_r <= r;
		n_eflg <= eflg;
		n_rflg <= rflg;
		
		case c_state is
		when INSERT =>		
			if(wr1='1') then
				n_a(2*WIDTH-2 downto 0) <= (others => '0');
				n_a(WIDTH-1 downto 0) <= input;
				n_eflg <= '0';
			end if;
			if(wr2='1') then
				n_b(2*WIDTH-2 downto 0) <= (others => '0');
				n_b(2*WIDTH-2 downto WIDTH-1) <= input;
				n_c <= (others => '1');
				n_eflg <= '0';
				n_rflg <= '0';
				n_state <= CHECK;
			end if;
		when CHECK =>
			if(conv_integer(b)=0) then
				n_eflg <= '1';
				n_rflg <= '1';
				n_state <= INSERT;
			else
				n_state <= COMP;
			end if;
		when COMP =>
			if(a<b) then
				n_state <= NOSUB;
			else
				n_state <= SUB;
			end if;
		when NOSUB =>
			n_r <= r(WIDTH-2 downto 0) & "0";
			n_state <= TEST;
		when SUB =>
			n_r <= r(WIDTH-2 downto 0) & "1";
			n_a <= a - b;
			n_state <= TEST;
		when TEST =>
			if(conv_integer(c)=0) then
				n_state <= INSERT;
				n_rflg <= '1';
			else
				n_state <= SHIFT;
			end if;
		when SHIFT =>
			n_b <= "0" & b(2*WIDTH-2 downto 1);
			n_c <= "0" & c(WIDTH-2 downto 1);
			n_state <= COMP;
		when others => null;
		end case;
	end process;
	

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= INSERT;
				eflg <= '0';
				rflg <= '1';			
			else
				a <= n_a;
				b <= n_b;
				c <= n_c;
				r <= n_r;
				c_state <= n_state;
				eflg <= n_eflg;
				rflg <= n_rflg;
			end if;
		end if;
	end process;

end Behavioral;
