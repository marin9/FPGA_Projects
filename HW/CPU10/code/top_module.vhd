library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
port(	clk50: in std_logic;
		reset: in std_logic;
		pinout: out std_logic_vector(7 downto 0));
end top_module;

architecture Behavioral of top_module is
	component cpu10 is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			addr: out std_logic_vector(10 downto 0);
			dout: out std_logic_vector(7 downto 0);
			din: in std_logic_vector(7 downto 0));
	end component;
	
	component ram is
	port(	clk: in std_logic;
			wr:in std_logic;
			addr: in std_logic_vector(10 downto 0);
			din: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;


	signal clk, clk1: std_logic := '0';
	signal rst, wr: std_logic;
	signal addr: std_logic_vector(10 downto 0);
	signal data_in, data_out: std_logic_vector(7 downto 0);	
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
	
	portout: process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				pinout <= (others => '0');
			elsif(addr="11111111111") then
				pinout <= data_out;
			end if;
		end if;
	end process;

	processor: cpu10 port map(clk, rst, wr, addr, data_in, data_out);
	memory: ram port map(clk, wr, addr, data_in, data_out);

end Behavioral;

