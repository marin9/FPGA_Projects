library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.instructions.ALL;


entity dec is
port( instr: in std_logic_vector(4 downto 0);
		z: in std_logic;
		c: in std_logic;
		mux_addr: out std_logic;
		mux_alu: out std_logic;
		alu_op: out std_logic_vector(2 downto 0);
		en_acc: out std_logic;
		en_flg: out std_logic;
		pc_en: out std_logic;
		pc_ld: out std_logic;
		st_ld: out std_logic;
		st_inc: out std_logic;
		ir_rst: out std_logic;
		ram_wr: out std_logic);
end dec;

architecture Behavioral of dec is
	signal s_alu: std_logic_vector(2 downto 0);
begin
	
	s_alu <= instr(2 downto 0);

	process(instr, s_alu, c, z) is
	begin
		mux_addr <= '0';
		mux_alu <= '0';
		alu_op <= "000";
		en_acc <= '0';
		en_flg <= '0';
		pc_en <= '1';
		pc_ld <= '0';
		st_ld <= '0';
		st_inc <= '0';
		ir_rst <= '0';
		ram_wr <= '0';
	
		case instr is
		when NOP =>
			null;
		when RET =>
			pc_en <= '0';
			st_ld <= '1';
			ir_rst <= '1';
		when RETK =>
			pc_en <= '0';
			st_ld <= '1';
			en_acc <= '1';
			alu_op <= "101";
			mux_alu <= '1';
			ir_rst <= '1';
		when STA =>
			mux_addr <= '1';
			ram_wr <= '1';
		when TST_NZ =>
			ir_rst <= z;
		when TST_Z =>
			ir_rst <= not z;
		when TST_NC =>
			ir_rst <= c;
		when TST_C =>
			ir_rst <= not c;
		when ADDK =>
			mux_alu <= '1';
			en_acc <= '1';
			en_flg <= '1';
			alu_op <= s_alu;
		when SUBK =>
			mux_alu <= '1';
			en_acc <= '1';
			en_flg <= '1';
			alu_op <= s_alu;
		when ANDK =>
			mux_alu <= '1';
			en_acc <= '1';
			en_flg <= '1';
			alu_op <= s_alu;
		when ORRK =>
			mux_alu <= '1';
			en_acc <= '1';
			en_flg <= '1';
			alu_op <= s_alu;
		when XORK =>
			mux_alu <= '1';
			en_acc <= '1';
			en_flg <= '1';
			alu_op <= s_alu;
		when CMPK =>
			mux_alu <= '1';
			en_flg <= '1';
			alu_op <= "001";
		when LDAK =>
			mux_alu <= '1';
			en_acc <= '1';
			en_flg <= '1';
			alu_op <= s_alu;
		when ADDA =>
			mux_addr <= '1';
			alu_op <= s_alu;
			en_acc <= '1';
			en_flg <= '1';
		when SUBA =>
			mux_addr <= '1';
			alu_op <= s_alu;
			en_acc <= '1';
			en_flg <= '1';
		when ANDA =>
			mux_addr <= '1';
			alu_op <= s_alu;
			en_acc <= '1';
			en_flg <= '1';
		when ORRA =>
			mux_addr <= '1';
			alu_op <= s_alu;
			en_acc <= '1';
			en_flg <= '1';
		when XORA =>
			mux_addr <= '1';
			alu_op <= s_alu;
			en_acc <= '1';
			en_flg <= '1';
		when CMPA =>
			mux_addr <= '1';
			alu_op <= "001";
			en_flg <= '1';
		when LDAA =>
			mux_addr <= '1';
			alu_op <= s_alu;
			en_acc <= '1';
			en_flg <= '1';
		when others =>
			if(instr(4 downto 2)=JMP) then
				pc_ld <= '1';
				ir_rst <= '1';
			elsif(instr(4 downto 2)=CAL) then
				pc_ld <= '1';
				st_ld <= '1';
				st_inc <= '1';
				ir_rst <= '1';
			else
				null;
			end if;
		end case;
	end process;

end Behavioral;

