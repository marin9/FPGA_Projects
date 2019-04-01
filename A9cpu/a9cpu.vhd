library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--	lda a	0000:	m[a] -> ac
--	sta a	0001:	ac -> m[a]
--	jeq a	0010:	if(ac==0) a --> pc
--	jsr a 0011: pc --> m[sp--] a --> pc
--	ret		0100: ++sp				| pc <-- m[sp]
--	ldi a	0101:	m[a] -> dr	| m[dr] -> ac
--	sti a	0110:	m[a] -> dr	| ac -> m[dr]
--	add a	0111:	m[a] -> dr	| (ac + dr) -> ac
--	nor a	1000:	m[a] -> dr	| (ac nor dr) -> ac

entity a9cpu is
port(	clk: in std_logic;
			rst: in std_logic;
			wr: out std_logic;
			adr: out std_logic_vector(15 downto 0);
			din: in std_logic_vector(15 downto 0);
			dout: out std_logic_vector(15 downto 0));
end a9cpu;

architecture Behavioral of a9cpu is
	type state is(FETCH, EXECUTE1, EXECUTE2);
	signal st, n_st: state;
	signal ac, n_ac: std_logic_vector(15 downto 0);
	signal ir, n_ir: std_logic_vector(15 downto 0);
	signal dr, n_dr: std_logic_vector(15 downto 0);
	signal sp, n_sp: std_logic_vector(11 downto 0);
	signal pc, n_pc: std_logic_vector(11 downto 0);
	signal opcode: std_logic_vector(3 downto 0);
	signal const: std_logic_vector(11 downto 0);
begin

	opcode <= ir(15 downto 12);
	const <= ir(11 downto 0);

	process(st, st, ac, ir, dr, sp, pc, din, opcode, const) is
	begin
		wr <= '0';
		adr <= (others => '0');
		n_st <= st;
		n_ac <= ac;
		n_ir <= ir;
		n_dr <= dr;
		n_sp <= sp;
		n_pc <= pc;
		dout <= ac;
	
		case st is
		when FETCH =>
			adr <= "0000" & pc;
			n_ir <= din;
			n_pc <= pc + 1;
			n_st <= EXECUTE1;
		when EXECUTE1 =>
			case opcode is
			when "0000" => --lda
				adr <= "0000" & const;
				n_ac <= din;
				n_st <= FETCH;
			when "0001" => --sta
				wr <= '1';
				adr <= "0000" & const;
				n_st <= FETCH;
			when "0010" => --jeq
				if(ac=x"0000") then
					n_pc <= const;
				end if;
				n_st <= FETCH;
			when "0011" => --jsr
				adr <= "1111" & sp;
				wr <= '1';
				dout <= "0000" & pc;
				n_sp <= sp - 1;
				n_pc <= const;
				n_st <= FETCH;
			when "0100" => --ret
				n_sp <= sp + 1;
				n_st <= EXECUTE2;	
			when others => --ldi/sti/add/nor
				adr <= "0000" & const;
				n_dr <= din;
				n_st <= EXECUTE2;
			end case;
		WHEN EXECUTE2 =>
			case opcode is
			when "0100" => --ret
				adr <= "1111" & sp;
				n_pc <= din(11 downto 0);
			when "0101" => --ldi
				adr <= dr;
				n_ac <= din;
			when "0110" => --sti
				adr <= dr;
				wr <= '1';
			when "0111" => --add
				n_ac <= ac + dr;
			when "1000" => --nor
				n_ac <= ac nor dr;
			when others => null;
			end case;
			n_st <= FETCH;
		when others => null;
		end case;	
	end process;
	

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				st <= FETCH;
				ac <= (others => '0');
				pc <= (others => '0');
				ir <= (others => '0');
				dr <= (others => '0');
				sp <= (others => '1');
			else
				st <= n_st;
				ac <= n_ac;
				pc <= n_pc;
				ir <= n_ir;
				dr <= n_dr;
				sp <= n_sp;
			end if;
		end if;
	end process;
	
end Behavioral;

