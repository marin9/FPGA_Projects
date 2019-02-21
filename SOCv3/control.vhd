library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
port(	sel: in std_logic;
		cpu_wr: in std_logic;
		cpu_addr: in std_logic_vector(12 downto 0);
		cpu_din: out std_logic_vector(15 downto 0);
		cpu_dout: in std_logic_vector(15 downto 0);
		ram_wr: out std_logic;
		ram_addr: out std_logic_vector(12 downto 0);
		ram_din: out std_logic_vector(15 downto 0);
		ram_dout: in std_logic_vector(15 downto 0);
		key_wr: in std_logic;
		key_addr: in std_logic_vector(12 downto 0);
		key_data: in std_logic_vector(15 downto 0));
end control;

architecture Behavioral of control is
begin
	cpu_din <= ram_dout;
	
	process(sel, key_wr, key_addr, key_data, cpu_wr, cpu_addr, cpu_dout) is
	begin
		if(sel='1') then
			ram_wr <= key_wr;
			ram_addr <= key_addr;
			ram_din <= key_data;	
		else
			ram_wr <= cpu_wr;
			ram_addr <= cpu_addr;
			ram_din <= cpu_dout;
		end if;
	end process;
end Behavioral;
