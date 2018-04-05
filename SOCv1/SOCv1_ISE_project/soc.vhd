library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity soc is
port( clk: in std_logic;
		rst: in std_logic;
		sck: out std_logic;
		ss: out std_logic;
		si: out std_logic;
		so: in std_logic;
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0));
end soc;

architecture Behavioral of soc is
	component spi is
	port( clk: in std_logic;
		rst: in std_logic;
		ss: out std_logic;
		sck: out std_logic;
		si: out std_logic;
		so: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(11 downto 0);
		data: out std_logic_vector(15 downto 0);
		fin: out std_logic);
	end component;
	
	component rom is
	port(	clk: in std_logic;
			en: in std_logic;
			wr: in std_logic;
			addr_in: in std_logic_vector(11 downto 0);
			addr_out: in std_logic_vector(11 downto 0);
			input: in std_logic_vector(15 downto 0);
			output: out std_logic_vector(15 downto 0));
	end component;
	
	component cpu is
	port( clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			rom_addr: out std_logic_vector(11 downto 0);
			rom_data: in std_logic_vector(15 downto 0);
			address: out std_logic_vector(7 downto 0);
			data_in: in std_logic_vector(7 downto 0);
			data_out: out std_logic_vector(7 downto 0));
	end component;
	
	component ram is
	port( clk: in std_logic;
			wr: in std_logic;
			addr: in std_logic_vector(7 downto 0);
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(7 downto 0));
	end component;
	
	component gpio is
	generic(ADDR_OUT: integer := 255);
	port( clk: in std_logic;
			rst: in std_logic;
			en_wr: in std_logic;
			addr: in std_logic_vector(7 downto 0);
			data_in: in std_logic_vector(7 downto 0); 
			data_out: out std_logic_vector(7 downto 0);
			pins_in: in std_logic_vector(7 downto 0);
			pins_out: out std_logic_vector(7 downto 0));
	end component;
	
	
	signal s_rst: std_logic;
	
	signal rom_en: std_logic;
	signal rom_addr_in: std_logic_vector(11 downto 0);
	signal rom_addr_out: std_logic_vector(11 downto 0);
	signal rom_data_in: std_logic_vector(15 downto 0);
	signal rom_data_out: std_logic_vector(15 downto 0);
	
	signal wr: std_logic;
	signal ram_w: std_logic;
	signal addr_bus: std_logic_vector(7 downto 0);
	signal din_bus: std_logic_vector(7 downto 0);
	signal dout_bus: std_logic_vector(7 downto 0);
	signal ram_out: std_logic_vector(7 downto 0);
	signal gpio_out: std_logic_vector(7 downto 0);
	
	signal cnt: std_logic_vector(3 downto 0);
	signal en: std_logic;
begin

	process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst='1') then
				cnt <= (others => '0');
			else
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
	en <= not rst;

	bootloader: spi port map(cnt(3), rst, ss, sck, si, so, wr, rom_addr_in, rom_data_in, s_rst);

	program_memory: rom port map(cnt(3), en, wr, rom_addr_in, rom_addr_out, rom_data_in, rom_data_out);

	processor: cpu port map(cnt(3), s_rst, ram_w, rom_addr_out, rom_data_out, addr_bus, din_bus, dout_bus);
	
	with addr_bus select din_bus <=
	gpio_out when x"FE",
	ram_out  when others;
	
	data_memory: ram port map(cnt(3), ram_w, addr_bus, dout_bus, ram_out);
	
	gpio_port: gpio generic map(255) port map(cnt(3), rst, ram_w, addr_bus, dout_bus, gpio_out, input, output);
	
end Behavioral;

