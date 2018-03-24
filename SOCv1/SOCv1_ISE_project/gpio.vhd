library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity gpio is
generic(ADDR_OUT: integer := 255);
port( clk: in std_logic;
		rst: in std_logic;
		en_wr: in std_logic;
		addr: in std_logic_vector(7 downto 0);
		data_in: in std_logic_vector(7 downto 0); 
		data_out: out std_logic_vector(7 downto 0);
		pins_in: in std_logic_vector(7 downto 0);
		pins_out: out std_logic_vector(7 downto 0));
end gpio;

architecture Behavioral of gpio is
begin

	-- input
	process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst='1') then
				data_out <= (others => '0');
			else
				data_out <= pins_in;
			end if;
		end if;
	end process;
	
	-- output
	process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst='1') then
				pins_out <= (others => '0');
			elsif(addr=std_logic_vector(to_unsigned(ADDR_OUT, 8)) and en_wr='1') then
				pins_out <= data_in;
			end if;
		end if;
	end process;

end Behavioral;

