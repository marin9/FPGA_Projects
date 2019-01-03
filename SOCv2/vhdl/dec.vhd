library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity dec is
port(	clk: in std_logic;
		rst: in std_logic;
		zero: in std_logic;
		carry: in std_logic;
		instr: in std_logic_vector(7 downto 0);
		wr: out std_logic;
		wr_ir: out std_logic; 
		wr_mdr: out std_logic;
		wr_acc: out std_logic; 
		wr_pc: out std_logic;
		sel_alu: out std_logic_vector(1 downto 0); 
		sel_accin: out std_logic_vector(1 downto 0);
		sel_addr: out std_logic; 
		sel_pid: out std_logic; 
		sel_pcin: out std_logic);
end dec;

architecture Behavioral of dec is
	type state is(FETCH, EXECUTE);
	type cycle is(T1, T2, T3);
	signal current_state, next_state: state;	
	signal current_cycle, next_cycle: cycle;
	
	constant ALU_IM: std_logic_vector(7 downto 0) := "000100--";
	constant ALU_DI: std_logic_vector(7 downto 0) := "001000--";
	constant LDA_IM: std_logic_vector(7 downto 0) := "01000000";
	constant LDA_DI: std_logic_vector(7 downto 0) := "01000001";
	constant STA_DI: std_logic_vector(7 downto 0) := "01000010";
	constant INN_P: std_logic_vector(7 downto 0)  := "10000000";
	constant OUT_P: std_logic_vector(7 downto 0)  := "10000001";
	constant JMP: std_logic_vector(7 downto 0)    := "101-----";
	constant JEQ: std_logic_vector(7 downto 0)    := "110-----";
	constant JCS: std_logic_vector(7 downto 0)    := "111-----";
begin

	process(current_state, instr, zero, carry, current_cycle) is
	begin
		wr <= '0';
		wr_ir <= '0';
		wr_mdr <= '0';
		wr_acc <= '0';
		wr_pc <= '0';
		sel_alu <= instr(1 downto 0);
		sel_accin <= "00";
		sel_addr <= '0';
		sel_pid <= '0';
		sel_pcin <= '0';		
		next_cycle <= T1;
		next_state <= FETCH;
	
		case current_state is
		when FETCH =>
			if(current_cycle=T1) then
				wr_pc <= '1';
				next_cycle <= T2;
			elsif(current_cycle=T2) then
				wr_ir <= '1';
				wr_pc <= '1';
				next_cycle <= T3;
			else
				wr_mdr <= '1';
				next_state <= EXECUTE;
			end if;
		when EXECUTE =>
			-- ALU_IM
			if(instr(7 downto 2)="000100") then
				wr_acc <= '1';
			-- ALU_DI
			elsif(instr(7 downto 2)="001000") then
				if(current_cycle=T1) then
					sel_addr <= '1';
					next_cycle <= T2;
					next_state <= EXECUTE;
				elsif(current_cycle=T2) then
					wr_mdr <= '1';
					next_cycle <= T3;
					next_state <= EXECUTE;
				else
					wr_acc <= '1';
				end if;
			-- LDA_IM
			elsif(instr="01000000") then		
				wr_acc <= '1';
				sel_accin <= "01";
			-- LDA_DI
			elsif(instr="01000001") then	
				if(current_cycle=T1) then
					sel_addr <= '1';
					next_cycle <= T2;
					next_state <= EXECUTE;
				elsif(current_cycle=T2) then
					wr_mdr <= '1';
					next_cycle <= T3;
					next_state <= EXECUTE;
				else
					wr_acc <= '1';
					sel_accin <= "01";
				end if;
			-- STA_DI
			elsif(instr="01000010") then
				wr <= '1';
				sel_addr <= '1';
			-- INN
			elsif(instr="10000000") then
				wr_acc <= '1';
				sel_pid <= '1';
				sel_accin <= "10";
			-- OUT
			elsif(instr="10000001") then
				sel_pid <= '1';
			-- JMP
			elsif(instr(7 downto 5)="101") then
				wr_pc <= '1';
				sel_pcin <= '1';	
			-- JEQ
			elsif(instr(7 downto 5)="110" and zero='1') then
				wr_pc <= '1';
				sel_pcin <= '1';	
			-- JCS
			elsif(instr(7 downto 5)="111" and carry='1') then
				wr_pc <= '1';
				sel_pcin <= '1';	
			end if;		
		when others =>
			null;
		end case;
	end process;


	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				current_state <= FETCH;
				current_cycle <= T1;
			else
				current_state <= next_state;
				current_cycle <= next_cycle;
			end if;
		end if;
	end process;

end Behavioral;

