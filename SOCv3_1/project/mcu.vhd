library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mcu is
port(	clk50: in std_logic;
		reset: in std_logic;
		p_in: in std_logic_vector(7 downto 0);
		p_out: out std_logic_vector(7 downto 0));
end mcu;

architecture Behavioral of mcu is
	component cpu is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			addr: out std_logic_vector(10 downto 0);
			din: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;

	component ram is
	port(	clk: in std_logic;
			wr:in std_logic;
			addr: in std_logic_vector(10 downto 0);
			din: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;

	component tmr is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;

	signal clk, clk1: std_logic := '0';
	signal rst, wr: std_logic;
	signal addr: std_logic_vector(10 downto 0);
	signal data_in, data_out: std_logic_vector(7 downto 0);
	signal ram_out: std_logic_vector(7 downto 0);
	signal tmr_wr: std_logic;
	signal tmr_out: std_logic_vector(7 downto 0);
begin

	clk_div: process(clk50) is
	begin
		if(falling_edge(clk50)) then
			clk <= clk1;
			clk1 <= not clk;
		end if;
	end process;

	reset_ff: process(clk) is
	begin
		if(falling_edge(clk)) then
			rst <= reset;
		end if;
	end process;

	processor: cpu port map(clk, rst, wr, addr, data_in, data_out);

	memory: ram port map(clk, wr, addr, data_out, ram_out);

	timer: tmr port map(clk, rst, tmr_wr, data_out, tmr_out);

	
	with addr select data_in <=
	p_in		when "111" & x"FE",
	tmr_out	when "111" & x"FF",
	ram_out	when others;
	
	with addr select tmr_wr <=
	'1' when "111" & x"FD",
	'0' when others;
	
	gpio: process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				p_out <= (others => '0');
			elsif(addr=("111" & x"FC")) then
				p_out <= data_out;
			end if;
		end if;
	end process;

end Behavioral;

