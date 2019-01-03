library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- instr: iiiiaa---------- kkkkkkkkkkkkkkkk

--      iiii
-- add: 0000
-- sub: 0001
-- and: 0010
-- orr: 0011
-- xor: 0100
-- asr: 0101
-- swp: 0110
-- lda: 0111
-- sta: 1000
-- jmp: 1001
-- jeq: 1010
-- jne: 1011
-- jcs: 1100
-- jnc: 1101 
-- jsr: 1110
-- rts: 1111

--    aa
-- k: 00
-- a: 01
-- x: 10
-- x: 11

entity cpu10a is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(15 downto 0);
		dout: out std_logic_vector(15 downto 0);
		din: in std_logic_vector(15 downto 0));
end cpu10a;

architecture Behavioral of cpu10a is
	type state is(FETCH1, FETCH2, RDMEM1, RDMEM2, EXECUTE);
	signal c_state, n_state: state;
	signal zf, cf, n_zf, n_cf: std_logic;
	signal ir, n_ir: std_logic_vector(15 downto 10);
	signal dr, n_dr: std_logic_vector(15 downto 0);
	signal ac, n_ac: std_logic_vector(15 downto 0);
	signal pc, n_pc: std_logic_vector(15 downto 0);
	signal aluout: std_logic_vector(16 downto 0);
	signal iopc: std_logic_vector(3 downto 0);
	signal iadr: std_logic_vector(1 downto 0);
begin
	iopc <= ir(15 downto 12);
	iadr <= ir(11 downto 10);

	-- Control
	process(c_state, zf, cf, ir, dr, ac, pc, aluout, iopc, iadr, din) is
	begin
		n_zf <= zf;
		n_cf <= cf;
		n_ir <= ir;
		n_dr <= dr;
		n_ac <= ac;
		n_pc <= pc;
		n_state <= c_state;
		addr <= pc;
		dout <= ac;
		wr <= '0';
	
		case c_state is
		when FETCH1 =>
			n_ir <= din(15 downto 10);
			n_pc <= pc + 1;
			n_state <= FETCH2;
		when FETCH2 =>
			n_dr <= din;
			n_pc <= pc + 1;
			if(iadr="00") then
				n_state <= EXECUTE;
			elsif(iadr="01") then
				n_state <= RDMEM2;
			elsif(iadr="10") then
				n_state <= RDMEM1;
			elsif(iadr="11") then
				n_state <= RDMEM1;
			end if;
		when RDMEM1 =>
			addr <= dr;
			n_dr <= din;
			n_state <= RDMEM2;
		when RDMEM2 =>
			addr <= dr;
			n_dr <= din;
			n_state <= EXECUTE;
		when EXECUTE =>
			if(iopc(3)='0') then
				n_ac <= aluout(15 downto 0);
				n_cf <= aluout(16);
				if(aluout(15 downto 0)=x"0000") then
					n_zf <= '1';
				else
					n_zf <= '0';
				end if;
			elsif(iopc="1000") then
				addr <= dr;
				wr <= '1';
			elsif(iopc="1001") then
				n_pc <= dr;
			elsif(iopc="1010") then
				if(zf='1') then
					n_pc <= dr;
				end if;
			elsif(iopc="1011") then
				if(zf='0') then
					n_pc <= dr;
				end if;
			elsif(iopc="1100") then
				if(cf='1') then
					n_pc <= dr;
				end if;
			elsif(iopc="1101") then
				if(cf='0') then
					n_pc <= dr;
				end if;
			elsif(iopc="1110") then
				n_pc <= dr;
				n_ac <= pc;
			elsif(iopc="1111") then
				n_pc <= ac;
			end if;
			n_state <= FETCH1;
		when others => null;
		end case;
	end process;
	
	-- ALU
	with iopc(2 downto 0) select aluout <=
	('0' & ac) + ('0' & dr)					when "000",
	('0' & ac) - ('0' & dr)					when "001",
	('0' & ac) and ('0' & dr)				when "010",
	('0' & ac) or ('0' & dr)				when "011",
	('0' & ac) xor ('0' & dr)				when "100",
	ac(0)&ac(15)&ac(15 downto 1)			when "101",
	'0'&ac(7 downto 0)&ac(15 downto 8)	when "110",
	'0' & dr										when others;
	
	-- Registers
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= FETCH1;
				ir <= (others => '0');
				dr <= (others => '0');
				ac <= (others => '0');
				pc <= (others => '0');
				zf <= '0';
				cf <= '0';
			else
				c_state <= n_state;
				ir <= n_ir;
				dr <= n_dr;
				ac <= n_ac;
				pc <= n_pc;
				zf <= n_zf;
				cf <= n_cf;
			end if;
		end if;
	end process;
	
end Behavioral;

