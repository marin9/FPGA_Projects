library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control is
port(	clk: in std_logic;
		rst: in std_logic;
		en_spi: out std_logic;
		wr_spi: out std_logic;
		rd_spi: out std_logic;
		bsy_spi: in std_logic;
		f_fifo: in std_logic;
		wr_fifo: out std_logic;
		output: out std_logic_vector(7 downto 0));
end control;

architecture Behavioral of control is
	type state is(START, EN, W1, CMD_RD, W2, ADR2, W3, ADR1, W4, ADR0, W5, SPI_READ, W6, FF, FIFO_WR);
	signal c_state, n_state: state;
begin

	process(c_state, bsy_spi, f_fifo) is
	begin
		n_state <= c_state;
		en_spi <= '0';
		wr_spi <= '0';
		rd_spi <= '0';
		wr_fifo <= '0';
		output <= (others => '0');
		
		case c_state is
		when START =>
			n_state <= EN;
		when EN =>
			en_spi <= '1';
			n_state <= W1;
		when W1 =>
			en_spi <= '1';
			if(bsy_spi='0') then
				n_state <= CMD_RD;
			end if;
		when CMD_RD =>
			en_spi <= '1';
			wr_spi <= '1';
			output <= x"03";
			n_state <= W2;
		when W2 =>
			en_spi <= '1';
			if(bsy_spi='0') then
				n_state <= ADR2;
			end if;
		when ADR2 =>
			en_spi <= '1';
			wr_spi <= '1';
			output <= x"0A";
			n_state <= W3;
		when W3 =>
			en_spi <= '1';
			if(bsy_spi='0') then
				n_state <= ADR1;
			end if;
		when ADR1 =>
			en_spi <= '1';
			wr_spi <= '1';
			output <= x"00";
			n_state <= W4;
		when W4 =>
			en_spi <= '1';
			if(bsy_spi='0') then
				n_state <= ADR0;
			end if;
		when ADR0 =>
			en_spi <= '1';
			wr_spi <= '1';
			output <= x"00";
			n_state <= W5;
		when W5 =>
			en_spi <= '1';
			if(bsy_spi='0') then
				n_state <= SPI_READ;
			end if;
		when SPI_READ =>
			en_spi <= '1';
			rd_spi <= '1';
			n_state <= W6;
		when W6 =>
			en_spi <= '1';
			if(bsy_spi='0') then
				n_state <= FF;
			end if;
		when FF =>
			en_spi <= '1';
			if(f_fifo='0') then
				n_state <= FIFO_WR;
			end if;
		when FIFO_WR =>
			en_spi <= '1';
			wr_fifo <= '1';
			n_state <= SPI_READ;
			output <= (others => '1');
		when others => null;
		end case;
	end process;


	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= START;
			else
				c_state <= n_state;
			end if;
		end if;
	end process;
	
end Behavioral;

