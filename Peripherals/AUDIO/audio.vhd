library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 8 kHz, 8-bit player

entity audio is
port( clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic;
		data: in std_logic_vector(7 downto 0);
		full: out std_logic;
		aout: out std_logic);
end audio;

architecture Behavioral of audio is
	component ed is
	port(	clk: in std_logic;
			rst: in std_logic;
			x: in std_logic;
			y: out std_logic);
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

	component timer is
	port(	clk: in std_logic;
			rst: in std_logic;
			tick: out std_logic);
	end component;

	component pwm is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			data: in std_logic_vector(7 downto 0);
			pwmout: out std_logic);
	end component;

	signal ck, s_wr, s_rw: std_logic := '0';
	signal s_data: std_logic_vector(7 downto 0);
begin
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			ck <= not ck;
		end if;
	end process;

	edge_detect: ed port map(ck, rst, wr, s_wr);
	fifo_queue: fifo port map(ck, rst, s_wr, s_rw, full, open, data, s_data);
	timer8kHz: timer port map(ck, rst, s_rw);
	pwm_generator: pwm port map(ck, rst, s_rw, s_data, aout);

end Behavioral;

