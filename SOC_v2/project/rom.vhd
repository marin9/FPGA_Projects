library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity rom is
generic(AW: integer := 10; DW: integer := 13);
port(	clk: in std_logic;
		en: in std_logic;
		wr: in std_logic;
		addr_in: in std_logic_vector(AW-1 downto 0);
		addr_out: in std_logic_vector(AW-1 downto 0);
		input: in std_logic_vector(DW-1 downto 0);
		output: out std_logic_vector(DW-1 downto 0));
end rom;

architecture Behavioral of rom is
	type memory is array(0 to 2**AW-1) of std_logic_vector(DW-1 downto 0);
	signal mem: memory;
begin

	process(clk, en) is
	begin
		if(rising_edge(clk) and en='1') then
			if(wr='1') then
				mem(conv_integer(addr_in)) <= input;
			else
				output <= mem(conv_integer(addr_out));
			end if;
		end if;
	end process;

--	process(clk) is
--	begin
--		if(rising_edge(clk)) then
--			if(addr_out="0000000000") then 
--				output <="01110" & x"05";
--			elsif(addr_out="0000000001") then
--				output <="00011" & x"ff";
--			elsif(addr_out="0000000010") then
--				output <="11100" & x"05";
--			elsif(addr_out="0000000011") then
--				output <="00011" & x"ff";
--			elsif(addr_out="0000000100") then
--				output <="11000" & x"04";
--			elsif(addr_out="0000000101") then
--				output <="01110" & x"00";
--			elsif(addr_out="0000000110") then
--				output <="01000" & x"07";
--			elsif(addr_out="0000000111") then
--				output <="00010" & x"09";
--			else
--				output <= "00000" & x"00";
--			end if;
--		end if;
--	end process;
	
	

end Behavioral;