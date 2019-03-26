library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity spi is
port(	clk: in std_logic;
		rst: in std_logic;
		en: in std_logic;
		wr: in std_logic;
		rd: in std_logic;
		busy: out std_logic;
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0);
		ss: out std_logic;
		sc: out std_logic;
		so: out std_logic;
		si: in std_logic);
end spi;

architecture Behavioral of spi is
	type state is(IDLE, WAITING, READY, SEND, RECV);
	signal c_state, n_state: state;
	signal nbit, n_nbit: std_logic_vector(2 downto 0);
	signal counter, n_counter: std_logic_vector(5 downto 0);
	signal reg_in, n_reg_in: std_logic_vector(7 downto 0);
	signal reg_out, n_reg_out: std_logic_vector(7 downto 0);
begin

	process(clk, en, wr, rd, input, c_state, nbit, counter, reg_in, reg_out, si) is
	begin	
		output <= reg_out;
		n_state <= c_state;
		n_reg_in <= reg_in;
		n_reg_out <= reg_out;
		n_counter <= counter + 1;
		n_nbit <= nbit + 1;
		busy <= '0';
		ss <= '1';
		sc <= '0';
		so <= '0';
	
		case c_state is
		when IDLE =>
			n_counter <= (others => '0');
			if(en='1') then				
				n_state <= WAITING;
			end if;
		when WAITING =>
			ss <= '0';
			busy <= '1';
			if(conv_integer(counter)=50) then
				n_state <= READY;				
			end if;
		when READY =>
			ss <= '0';
			n_nbit <= (others => '0');	
			if(en='0') then
				n_state <= IDLE;
			elsif(wr='1') then
				n_reg_in <= input;							
				n_state <= SEND;
			elsif(rd='1') then
				n_reg_out <= (others => '0');	
				n_state <= RECV;		
			end if;
		when SEND =>
			ss <= '0';
			sc <= clk;
			busy <= '1';		
			so <= reg_in(7-conv_integer(nbit));
			if(conv_integer(nbit)=7) then
				n_state <= READY;
			end if;
		when RECV =>
			ss <= '0';
			sc <= clk;
			busy <= '1';		
			n_reg_out <= reg_out(6 downto 0) & si;
			if(conv_integer(nbit)=7) then
				n_state <= READY;
			end if;
		when others => null;
		end case;
	end process;


	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= IDLE;
				nbit <= (others => '0');
				reg_in <= (others => '0');
				reg_out <= (others => '0');
				counter <= (others => '0');			
			else
				c_state <= n_state;
				nbit <= n_nbit;		
				reg_in <= n_reg_in;
				reg_out <= n_reg_out;
				counter <= n_counter;		
			end if;
		end if;
	end process;

end Behavioral;

