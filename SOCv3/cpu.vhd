library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- add 001
-- nor 010
-- lda 011
-- sta 100
-- jeq 101
-- hlt 000

entity cpu is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		stop: out std_logic;
		addr: out std_logic_vector(12 downto 0);
		din: in std_logic_vector(15 downto 0);
		dout: out std_logic_vector(15 downto 0));
end cpu;

architecture Behavioral of cpu is
	type state is(FETCH, EXECUTE1, EXECUTE2);
	signal c_state, n_state: state;
	signal ac, n_ac: std_logic_vector(15 downto 0);
	signal dr, n_dr: std_logic_vector(15 downto 0);
	signal ir, n_ir: std_logic_vector(15 downto 0);
	signal pc, n_pc: std_logic_vector(12 downto 0);
	signal opcode: std_logic_vector(2 downto 0);
	signal const: std_logic_vector(12 downto 0);
begin

	opcode <= ir(15 downto 13);
	const <= ir(12 downto 0);

	process(c_state, ac, dr, pc, ir, din, opcode, const) is
	begin
		addr <= (others => '0');
		n_ac <= ac;
		n_dr <= dr;
		n_pc <= pc;
		n_ir <= ir;
		dout <= ac;
		stop <= '0';
		n_state <= c_state;
		wr <= '0';
		
		case c_state is
		when FETCH =>
			addr <= pc;
			n_ir <= din;
			n_pc <= pc + 1;
			n_state <= EXECUTE1;
		when EXECUTE1 =>
			if(opcode="000") then
				stop <= '1';
				n_state <= c_state;
			elsif(opcode="101") then -- jeq
				if(ac=x"0000") then
					n_pc <= const;
				end if;
				n_state <= FETCH;
			elsif(opcode="011") then -- lda
				addr <= const;
				n_ac <= din;
				n_state <= FETCH;
			elsif(opcode="100") then -- sta
				addr <= const;
				wr <= '1';
				n_state <= FETCH;
			else							-- alu
				addr <= const;
				n_dr <= din;
				n_state <= EXECUTE2;
			end if;
		when EXECUTE2 =>
			if(opcode="001") then	-- add
				n_ac <= ac + dr;
			elsif(opcode="010") then -- nor
				n_ac <= ac nor dr;
			end if;
			n_state <= FETCH;
		when others =>
			null;
		end case;
	end process;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				ac <= (others => '0');
				dr <= (others => '0');
				pc <= (others => '0');
				c_state <= FETCH;
			else
				ac <= n_ac;
				dr <= n_dr;
				pc <= n_pc;
				ir <= n_ir;
				c_state <= n_state;
			end if;
		end if;
	end process;
	
end Behavioral;
