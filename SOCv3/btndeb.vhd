library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity btndeb is
port(	clk: in std_logic;
		rst: in std_logic;
		btn_i: in std_logic;
		btn_o: out std_logic);
end btndeb;

architecture Behavioral of btndeb is
	type state is(ZERO, WAITT, ONE);
	signal current_state, next_state: state;
	signal counter, next_counter: std_logic_vector(19 downto 0);
	signal level, next_level: std_logic;
	signal outlevel: std_logic;
	
	signal q: std_logic;
begin
	--debouncer
	process(current_state, counter, level, btn_i) is
	begin
		next_level <= level;
		next_counter <= counter;
		next_state <= current_state;
		
		case current_state is
		when ZERO =>
			next_level <= '0';
			if(btn_i='1') then
				next_counter <= (others => '0');
				next_state <= WAITT;
			end if;
		when WAITT =>
			next_level <= '0';
			if(btn_i='0') then
				next_state <= ZERO;
			else
				if(counter=x"F4240") then
					next_state <= ONE;
				else
					next_counter <= counter + 1;
				end if;
			end if;
		when ONE =>
			next_level <= '1';
			if(btn_i='0') then
				next_state <= ZERO;
			end if;
		when others =>
			null;
		end case;
	end process;


	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				level <= '0';
				current_state <= ZERO;
				counter <= (others => '0');
			else
				level <= next_level;
				current_state <= next_state;
				counter <= next_counter;
			end if;
		end if;
	end process;
	outlevel <= level;
	
	--edgedetect
	btn_o <= outlevel and (not q);
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				q <= '0';
			else 
				q <= outlevel;
			end if;
		end if;
	end process;

end Behavioral;

