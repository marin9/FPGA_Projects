library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top_module is
port(	clk: in std_logic;
			rst: in std_logic;
			addr: out std_logic_vector(15 downto 0);
			leds: out std_logic_vector(15 downto 0));
end top_module;

architecture Behavioral of top_module is
	component a9cpu is
	port(	clk: in std_logic;
				rst: in std_logic;
				wr: out std_logic;
				adr: out std_logic_vector(15 downto 0);
				din: in std_logic_vector(15 downto 0);
				dout: out std_logic_vector(15 downto 0));
	end component;

	component ram is
	generic(ADDRLEN: positive := 15; DATALEN: positive := 16);
	port(	clk: in std_logic;
			wr:in std_logic;
			addr: in std_logic_vector(ADDRLEN-1 downto 0);
			din: in std_logic_vector(DATALEN-1 downto 0);
			dout: out std_logic_vector(DATALEN-1 downto 0));
	end component;

	signal clk2, clk4, wr: std_logic;
	signal adr, din, dout: std_logic_vector(15 downto 0);
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			clk2 <= not clk2;
		end if;
	end process;
	
	process(clk2) is
	begin
		if(falling_edge(clk2)) then
			clk4 <= not clk4;
		end if;
	end process;

	processor: a9cpu port map(clk4, rst, wr, adr, din, dout);
	memory: ram port map(clk2, wr, adr(14 downto 0), dout, din);
	addr <= adr;
	
end Behavioral;

