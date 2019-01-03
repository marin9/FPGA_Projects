library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity top_module is
port(	clk: in std_logic;
		rst: in std_logic;
		data: out std_logic_vector(15 downto 0));
end top_module;

architecture Behavioral of top_module is
	component cpu10r is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			addr: out std_logic_vector(15 downto 0);
			dout: out std_logic_vector(15 downto 0);
			din: in std_logic_vector(15 downto 0));
	end component;

	component ram is
	generic(ADDRLEN: positive := 15; DATALEN: positive := 16);
	port(	clk: in std_logic;
			wr:in std_logic;
			addr: in std_logic_vector(ADDRLEN-1 downto 0);
			din: in std_logic_vector(DATALEN-1 downto 0);
			dout: out std_logic_vector(DATALEN-1 downto 0));
	end component;

	signal clk2: std_logic := '0';
	signal wr: std_logic;
	signal addr, dout, din: std_logic_vector(15 downto 0);

begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			clk2 <= not clk2;
		end if;
	end process;

	Processor: cpu10r port map(clk2, rst, wr, addr, dout, din);
	Memory: ram port map(clk, wr, addr(14 downto 0), dout, din);
	
	data <= dout;

end Behavioral;

