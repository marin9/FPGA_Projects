library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity keyboard is
port(	clk: in std_logic;
		rst: in std_logic;
		btn_c: in std_logic;
		btn_w: in std_logic;
		btn_p: in std_logic;
		btn_m: in std_logic;
		btn_0: in std_logic;
		btn_1: in std_logic;
		btn_d: in std_logic_vector(1 downto 0);
		wr: out std_logic;
		addr: out std_logic_vector(12 downto 0);
		dout: out std_logic_vector(15 downto 0));
end keyboard;

architecture Behavioral of keyboard is
	signal adrreg, n_adrreg: std_logic_vector(12 downto 0);
	signal datreg, n_datreg: std_logic_vector(15 downto 0);
begin
	addr <= adrreg;
	dout <= datreg;

	process(adrreg, datreg, btn_p, btn_m, btn_d, btn_c, btn_0, btn_1, btn_w) is
	begin
		n_adrreg <= adrreg;
		n_datreg <= datreg;
		
		if(btn_p='1') then
			case btn_d is
			when "00" => n_adrreg <= adrreg + 1;
			when "01" => n_adrreg <= adrreg + 10;
			when "10" => n_adrreg <= adrreg + 100;
			when "11" => n_adrreg <= adrreg + 1000;
			when others => null;
			end case;
		end if;
		if(btn_m='1') then
			case btn_d is
			when "00" => n_adrreg <= adrreg - 1;
			when "01" => n_adrreg <= adrreg - 10;
			when "10" => n_adrreg <= adrreg - 100;
			when "11" => n_adrreg <= adrreg - 1000;
			when others => null;
			end case;
		end if;
		
		if(btn_c='1') then
			n_datreg <= (others => '0');
		end if;
		
		if(btn_0='1') then
			n_datreg <= datreg(14 downto 0) & '0';
		end if;
		if(btn_1='1') then
			n_datreg <= datreg(14 downto 0) & '1';
		end if;
		if(btn_w='1') then
			wr <= '1';
		else
			wr <= '0';
		end if;
	end process;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				adrreg <= (others => '0');
				datreg <= (others => '0');
			else
				adrreg <= n_adrreg;
				datreg <= n_datreg;
			end if;
		end if;
	end process;

end Behavioral;
