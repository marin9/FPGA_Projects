library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- instr: ooookkkk kkkkkkkk

-- add 000a
-- nor 001a
-- lda 010a
-- sta 0110
-- jeq 1000

entity cpu5 is
port(	clk, rst: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(15 downto 0);
		din: in std_logic_vector(15 downto 0);
		dout: out std_logic_vector(15 downto 0));
end cpu5;

architecture Behavioral of cpu5 is
	type state is(FETCH, EXECUTE, READMEM);
	signal c_state, n_state: state;	
	signal ir, n_ir: std_logic_vector(3 downto 0);
	signal dr, n_dr: std_logic_vector(15 downto 0);
	signal pc, n_pc: std_logic_vector(15 downto 0);
	signal ac, n_ac: std_logic_vector(15 downto 0);
begin
	-- Control
	process(c_state, ir, dr, ac, pc, din) is
	begin
		n_ir <= ir;
		n_dr <= dr;
		n_pc <= pc;
		n_ac <= ac;		
		wr <= '0';
		addr <= pc;
		dout <= ac;
			
		case c_state is
		when FETCH => 
			n_ir <= din(15 downto 12);
			n_dr <= din(11)&din(11)&din(11)&din(11)&din(11 downto 0);
			n_pc <= pc + 1;
			n_state <= READMEM;
		when READMEM =>	
			if(ir(0)='1') then
				addr <= dr;
				n_dr <= din;
			end if;
			n_state <= EXECUTE;
		when EXECUTE => 
			if(ir="1000") then
				if(ac=x"0000") then
					n_pc <= dr;
				end if;
			elsif(ir="0110") then
				addr <= dr;
				wr <= '1';
			elsif(ir(3 downto 1)="010") then
				n_ac <= dr;
			elsif(ir(3 downto 1)="001") then
				n_ac <= ac nor dr;
			elsif(ir(3 downto 1)="000") then
				n_ac <= ac + dr;
			end if;
			n_state <= FETCH;
		when others => null;
		end case;
	end process;
	
	-- Registers
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				pc <= (others => '0');
				c_state <= FETCH;
			else
				ir <= n_ir;
				dr <= n_dr;
				pc <= n_pc;
				ac <= n_ac;
				c_state <= n_state;
			end if;
		end if;
	end process;
end Behavioral;

