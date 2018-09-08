library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity soc is
port(	clk50: in std_logic;
		rst1: in std_logic;
		rst2: in std_logic;
		prog: in std_logic;
		ready: out std_logic;
		ss_p: in std_logic;
		sck_p: in std_logic;
		si_p: in std_logic;
		so_p: out std_logic;
		ss_r: out std_logic;
		sck_r: out std_logic;
		si_r: out std_logic;
		so_r: in std_logic;
		rx: in std_logic;
		tx: out std_logic;
		pwmpin: out std_logic;
		gpiop: inout std_logic_vector(7 downto 0));
end soc;

architecture Behavioral of soc is
	component selector is
	port(	prog: in std_logic;
			rdy: out std_logic;
			ss: out std_logic;
			sck: out std_logic;
			si: out std_logic;
			so: in std_logic;
			ss0: in std_logic;
			sck0: in std_logic;
			si0: in std_logic;
			so0: out std_logic;
			ss1: in std_logic;
			sck1: in std_logic;
			si1: in std_logic;
			so1: out std_logic);
	end component;
	
	component bootloader is
	port(
		clk: in std_logic;
		rst: in std_logic;
		sck: out std_logic;
		ss: out std_logic;
		si: out std_logic;
		so: in std_logic;
		en: out std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(12 downto 0);
		data: out std_logic_vector(7 downto 0);
		fin: out std_logic);
	end component;
	
	component ram is
	port(	clk: in std_logic;
			en: in std_logic;
			sel: in std_logic;
			wr0: in std_logic;
			addr0: in std_logic_vector(12 downto 0);
			din0: in std_logic_vector(7 downto 0);
			wr1: in std_logic;
			addr1: in std_logic_vector(12 downto 0);
			din1: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;
	
	component cpum8 is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			pid: out std_logic_vector(7 downto 0);
			pin: in std_logic_vector(7 downto 0);
			pout: out std_logic_vector(7 downto 0);
			addr: out std_logic_vector(12 downto 0);
			din: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;
	
	component uart is
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
	end component;
	
	component pwm is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			data: in std_logic_vector(7 downto 0);
			pwmout: out std_logic);
	end component;
	
	component timer is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;
	
	component gpion is
	generic(	N: positive := 8);
	port(	clk: in std_logic;
			rst: in std_logic;
			wr_mode: in std_logic;
			wr_din: in std_logic;
			input: in std_logic_vector(N-1 downto 0);
			output: out std_logic_vector(N-1 downto 0);
			pin: inout std_logic_vector(N-1 downto 0));
	end component;
	
	
	signal clk, ck1, ck2: std_logic;
	signal rst, fin: std_logic;
	signal ss, sck, si, so: std_logic;
	
	signal en0, wr0: std_logic;
	signal addr0: std_logic_vector(12 downto 0);
	signal din0, dout0: std_logic_vector(7 downto 0);

	signal wr: std_logic;
	signal addr: std_logic_vector(12 downto 0);
	signal din, dout: std_logic_vector(7 downto 0);
	signal pid, pin, pout: std_logic_vector(7 downto 0);
	
	signal u_wr, u_rd, rx_empty, tx_full: std_logic;
	signal u_out: std_logic_vector(7 downto 0);
	
	signal pwm_wr: std_logic;
	
	signal tm_wr: std_logic;
	signal tm_out: std_logic_vector(7 downto 0);
	
	signal gpm_wr, gpd_wr: std_logic;
	signal gp_out: std_logic_vector(7 downto 0);
begin
	process(clk50) is
	begin
		if(falling_edge(clk50)) then
			clk <= ck2;
			ck2 <= ck1;
			ck1 <= not clk;
		end if;
	end process;
	rst <= rst1 or rst2;

	comp1: selector port map(prog, ready,
										ss_r, sck_r, si_r, so_r,
										ss_p, sck_p, si_p, so_p,
										ss, sck, si, so);

	comp2: bootloader port map(clk, rst, sck, ss, si, so,
										en0, wr0, addr0, din0, fin);

	comp3: ram port map(clk, en0, fin, wr0, addr0, din0, wr, addr, dout, din);
	
	comp4: cpum8 port map(clk ,rst, wr, pid, pin, pout, addr, din, dout);
	
	comp5: uart port map(clk, rst, u_wr, u_rd, rx_empty, open, tx_full, pout, u_out, tx, rx);
	
	comp6: pwm port map(clk, rst, pwm_wr, dout, pwmpin);
	
	comp7: timer port map(clk, rst, tm_wr, dout, tm_out);
	
	comp8: gpion port map(clk, rst, gpm_wr, gpd_wr, dout, gp_out, gpiop);
	
			
	
	with pid select u_wr <=
	'1'	when "00000001",
	'0'	when others;
	
	with pid select u_rd <=
	'1'	when "00000010",
	'0'	when others;
	
	with pid select pwm_wr <=
	'1' when "00000101",
	'0' when others;
	
	with pid select tm_wr <=
	'1' when "00000110",
	'0' when others;
	
	with pid select gpm_wr <=
	'1' when "00001000",
	'0' when others;
	
	with pid select gpd_wr <=
	'1' when "00001001",
	'0' when others;
		
		
	with pid select pin <=
	u_out						when "00000010",
	"0000000" & rx_empty	when "00000011",
	"0000000" & tx_full	when "00000100",
	tm_out					when "00000111",
	gp_out					when "00001010",
	"00000000"				when others;
	
	
end Behavioral;
