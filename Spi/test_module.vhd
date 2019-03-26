library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_module is
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
end test_module;

architecture Behavioral of test_module is
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
	
	component debouncer is
	port(	clk: in std_logic;
			rst: in std_logic;
			input: in std_logic;
			output: out std_logic);
	end component;
	
	signal clk_cnt: std_logic_vector(5 downto 0);
	signal clk2, rst2: std_logic;
	signal btn_wr, btn_rd: std_logic;
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(clk_cnt="111111") then
				clk_cnt <= (others => '0');
				clk2 <= '1';
			else
				clk_cnt <= clk_cnt + 1;
				clk2 <= '0';
			end if;
		end if;
	end process;
	
	process(clk2) is
	begin
		if(falling_edge(clk2)) then
			rst2 <= rst;
		end if;
	end process;

	d0: debouncer port map(clk2, rst2, wr, btn_wr);
	d1: debouncer port map(clk2, rst2, rd, btn_rd);
	s: spi port map(clk2, rst2, en, btn_wr, btn_rd, busy, input, output, ss, sc, so, si);

end Behavioral;
