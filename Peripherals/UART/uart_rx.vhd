library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity uart_rx is
port(	clk: in std_logic;
		rst: in std_logic;
		tick: in std_logic;
		rx_done: out std_logic;
		rx_data: out std_logic_vector(7 downto 0);
		rx: in std_logic);
end uart_rx;

architecture Behavioral of uart_rx is
	type state is(IDLE, START, DATA, STOP);
	signal reg_state, next_state: state;
	signal reg_bit, next_bit: std_logic_vector(2 downto 0);
	signal reg_tick, next_tick: std_logic_vector(3 downto 0);
	signal reg_data, next_data: std_logic_vector(7 downto 0);
begin

	process(tick, reg_state, reg_bit, reg_tick, reg_data, rx) is
	begin
		rx_done <= '0';
		next_bit <= reg_bit;
		next_tick <= reg_tick;
		next_data <= reg_data;
		next_state <= reg_state;
		
		case reg_state is
		when IDLE =>
			if(rx='0') then
				next_tick <= (others => '0');
				next_state <= START;
			end if;
		when START =>
			if(tick='1') then
				if(reg_tick="0111") then
					next_tick <= (others => '0');
					next_bit <= (others => '0');
					next_state <= DATA;
				else
					next_tick <= reg_tick + 1;
				end if;
			end if;
		when DATA =>
			if(tick='1') then
				if(reg_tick="1111") then
					next_data <= rx & reg_data(7 downto 1);
					next_tick <= (others => '0');
					if(reg_bit="111") then					
						next_state <= STOP;
					else
						next_bit <= reg_bit + 1;
					end if;
				else
					next_tick <= reg_tick + 1;
				end if;
			end if;
		when STOP =>
			if(tick='1') then
				if(reg_tick="1111") then
					if(rx='1') then
						rx_done <= '1';				
					end if;
					next_state <= IDLE;	
				else
					next_tick <= reg_tick + 1;
				end if;
			end if;
		when others =>
			null;
		end case;	
	end process;


	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg_state <= IDLE;
				reg_bit <= (others => '0');
				reg_tick <= (others => '0');
				reg_data <= (others => '0');
			else
				reg_state <= next_state;
				reg_bit <= next_bit;
				reg_tick <= next_tick;
				reg_data <= next_data;
			end if;
		end if;
	end process;
	
	rx_data <= reg_data;

end Behavioral;
