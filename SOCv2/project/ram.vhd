library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ram is
port(	clk: in std_logic;
		en: in std_logic;
		sel: in std_logic;
		wr0: in std_logic;
		addr0: in std_logic_vector(12 downto 0);
		din0: in std_logic_vector(7 downto 0);
		wr1: in std_logic;
		addr1: in std_logic_vector(12 downto 0);
		din1: in std_logic_vector(7 downto 0);
		dout: out std_logic_vector(7 downto 0));
end ram;

architecture Behavioral of ram is
	type memory is array(0 to 2**13-1) of std_logic_vector(7 downto 0);
	signal mem: memory;
	
	signal addr: std_logic_vector(12 downto 0);
	signal din: std_logic_vector(7 downto 0);
	signal wr: std_logic;
begin

	with sel select wr <=
	wr0 when '0',
	wr1 when others;
	
	with sel select addr <=
	addr0 when '0',
	addr1 when others;
	
	with sel select din <=
	din0 when '0',
	din1 when others;
	

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(en='1') then
				if(wr='1') then
					mem(conv_integer(addr)) <= din;
				else
					dout <= mem(conv_integer(addr));
				end if;
			end if;
		end if;
	end process;

end Behavioral;
