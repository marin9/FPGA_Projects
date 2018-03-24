library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pc is
generic(W: integer := 12);
port( clk: in std_logic;
		rst: in std_logic;
		load: in std_logic;
		input: in std_logic_vector(W-1 downto 0);
		output: out std_logic_vector(W-1 downto 0));
end pc;

architecture Behavioral of pc is
	signal pc_out: std_logic_vector(W-1 downto 0);
begin

	process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst='1') then
				pc_out <= (others => '0');
			elsif(load='1') then
				pc_out <= input;
			else
				pc_out <= pc_out + 1;
			end if;
		end if;
	end process;
	
	output <= pc_out;

end Behavioral;

