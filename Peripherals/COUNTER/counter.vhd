library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity counter is
port(	clk: in std_logic;
		rst: in std_logic;
		stop: in std_logic;
		value: out std_logic_vector(10 downto 0));
end counter;

architecture Behavioral of counter is
	type state is(RUN, STOPPED);
	signal current_state, next_state: state;
	
	signal cnt, next_cnt: std_logic_vector(19 downto 0);
	signal mhz, next_mhz: std_logic_vector(10 downto 0);
begin

	process(current_state, cnt, mhz, stop) is
	begin
		next_cnt <= cnt;
		next_mhz <= mhz;
		next_state <= current_state;
		
		case current_state is
		when RUN =>
			if(stop='1') then
				next_state <= STOPPED;
			end if;
			
			if(cnt=x"F4240") then
				next_cnt <= (others => '0');
				next_mhz <= mhz + 1;
			else
				next_cnt <= cnt + 1;		
			end if;		
		when STOPPED =>
		when others =>
			null;
		end case;
	end process;
	

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				cnt <= (others => '0');
				mhz <= (others => '0');
				current_state <= RUN;
			else
				cnt <= next_cnt;
				mhz <= next_mhz;
				current_state <= next_state;
			end if;
		end if;
	end process;
	
	value <= mhz;

end Behavioral;

