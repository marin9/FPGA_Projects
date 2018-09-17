library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(10 downto 0);
		din: in std_logic_vector(7 downto 0);
		dout: out std_logic_vector(7 downto 0));
end cpu;

architecture Behavioral of cpu is
	type state is(IF1, IF2, EXE, RDM);
	signal current_state, next_state: state;	
	signal ac, ir, dr, res: std_logic_vector(7 downto 0);
	signal n_ac, n_ir, n_dr: std_logic_vector(7 downto 0);
	signal pc, n_pc: std_logic_vector(10 downto 0);
begin
	-- Control unit
	process(ir, dr, ac, pc, res, din, current_state) is
	begin
		n_pc <= pc;
		n_ac <= ac;
		n_ir <= ir;
		n_dr <= dr;
		wr <= '0';
		addr <= pc;
		dout <= ac;
			
		case current_state is
		when IF1 => 
			n_ir <= din;
			n_pc <= pc + 1;
			next_state <= IF2;
		when IF2 => 
			n_dr <= din;
			n_pc <= pc + 1;
			if(ir(3)='1') then next_state <= RDM;
			else	next_state <= EXE; end if;
		when EXE =>		
			if(ir(7 downto 6)="11") then
				if(ac=x"00") then
					n_pc <= ir(2 downto 0) & dr;
				end if;
			elsif(ir(7 downto 6)="10") then
				n_pc <= ir(2 downto 0) & dr;
			elsif(ir(7 downto 6)="01") then
				wr <= '1';
				addr <= ir(2 downto 0) & dr;
			else
				n_ac <= res;
			end if;	
			next_state <= IF1;
		when RDM => 
			addr <= ir(2 downto 0) & dr;
			n_dr <= din;
			next_state <= EXE;
		when others => null;
		end case;
	end process;

	-- Arithmetic-Logic unit
	with ir(5 downto 4) select res <=
	ac + dr		when "00",
	ac nor dr	when "01",
	ac xor dr	when "10",
	dr				when others;

	-- Registers
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				pc <= (others => '0');
				current_state <= IF1;
			else					
				dr <= n_dr;
				ir <= n_ir;
				ac <= n_ac;
				pc <= n_pc;
				current_state <= next_state;
			end if;
		end if;
	end process;
end Behavioral;
