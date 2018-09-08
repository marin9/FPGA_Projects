library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pwm is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic;
		data: in std_logic_vector(7 downto 0);
		pwmout: out std_logic);
end pwm;

architecture Behavioral of pwm is
	signal data_reg: std_logic_vector(7 downto 0);
	signal counter: std_logic_vector(7 downto 0);
begin

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				data_reg <= (others => '0');
			elsif(wr='1') then
				data_reg <= data;
			end if;
		end if;
	end process;
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				counter <= (others => '0');
			else
				counter <= counter + 1;
			end if;
			
			if(counter >= data_reg) then
				pwmout <= '0';
			else
				pwmout <= '1';
			end if;	
		end if;
	end process;

end Behavioral;

