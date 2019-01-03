library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- instr: isccooooddddssss kkkkkkkkkkkkkkkk

entity cpu10r is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(15 downto 0);
		dout: out std_logic_vector(15 downto 0);
		din: in std_logic_vector(15 downto 0));
end cpu10r;

architecture Behavioral of cpu10r is
	type state is(IF1, IF2, EAD, EXE, WB);
	type registers is array(0 to 15) of std_logic_vector(15 downto 0);
	
	signal c_state, n_state: state;
	signal ir1, ir2, n_ir1, n_ir2: std_logic_vector(15 downto 0);	
	signal regs, n_regs: registers;
	signal ra, rb, n_ra, n_rb: std_logic_vector(15 downto 0);
	signal ro, n_ro: std_logic_vector(16 downto 0);
	signal zf, cf, n_zf, n_cf: std_logic;
	
	signal i_sze: std_logic;
	signal i_stf: std_logic;
	signal i_cnd: std_logic_vector(1 downto 0);
	signal i_opc: std_logic_vector(3 downto 0);
	signal i_dst: std_logic_vector(3 downto 0);
	signal i_src: std_logic_vector(3 downto 0);
	signal cond_ok: std_logic;
	signal alu: std_logic_vector(16 downto 0);
begin

	i_sze <= ir1(15);
	i_stf <= ir1(14);
	i_cnd <= ir1(13 downto 12);
	i_opc <= ir1(11 downto 8);
	i_dst <= ir1(7 downto 4);
	i_src <= ir1(3 downto 0);
	cond_ok <=	i_stf or
					((not i_cnd(1)) and (not i_cnd(0)) and zf) or
					((not i_cnd(1)) and i_cnd(0) and (not zf)) or
					(i_cnd(1) and (not i_cnd(0)) and cf) or
					(i_cnd(1) and i_cnd(0) and (not cf));
	

	-- Control
	process(c_state, ir1, ir2, regs, ra, rb, ro, zf, cf, alu,
				i_sze, i_stf, i_opc, i_dst, i_src, cond_ok, din) is
	begin
		n_state <= c_state;
		n_ir1 <= ir1;
		n_ir2 <= ir2;
		n_regs <= regs;
		n_ra <= ra;
		n_rb <= rb;
		n_ro <= ro;
		n_zf <= zf;
		n_cf <= cf;
		addr <= regs(15);
		dout <= ra;
		wr <= '0';
	
		case c_state is
		when IF1 =>
			n_ir1 <= din;
			n_regs(15) <= regs(15) + 1;
			n_state <= IF2;
		when IF2 =>
			if(i_sze='1') then
				n_ir2 <= din;
				n_regs(15) <= regs(15) + 1;
			else
				n_ir2 <= (others => '0');
			end if;
			n_state <= EAD;
		when EAD =>
			if(cond_ok='1') then
				n_ra <= regs(conv_integer(i_dst));
				n_rb <= regs(conv_integer(i_src)) + ir2;
				n_state <= EXE;
			else
				n_state <= IF1;
			end if;
		when EXE =>
			if(i_opc(3)='0') then
				n_ro <= alu;	
				n_state <= WB;
			elsif(i_opc(3)='1') then
				if(i_opc(0)='0') then
					addr <= rb;
					n_regs(conv_integer(i_dst)) <= din;
				else
					addr <= rb;
					dout <= ra;
					wr <= '1';
				end if;
				n_state <= IF1;
			end if;
		when WB =>
			n_regs(conv_integer(i_dst)) <= ro(15 downto 0);
			if(i_stf='1') then
				n_cf <= ro(16);
				if(ro(15 downto 0)=x"0000") then
					n_zf <= '1';
				else
					n_zf <= '0';
				end if;
			end if;
			n_state <= IF1;
		when others =>
			null;
		end case;
	end process;
	
	
	-- ALU
	with i_opc(2 downto 0) select alu <=
	('0' & ra) + ('0' & rb)						when "000",
	('0' & ra) - ('0' & rb)						when "001",
	('0' & ra) and ('0' & rb)					when "010",
	('0' & ra) or ('0' & rb)					when "011",
	('0' & ra) xor ('0' & rb)					when "100",
	ra(0) & ra(15) & ra(15 downto 1)			when "101",
	'0' & ra(7 downto 0) & ra(15 downto 8)	when "110",
	'0' & rb											when others;


	-- Registers
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= IF1;
				regs <= (others => (others => '0'));
				zf <= '0';
				cf <= '0';
			else
				c_state <= n_state;
				ir1 <= n_ir1;
				ir2 <= n_ir2;
				regs <= n_regs;
				ra <= n_ra;
				rb <= n_rb;
				ro <= n_ro;
				zf <= n_zf;
				cf <= n_cf;
			end if;
		end if;
	end process;
	
end Behavioral;

