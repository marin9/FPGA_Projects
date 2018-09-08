library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity uart_tx is
port(	clk: in std_logic;
		rst: in std_logic;
		tick: in std_logic;
		tx_done: out std_logic;
		tx_start: in std_logic;
		tx_data: in std_logic_vector(7 downto 0);
		tx: out std_logic);
end uart_tx;

architecture Behavioral of uart_tx is
	type state is(IDLE, START, DATA, STOP);
	signal reg_state, next_state: state;
	signal reg_bit, next_bit: std_logic_vector(2 downto 0);
	signal reg_tick, next_tick: std_logic_vector(3 downto 0);
begin

	process(tick, reg_state, reg_bit, reg_tick, tx_start, tx_data) is
	begin
		tx <= '1';
		tx_done <= '0';
		next_bit <= reg_bit;
		next_tick <= reg_tick;
		next_state <= reg_state;
		
		case reg_state is
		when IDLE =>
			if(tx_start='1') then
				next_tick <= (others => '0');
				next_state <= START;
			end if;
		when START =>
			tx <= '0';
			if(tick='1') then
				if(reg_tick="1111") then
					next_tick <= (others => '0');
					next_bit <= (others => '0');
					next_state <= DATA;
				else
					next_tick <= reg_tick + 1;
				end if;
			end if;
		when DATA =>
			tx <= tx_data(conv_integer(reg_bit));
			if(tick='1') then
				if(reg_tick="1111") then
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
			tx <= '1';
			if(tick='1') then
				if(reg_tick="1111") then
					tx_done <= '1';
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
			else
				reg_state <= next_state;
				reg_bit <= next_bit;
				reg_tick <= next_tick;
			end if;
		end if;
	end process;

end Behavioral;
