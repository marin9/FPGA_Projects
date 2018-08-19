library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity uart is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic;
		rd: in std_logic;
		rx_empty: out std_logic;
		rx_full: out std_logic;
		tx_full: out std_logic;
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0);
		tx: out std_logic;
		rx: in std_logic);
end uart;

architecture Behavioral of uart is
	component tick_gen is
	port( clk: in std_logic;
			rst: in std_logic;
			tick: out std_logic);
	end component;

	component uart_rx is
	port(	clk: in std_logic;
			rst: in std_logic;
			tick: in std_logic;
			rx_done: out std_logic;
			rx_data: out std_logic_vector(7 downto 0);
			rx: in std_logic);
	end component;
	
	component uart_tx is
	port(	clk: in std_logic;
			rst: in std_logic;
			tick: in std_logic;
			tx_done: out std_logic;
			tx_start: in std_logic;
			tx_data: in std_logic_vector(7 downto 0);
			tx: out std_logic);
	end component;
	
	component fifo is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			rd: in std_logic;
			full: out std_logic;
			empty: out std_logic;
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;


	signal tick: std_logic;
	signal rx_done: std_logic;
	signal rx_data: std_logic_vector(7 downto 0);	
	signal tx_done: std_logic;
	signal tx_start: std_logic;
	signal tx_empty: std_logic;
	signal tx_data: std_logic_vector(7 downto 0);	
begin

	tck_gen: tick_gen port map(clk, rst, tick);
	
	recv: uart_rx port map(clk, rst, tick, rx_done, rx_data, rx);
	rx_fifo: fifo port map(clk, rst, rx_done, rd, rx_full, rx_empty, rx_data, output);
	
	tran: uart_tx port map(clk, rst, tick, tx_done, tx_start, tx_data, tx);
	tx_fifo: fifo port map(clk, rst, wr, tx_done, tx_full, tx_empty, input, tx_data);
	
	tx_start <= not tx_empty;

end Behavioral;

