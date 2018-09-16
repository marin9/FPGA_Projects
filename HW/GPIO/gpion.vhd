library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity gpion is
generic(	N: positive := 8);
port(	clk: in std_logic;
		rst: in std_logic;
		wr_mode: in std_logic_vector(N-1 downto 0);
		wr_din: in std_logic_vector(N-1 downto 0);
		input: in std_logic_vector(N-1 downto 0);
		output: out std_logic_vector(N-1 downto 0);
		pin: inout std_logic_vector(N-1 downto 0));
end gpion;

architecture Behavioral of gpion is
	component gpio is
	port(	clk: in std_logic;
			rst: in std_logic;
			wr_mode: in std_logic;
			wr_din: in std_logic;			
			input: in std_logic;
			output: out std_logic;
			gpio: inout std_logic);
	end component;

begin

	gen_gpio: for i in 0 to (N-1) generate
		gpio_n: gpio port map(clk, rst, wr_mode(i), wr_din(i), input(i), output(i), pin(i));
   end generate gen_gpio;

end Behavioral;

