library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
port(	clk: in std_logic;
		rst: in std_logic;
		pause: in std_logic;
		aout: out std_logic;
		ss: out std_logic;
		sc: out std_logic;
		so: out std_logic;
		si: in std_logic);
end top_module;

architecture Behavioral of top_module is
	component control is
	port(	clk: in std_logic;
			rst: in std_logic;
			en_spi: out std_logic;
			wr_spi: out std_logic;
			rd_spi: out std_logic;
			bsy_spi: in std_logic;
			f_fifo: in std_logic;
			wr_fifo: out std_logic;
			output: out std_logic_vector(7 downto 0));
	end component;

	component spi is
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
	end component;
	
	component audio is
	port(	clk: in std_logic;
			rst: in std_logic;
			pause: in std_logic;
			wr: in std_logic;
			full: out std_logic;
			empty: out std_logic;
			input: in std_logic_vector(7 downto 0);
			output: out std_logic);
	end component;

	component toggle is
	port(	clk: in std_logic;
			rst: in std_logic;
			input: in std_logic;
			output: out std_logic);
	end component;

	signal clk2, pause2, en, wr, rd, bsy, full, wrm: std_logic;
	signal bus1, bus2: std_logic_vector(7 downto 0);
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			clk2 <= not clk2;
		end if;
	end process;
	
	s_spi: spi port map(clk2, rst, en, wr, rd, bsy, bus1, bus2, ss, sc, so, si);			
	s_con: control port map(clk2, rst, en, wr, rd, bsy, full, wrm, bus1);
	s_aud: audio port map(clk2, rst, pause2, wrm, full, open, bus2, aout);
	s_tog: toggle port map(clk2, rst, pause, pause2);
	
end Behavioral;
