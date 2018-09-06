library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		addr: out std_logic_vector(11 downto 0);
		din: in std_logic_vector(7 downto 0);
		dout: out std_logic_vector(7 downto 0));
end cpu;

architecture Behavioral of cpu is
	type state is(F1, F2, EX, AD);
	signal current_state, next_state: state;
	
	signal ac, ir, dr: std_logic_vector(7 downto 0);
	signal pc: std_logic_vector(11 downto 0);
	signal zf: std_logic;
	signal res: std_logic_vector(7 downto 0);
	
	signal wr_ac: std_logic;
	signal wr_ir: std_logic;
	signal wr_dr: std_logic;
	signal wr_pc: std_logic;
	signal inc_pc: std_logic;
	signal sel_adr: std_logic;
	signal sel_alu: std_logic_vector(1 downto 0);
begin

	-- Control unit
	process(ir, zf, current_state) is
	begin
		wr <= '0';
		wr_ac <= '0';
		wr_ir <= '0';
		wr_dr <= '0';
		wr_pc <= '0';
		inc_pc <= '0';
		sel_adr <= '0';
		sel_alu <= ir(6 downto 5);
		next_state <= current_state;
		
		case current_state is
		when F1 =>
			inc_pc <= '1';
			wr_ir <= '1';
			next_state <= F2;
		when F2 =>
			inc_pc <= '1';
			wr_dr <= '1';
			next_state <= EX;
		when EX =>
			if(ir(7)='0' and ir(4)='0') then 	-- ALU imm
				wr_ac <= '1';
				next_state <= F1;
			elsif(ir(7)='0' and ir(4)='1') then	-- ALU dir
				sel_adr <= '1';
				wr_dr <= '1';
				next_state <= AD;
			elsif(ir(7 downto 4)="1000") then	-- STA
				wr <= '1';
				sel_adr <= '1';
				next_state <= F1;
			elsif(ir(7 downto 4)="1001") then	-- JMP
				wr_pc <= '1';
				next_state <= F1;
			elsif(ir(7 downto 4)="1010") then	-- JEQ
				if(zf='1') then
					wr_pc <= '1';
				end if;
				next_state <= F1;
			else
				next_state <= F1;
			end if;
		when AD =>
			wr_ac <= '1';
			next_state <= F1;
		when others =>
			null;
		end case;
	end process;

	-- Address
	with sel_adr select addr <=
	pc 						when '0',
	ir(3 downto 0) & dr	when others;

	-- Comparator
	with ac select zf <=
	'1' when "00000000",
	'0' when others;

	-- Arithmetic-Logic unit
	with sel_alu select res <=
	ac + dr		when "00",
	ac and dr	when "01",
	ac xor dr	when "10",
	dr				when others;

	-- Registers
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				current_state <= F1;
				ac <= (others => '0');
				ir <= (others => '0');
				dr <= (others => '0');
				pc <= (others => '0');
			else
				current_state <= next_state;
				if(wr_ac='1') then ac <= res; end if;
				if(wr_ir='1') then ir <= din; end if;
				if(wr_dr='1') then dr <= din; end if;
				if(wr_pc='1') then 
					pc <= ir(3 downto 0) & dr;
				elsif(inc_pc='1') then	
					pc <= pc + 1;
				end if;
			end if;
		end if;
	end process;
	dout <= ac;

end Behavioral;

