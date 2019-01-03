
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity soc is
port( clk: in std_logic;
		rst: in std_logic;
		ss: out std_logic;
		sck: out std_logic;
		si: out std_logic;
		so: in std_logic;
		input0: in std_logic_vector(7 downto 0);
		input1: in std_logic_vector(7 downto 0);
		output0: out std_logic_vector(7 downto 0);
		output1: out std_logic_vector(7 downto 0);

		o: out std_logic);
end soc;

architecture Behavioral of soc is
	component spiread is
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
	end component;
	
	component rom is
	generic(AW: integer := 10; DW: integer := 13);
	port(	clk: in std_logic;
			en: in std_logic;
			wr: in std_logic;
			addr_in: in std_logic_vector(AW-1 downto 0);
			addr_out: in std_logic_vector(AW-1 downto 0);
			input: in std_logic_vector(DW-1 downto 0);
			output: out std_logic_vector(DW-1 downto 0));
	end component;

	component cpu is
	port( clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			pc: out std_logic_vector(9 downto 0);
			instr: in std_logic_vector(12 downto 0);
			addr: out std_logic_vector(7 downto 0);
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;
	
	component ram is
	port( clk: in std_logic;
			wr: in std_logic;
			addr: in std_logic_vector(7 downto 0);
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;
	
	component gpioout is
	generic(ADR: std_logic_vector(7 downto 0) := (others => '1'));
	port( clk: in std_logic;
			rst: in std_logic;
			addr: in std_logic_vector(7 downto 0);
			data: in std_logic_vector(7 downto 0);
			pinout: out std_logic_vector(7 downto 0));
	end component;

	component gpioin is
	port( clk: in std_logic;
			rst: in std_logic;
			data: out std_logic_vector(7 downto 0);
			pinout: in std_logic_vector(7 downto 0));
	end component;


	signal rom_addr_in: std_logic_vector(9 downto 0);
	signal rom_data_in: std_logic_vector(15 downto 0);
	signal grst: std_logic;
	signal fin: std_logic;
	signal rom_wr: std_logic;
	signal rom_addr_out: std_logic_vector(9 downto 0);
	signal rom_data_out: std_logic_vector(12 downto 0);
	
	signal ram_wr: std_logic;
	signal ram_addr: std_logic_vector(7 downto 0);
	signal cpu_out: std_logic_vector(7 downto 0);
	signal cpu_in: std_logic_vector(7 downto 0);
	signal cpu_in_ram: std_logic_vector(7 downto 0);
	signal cpu_in_gpin0: std_logic_vector(7 downto 0);
	signal cpu_in_gpin1: std_logic_vector(7 downto 0);
begin

	grst <= not fin;
	bootloader: spiread port map(clk, rst, fin, sck, ss, si, so, rom_wr, rom_addr_in, rom_data_in);

	program_memory: rom port map(clk, '1', rom_wr, rom_addr_in, rom_addr_out, rom_data_in(12 downto 0), rom_data_out);
	
	processor: cpu port map(clk, grst, ram_wr, rom_addr_out, rom_data_out, ram_addr, cpu_in, cpu_out);

	data_memory: ram port map(clk, ram_wr, ram_addr, cpu_out, cpu_in_ram);

	
	gpio0_in: gpioin port map(clk, grst, cpu_in_gpin0, input0);
	
	gpio1_in: gpioin port map(clk, grst, cpu_in_gpin1, input1);
	
	gpio2_out: gpioout generic map("11111110") port map(clk, grst, ram_addr, cpu_out, output0);

	gpio3_out: gpioout generic map("11111111") port map(clk, grst, ram_addr, cpu_out, output1);
	
	with ram_addr select cpu_in <=
	cpu_in_gpin0 when "11111100",
	cpu_in_gpin1 when "11111101",
	cpu_in_ram   when others;
	
	o <= rom_data_in(15) and rom_data_in(14) and rom_data_in(13); 

end Behavioral;

