library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--	lda a	000:	m[a] -> ac
--	sta a	001:	ac -> m[a]
--	ldi a	010:	m[a] -> dr | m[dr] -> ac
--	sti a	011:	m[a] -> dr | ac -> m[dr]
--	add a	100:	m[a] -> dr | (ac + dr) -> ac
--	nor a	101:	m[a] -> dr | (ac nor dr) -> ac
--	jeq a	110:	if(ac==0) a --> pc
--	axp	111:	ac <-> pc
	
entity cpua8 is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(15 downto 0);
		dato: out std_logic_vector(15 downto 0);
		dati: in std_logic_vector(15 downto 0));
end cpua8;

architecture Behavioral of cpua8 is
	type state is(FETCH, EXE1, EXE2);
	signal c_state, n_state: state;
	signal reg_ac, n_reg_ac: std_logic_vector(15 downto 0);
	signal reg_pc, n_reg_pc: std_logic_vector(15 downto 0);
	signal reg_ir, n_reg_ir: std_logic_vector(15 downto 0);
	signal reg_dr, n_reg_dr: std_logic_vector(15 downto 0);
	
	signal opcode: std_logic_vector(2 downto 0);
	signal const: std_logic_vector(12 downto 0);
begin

	opcode <= reg_ir(15 downto 13);
	const <= reg_ir(12 downto 0);
	dato <= reg_ac;
	
	process(c_state, opcode, const, reg_ac, reg_pc, reg_ir, reg_dr, dati) is
	begin
		wr <= '0';
		addr <= (others => '0');
		n_state <= c_state;
		n_reg_ac <= reg_ac;
		n_reg_pc <= reg_pc;
		n_reg_ir <= reg_ir;
		n_reg_dr <= reg_dr;
		
		case c_state is
		when FETCH =>
			addr <= reg_pc;
			n_reg_ir <= dati;
			n_reg_pc <= reg_pc + 1;
			n_state <= EXE1;
		when EXE1=>
			case opcode is
			when "000" =>
				addr <= "000" & const;
				n_reg_ac <= dati;
				n_state <= FETCH;
			when "001" =>
				wr <= '1';
				addr <= "000" & const;
				n_state <= FETCH;
			when "110" =>
				if(reg_ac=x"0000") then
					n_reg_pc <= "000" & const;
				end if;
				n_state <= FETCH;
			when "111" =>
				n_reg_pc <= reg_ac;
				n_reg_ac <= reg_pc;
				n_state <= FETCH;
			when others =>
				addr <= "000" & const;
				n_reg_dr <= dati;
				n_state <= EXE2;
			end case;
		when EXE2 =>
			case opcode is
			when "010" =>
				addr <= reg_dr;
				n_reg_ac <= dati;
			when "011" =>
				wr <= '1';
				addr <= reg_dr;
			when "100" =>
				n_reg_ac <= reg_ac + reg_dr;
			when "101" =>
				n_reg_ac <= reg_ac nor reg_dr;
			when others => null;
			end case;
			n_state <= FETCH;
		when others => null;
		end case;
	end process;


	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= FETCH;
				reg_ac <= (others => '0');
				reg_pc <= (others => '0');
				reg_ir <= (others => '0');
				reg_dr <= (others => '0');
			else
				c_state <= n_state;
				reg_ac <= n_reg_ac;
				reg_pc <= n_reg_pc;
				reg_ir <= n_reg_ir;
				reg_dr <= n_reg_dr;
			end if;
		end if;
	end process;
	
end Behavioral;

