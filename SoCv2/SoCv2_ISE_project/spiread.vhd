library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity spiread is
generic(AW: integer := 10; DW: integer := 16);
port( clk: in std_logic;
		rst: in std_logic;
		fin: out std_logic;
		
		sck: out std_logic;
		ss: out std_logic;
		si: out std_logic;
		so: in std_logic;
		
		wr: out std_logic;
		address: out std_logic_vector(AW-1 downto 0);
		data: out std_logic_vector(DW-1 downto 0));
end spiread;

architecture Behavioral of spiread is
	component spicontrol is
	port( clk: in std_logic;
			rst: in std_logic;
					
			t0: in std_logic;
			t1: in std_logic;
			t0r: out std_logic;
			t1r: out std_logic;		
			ok: in std_logic;
			
			en_sck: out std_logic;
			en_ss: out std_logic;
			en_si: out std_logic;
			en_so: out std_logic;
			
			wr: out std_logic;
			fin: out std_logic);
	end component;

	component counter is
	generic(W: integer := 8; INIT: integer := 0);
	port( clk: in std_logic;
			rst: in std_logic;
			en: in std_logic;
			output: out std_logic_vector(W-1 downto 0));
	end component;
	
	component shiftreg_so is
	generic(W: integer := 16);
	port( clk: in std_logic;
			rst: in std_logic;
			en: in std_logic;
			so: in std_logic;
			output: out std_logic_vector(15 downto 0));
	end component;
	
	component shiftreg_si is
	generic(W: integer := 24);
	port( clk: in std_logic;
			rst: in std_logic;
			en: in std_logic;
			si: out std_logic);
	end component;
	
	component delay is
	generic(DV: integer := 5);
	port( clk: in std_logic;
			rst: in std_logic;
			ck_out: out std_logic);
	end component;


	signal clkd: std_logic;
	signal en_sck: std_logic;
	signal en_si: std_logic;
	signal en_so: std_logic;

	signal t0: std_logic;
	signal t1: std_logic;
	signal t0r: std_logic;
	signal t1r: std_logic;
	signal ok: std_logic;
	signal ade: std_logic;
	
	signal count0: std_logic_vector(4 downto 0);
	signal count1: std_logic_vector(4 downto 0);
	signal addr: std_logic_vector(AW-1 downto 0);
	
	--attribute keep : string;  
	--attribute keep of count0: signal is "true";  
	--attribute keep of count1: signal is "true"; 
	
begin
			
	dl: delay port map(clk, rst, clkd);
	sck <= clkd and en_sck;
	
	shr_si: shiftreg_si generic map(24) port map(clkd, rst, en_si, si);
	shr_so: shiftreg_so generic map(16) port map(clkd, rst, en_so, so, data);
	
	con: spicontrol port map(clkd, rst, t0, t1, t0r, t1r, ok, en_sck, ss, en_si, en_so, wr, fin);
	
	cnt0: counter generic map(5, 0) port map(clkd, t0r, '1', count0);
	cnt1: counter generic map(5, 0) port map(clkd, t1r, '1', count1);
	
	with count0 select t0 <=
	'1' when "11000",
	'0' when others;
	
	with count1 select t1 <=
	'1' when "10000",
	'0' when others;
	
	with count1 select ade <=
	'1' when "00001",
	'0' when others;
	
	adrcnt: counter generic map(AW, 1023) port map(clkd, rst, ade, addr);
	address <= addr;
	
	with addr select ok <=
	'1' when "1111111111",
	'0' when others;
	
end Behavioral;