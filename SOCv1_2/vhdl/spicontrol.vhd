library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity spicontrol is
port( clk: in std_logic;
		rst: in std_logic;
				
		t0: in std_logic;
		t1: in std_logic;
		t0r: out std_logic;
		t1r: out std_logic;		
		ok: in std_logic;
		
		en_sck: out std_logic;
		en_ss: out std_logic;
		en_si: out std_logic;
		en_so: out std_logic;
		
		wr: out std_logic;
		fin: out std_logic);
end spicontrol;

architecture Behavioral of spicontrol is
	type stanje is(START, CS0, SI, SO, MEM, CS1);
	signal trenutno, sljedece: stanje;
	
	--attribute keep : string;  
	--attribute keep of trenutno: signal is "true";  
begin

	komb: process(trenutno, t0, t1, ok) is
	begin
		sljedece <= trenutno;
		
		case trenutno is
		when START =>
			sljedece <= CS0;
		when CS0 =>
			sljedece <= SI;
		when SI =>
			if(t0='1') then
				sljedece <= SO;
			end if;
		when SO =>
			if(t1='1') then
				sljedece <= MEM;
			end if;
		when MEM =>
			if(ok='1') then
				sljedece <= CS1;
			else
				sljedece <= SO;
			end if;
		when CS1 =>
			null;
		when others =>
			null;
		end case;
	end process;
	

	reg: process(clk, rst) is
	begin
		if(rst='1') then
			trenutno <= START;
		elsif(falling_edge(clk)) then
			trenutno <= sljedece;
		end if;
	end process;
	
	
	dec: process(trenutno) is
	begin
		t0r <= '0';
		t1r <= '0';
		en_sck <= '0';
		en_ss <= '0';
		en_si <= '0';
		en_so <= '0';	
		wr <= '0';
		fin <= '0';
		
		case trenutno is
		when START =>
			en_ss <= '1';
			t0r <= '1';
			t1r <= '1';
		when CS0 =>
			t0r <= '1';
			t1r <= '1';
		when SI =>
			en_sck <= '1';
			en_si <= '1';
			t1r <= '1';
		when SO =>
			en_sck <= '1';
			en_so <= '1';
		when MEM =>
			t1r <= '1';
			wr <= '1';
		when CS1 =>
			en_ss <= '1';
			fin <= '1';
		when others =>
			null;
		end case;
	end process;
	
end Behavioral;