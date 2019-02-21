library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lcd is
port(	clk: in std_logic;
		rst: in std_logic;
		addr: in std_logic_vector(12 downto 0);
		data: in std_logic_vector(15 downto 0);
		rs: out std_logic;
		en: out std_logic;
		d4: out std_logic;
		d5: out std_logic;
		d6: out std_logic;
		d7: out std_logic);
end lcd;

architecture Behavioral of lcd is
	type memory is array(0 to 18) of std_logic_vector(7 downto 0);
	type state is(S0, S1, S2, S3, S4, S5, S6, SD);
	signal mem: memory;
	signal c_state, n_state: state;
	signal x, n_x: std_logic_vector(4 downto 0);
	signal timer, n_timer: std_logic_vector(21 downto 0);

begin

	process(c_state, x, mem, timer) is
	begin
		en <= '0';
		d4 <= '0';
		d5 <= '0';
		d6 <= '0';
		d7 <= '0';
		n_x <= x;
		n_state <= c_state;
		n_timer <= timer + 1;
		
		if(x="00000" or x="00001" or x="00010" or x="10011") then
			rs <= '0';
		else
			rs <= '1';
		end if;
		
		case c_state is
		when S0 =>
			if(conv_integer(timer)=1250) then
				n_timer <= (others => '0');
				n_state <= S1;
			end if;
		when S1 =>
			en <= '1';
			if(conv_integer(timer)=1250) then
				n_timer <= (others => '0');
				n_state <= S2;
			end if;
		when S2 =>
			en <= '1';
			d7 <= mem(conv_integer(x))(7);
			d6 <= mem(conv_integer(x))(6);
			d5 <= mem(conv_integer(x))(5);
			d4 <= mem(conv_integer(x))(4);
			if(conv_integer(timer)=1250) then
				n_timer <= (others => '0');
				n_state <= S3;
			end if;
		when S3 =>
			en <= '0';
			d7 <= mem(conv_integer(x))(7);
			d6 <= mem(conv_integer(x))(6);
			d5 <= mem(conv_integer(x))(5);
			d4 <= mem(conv_integer(x))(4);
			if(conv_integer(timer)=1250) then
				n_timer <= (others => '0');
				n_state <= S4;
			end if;
		when S4 =>
			en <= '1';
			if(conv_integer(timer)=1250) then
				n_timer <= (others => '0');
				n_state <= S5;
			end if;
		when S5 =>
			en <= '1';
			d7 <= mem(conv_integer(x))(3);
			d6 <= mem(conv_integer(x))(2);
			d5 <= mem(conv_integer(x))(1);
			d4 <= mem(conv_integer(x))(0);
			if(conv_integer(timer)=1250) then
				n_timer <= (others => '0');
				n_state <= S6;
			end if;
		when S6 =>
			en <= '0';
			d7 <= mem(conv_integer(x))(3);
			d6 <= mem(conv_integer(x))(2);
			d5 <= mem(conv_integer(x))(1);
			d4 <= mem(conv_integer(x))(0);
			if(conv_integer(timer)=50000) then
				n_timer <= (others => '0');
				if(x="10010") then
					n_x <= (others => '0');
					n_state <= SD;
				else
					n_x <= x + 1;
					n_state <= S0;
				end if;
			end if;
		when SD =>
			if(conv_integer(timer)=4000000) then
				n_timer <= (others => '0');
				n_state <= S0;
			end if;
		when others =>
			null;
		end case;
	end process;
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= S0;
				timer <= (others => '0');
				x <= (others => '0');
			else
				c_state <= n_state;
				timer <= n_timer;
				x <= n_x;
			end if;
		end if;
	end process;
	
	mem(0) <= x"0F";
	mem(1) <= x"01";
	mem(2) <= x"02";
	mem(3) <= x"41";
	mem(4) <= x"3A";

	mem(9) <= x"20";
	mem(10) <= x"20";
	mem(11) <= x"20";
	mem(12) <= x"20";
	mem(13) <= x"44";
	mem(14) <= x"3A";

	process(clk) is
	begin
		if(falling_edge(clk)) then	
				-- a[3]
				if(addr(12)='1') then
					mem(5) <= x"00" + 49;
				else
					mem(5) <= x"00" + 48;
				end if;			
				-- a[2]
				if(conv_integer(addr(11 downto 8))>9) then
					mem(6) <= (x"0" & addr(11 downto 8)) - 10 + 65;
				else
					mem(6) <= (x"0" & addr(11 downto 8)) + 48;
				end if;
				-- a[1]
				if(conv_integer(addr(7 downto 4))>9) then
					mem(7) <= (x"0" & addr(7 downto 4)) - 10 + 65;
				else
					mem(7) <= (x"0" & addr(7 downto 4)) + 48;
				end if;
				-- a[0]
				if(conv_integer(addr(3 downto 0))>9) then
					mem(8) <= (x"0" & addr(3 downto 0)) - 10 + 65;
				else
					mem(8) <= (x"0" & addr(3 downto 0)) + 48;
				end if;	
				-- d[3]
				if(conv_integer(data(15 downto 12))>9) then
					mem(15) <= (x"0" & data(15 downto 12)) - 10 + 65;
				else
					mem(15) <= (x"0" & data(15 downto 12)) + 48;
				end if;
				-- d[2]
				if(conv_integer(data(11 downto 8))>9) then
					mem(16) <= (x"0" & data(11 downto 8)) - 10 + 65;
				else
					mem(16) <= (x"0" & data(11 downto 8)) + 48;
				end if;
				-- d[1]
				if(conv_integer(data(7 downto 4))>9) then
					mem(17) <= (x"0" & data(7 downto 4)) - 10 + 65;
				else
					mem(17) <= (x"0" & data(7 downto 4)) + 48;
				end if;
				-- d[0]
				if(conv_integer(data(3 downto 0))>9) then
					mem(18) <= (x"0" & data(3 downto 0)) - 10 + 65;
				else
					mem(18) <= (x"0" & data(3 downto 0)) + 48;
				end if;			
		end if;
	end process;
	
end Behavioral;

