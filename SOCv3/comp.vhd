library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp is
port(	clk: in std_logic;
		grst: in std_logic;
		sel: in std_logic;
		b_cl: in std_logic;
		b_wr: in std_logic;
		b_pl: in std_logic;
		b_mn: in std_logic;
		b_0: in std_logic;
		b_1: in std_logic;
		btn_d: in std_logic_vector(1 downto 0);
		stop: out std_logic;
		rs: out std_logic;
		en: out std_logic;
		d4: out std_logic;
		d5: out std_logic;
		d6: out std_logic;
		d7: out std_logic);
end comp;

architecture Behavioral of comp is
	component cpu is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			stop: out std_logic;
			addr: out std_logic_vector(12 downto 0);
			din: in std_logic_vector(15 downto 0);
			dout: out std_logic_vector(15 downto 0));
	end component;

	component control is
	port(	sel: in std_logic;
			cpu_wr: in std_logic;
			cpu_addr: in std_logic_vector(12 downto 0);
			cpu_din: out std_logic_vector(15 downto 0);
			cpu_dout: in std_logic_vector(15 downto 0);
			ram_wr: out std_logic;
			ram_addr: out std_logic_vector(12 downto 0);
			ram_din: out std_logic_vector(15 downto 0);
			ram_dout: in std_logic_vector(15 downto 0);
			key_wr: in std_logic;
			key_addr: in std_logic_vector(12 downto 0);
			key_data: in std_logic_vector(15 downto 0));
	end component;
	
	component ram is
	generic(	ADDR_LEN: positive :=13;
				DATA_LEN: positive := 16);
	port(	clk: in std_logic;
			wr:in std_logic;
			addr: in std_logic_vector(ADDR_LEN-1 downto 0);
			din: in std_logic_vector(DATA_LEN-1 downto 0);
			dout: out std_logic_vector(DATA_LEN-1 downto 0));
	end component;
	
	component lcd is
	port(	clk: in std_logic;
			rst: in std_logic;
			addr: in std_logic_vector(12 downto 0);
			data: in std_logic_vector(15 downto 0);
			rs: out std_logic;
			en: out std_logic;
			d4: out std_logic;
			d5: out std_logic;
			d6: out std_logic;
			d7: out std_logic);
	end component;
	
	component keyboard is
	port(	clk: in std_logic;
			rst: in std_logic;
			btn_c: in std_logic;
			btn_w: in std_logic;
			btn_p: in std_logic;
			btn_m: in std_logic;
			btn_0: in std_logic;
			btn_1: in std_logic;
			btn_d: in std_logic_vector(1 downto 0);
			wr: out std_logic;
			addr: out std_logic_vector(12 downto 0);
			dout: out std_logic_vector(15 downto 0));
	end component;
	
	component btndeb is
	port(	clk: in std_logic;
			rst: in std_logic;
			btn_i: in std_logic;
			btn_o: out std_logic);
	end component;
	
	signal btn_c, btn_w, btn_p, btn_m, btn_0, btn_1: std_logic;

	signal c_wr, r_wr, k_wr: std_logic;
	signal c_adr, r_adr, k_adr: std_logic_vector(12 downto 0);
	signal c_din, c_dout, r_din, r_dout, k_dat: std_logic_vector(15 downto 0);
	
	signal clk2, rst: std_logic;
begin
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			clk2 <= not clk2;
		end if;
	end process;
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			rst <= grst;
		end if;
	end process;

	b1: btndeb port map(clk, rst, b_cl, btn_c);
	b2: btndeb port map(clk, rst, b_wr, btn_w);
	b3: btndeb port map(clk, rst, b_pl, btn_p);
	b4: btndeb port map(clk, rst, b_mn, btn_m);
	b5: btndeb port map(clk, rst, b_0, btn_0);
	b6: btndeb port map(clk, rst, b_1, btn_1);

	kb: keyboard port map(clk, '0', btn_c, btn_w, btn_p, btn_m, btn_0, btn_1, btn_d,
								k_wr, k_adr, k_dat);

	processor: cpu port map(clk2, rst, c_wr, stop, c_adr, c_din, c_dout);

	con: control port map(sel, c_wr, c_adr, c_din, c_dout,
								r_wr, r_adr, r_din, r_dout,
								k_wr, k_adr, k_dat);
								
	memory: ram port map(clk, r_wr, r_adr, r_din, r_dout);
	display: lcd port map(clk2, '0', r_adr, r_dout, rs, en, d4, d5, d6, d7);
	
end Behavioral;

