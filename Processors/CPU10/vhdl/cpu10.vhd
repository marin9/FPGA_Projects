library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu10 is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(10 downto 0);
		dout: out std_logic_vector(7 downto 0);
		din: in std_logic_vector(7 downto 0));
end cpu10;

architecture Behavioral of cpu10 is
	type state is(IF1, IF2, RDD, RDI, EXE, SPH, LPH, LPL);
	signal c_state, n_state: state;
	
	signal ac, n_ac: std_logic_vector(7 downto 0);
	signal ir, n_ir: std_logic_vector(7 downto 0);
	signal dr, n_dr: std_logic_vector(7 downto 0);
	signal sr, n_sr: std_logic_vector(3 downto 0);
	signal pc, n_pc: std_logic_vector(10 downto 0);
	signal res: std_logic_vector(8 downto 0);
begin

	process(ac, sr, ir, dr, pc, res, c_state, din) is
	begin
		wr <= '0';
		n_ac <= ac;
		n_sr <= sr;
		n_ir <= ir;
		n_dr <= dr;
		n_pc <= pc;
		addr <= pc;
		dout <= ac;
		n_state <= c_state;
		
		case c_state is
		when IF1 =>
			n_pc <= pc + 1;
			n_ir <= din;
			n_state <= IF2;
		when IF2 =>
			n_pc <= pc + 1;
			n_dr <= din;
			if(ir(7 downto 6)="10") then		-- dir
				n_state <= RDD;
			elsif(ir(7 downto 6)="11") then	-- ind
				n_state <= RDI;
			else										-- imm
				n_state <= EXE;
			end if;
		when RDD =>
			if(ir(6)='0') then	-- dir
				addr <= ir(2 downto 0) & dr;
			else						-- ind
				addr <= "000" & dr;
			end if;
			n_dr <= din;
			n_state <= EXE;
		when RDI =>
			addr <= ir(2 downto 0) & dr;
			n_dr <= din;
			n_state <= RDD;
		when EXE =>
			n_state <= IF1;
			if(ir(5 downto 3)="100") then			-- STA
				addr <= ir(2 downto 0) & dr;
				wr <= '1';
			elsif(ir(7 downto 3)="01001") then	-- RTS
				n_sr(2 downto 0) <= sr(2 downto 0) - 1;
				n_state <= LPH;
			elsif(ir(7 downto 3)="00101") then	-- JMP
				n_pc <= ir(2 downto 0) & dr;
			elsif(ir(7 downto 3)="01000") then	-- JSR	
				addr <= "00100000" & sr(2 downto 0);
				dout <= pc(7 downto 0); 
				n_sr(2 downto 0) <= sr(2 downto 0) + 1;
				n_state <= SPH;			
			elsif(ir(7 downto 3)="00110") then	-- JEQ
				if(ac=x"00") then
					n_pc <= ir(2 downto 0) & dr;
				end if;
			elsif(ir(7 downto 3)="00111") then	-- JCS
				if(sr(3)='1') then
					n_pc <= ir(2 downto 0) & dr;
				end if;
			else											-- ALU
				n_ac <= res(7 downto 0);
				n_sr(3) <= res(8);		
			end if;
		when SPH =>
			addr <= "00100000" & sr(2 downto 0);
			dout <= "00000" & pc(10 downto 8); 
			n_pc <= ir(2 downto 0) & dr;
			n_sr(2 downto 0) <= sr(2 downto 0) + 1;
			n_state <= IF1;
		when LPH =>
			addr <= "00100000" & sr(2 downto 0);
			n_pc <= din(2 downto 0) & pc(7 downto 0);
			n_sr(2 downto 0) <= sr(2 downto 0) - 1;
			n_state <= LPL;
		when LPL =>
			addr <= "00100000" & sr(2 downto 0);
			n_pc <= pc(10 downto 8) & din;
			n_state <= IF1;
		when others =>
			null;
		end case;
	end process;
	
	with ir(4 downto 3) select res <=
	('0' & ac) + ('0' & dr)		when "00",
	('0' & ac) nor ('0' & dr)	when "01",
	('0' & ac) xor ('0' & dr)	when "10",
	('0' & dr)						when others;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				pc <= (others => '0');
				sr <= (others => '0');
				c_state <= IF1;
			else
				ac <= n_ac;
				sr <= n_sr;
				ir <= n_ir;
				dr <= n_dr;
				pc <= n_pc;
				c_state <= n_state;
			end if;
		end if;
	end process;
end Behavioral;
