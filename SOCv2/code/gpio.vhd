library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity gpio is
port(	clk: in std_logic;
		rst: in std_logic;
		wr_mode: in std_logic;
		wr_din: in std_logic;			
		input: in std_logic;
		output: out std_logic;
		gpio: inout std_logic);
end gpio;

architecture Behavioral of gpio is
	signal mode_ff: std_logic;
	signal din_ff: std_logic;
	signal dout_ff: std_logic;
begin

	gpio <= din_ff when (mode_ff='1') else 'Z';

	output <= dout_ff;

	-- mode flip flop
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				mode_ff <= '0';
			elsif(wr_mode='1') then
				mode_ff <= input;
			end if;
		end if;
	end process;
	
	-- input data flip flop
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				din_ff <= '0';
			elsif(wr_din='1') then
				din_ff <= input;
			end if;
		end if;
	end process;
	
	-- output data flip flop
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				dout_ff <= '0';
			else
				dout_ff <= gpio;
			end if;
		end if;
	end process;

end Behavioral;

