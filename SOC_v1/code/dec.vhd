library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.instr.ALL;


entity dec is
port( instr: in std_logic_vector(5 downto 0);
		flags: in std_logic_vector(1 downto 0);
		alu_op: out std_logic_vector(2 downto 0);
		acc_wr: out std_logic;
		flg_wr: out std_logic;
		alu_in: out std_logic;
		pc_load: out std_logic;
		ir_rst: out std_logic;
		ram_wr: out std_logic);
end dec;

architecture Behavioral of dec is
	signal s_instr: std_logic_vector(3 downto 0);
	signal s_flags: std_logic_vector(1 downto 0);
begin
	s_instr <= instr(5 downto 2);
	s_flags <= instr(1 downto 0);

	process(s_instr, s_flags, flags) is
	begin
		alu_op <= "000";
		alu_in <= '0';
		acc_wr <= '0';
		flg_wr <= '0';		
		pc_load <= '0';
		ir_rst <= '0';
		ram_wr <= '0';
		
		case s_instr is
		when JMP =>
			ir_rst <= '1';
			pc_load <= '1';		
		when TST =>
			if(s_flags/=flags) then
				ir_rst <= '1';
			end if;
		when STA =>
			ram_wr <= '1';
		when LDA_K =>
			alu_op <= "101";
			acc_wr <= '1';
			flg_wr <= '1';
		when ADD_K =>
			alu_op <= "000";
			acc_wr <= '1';
			flg_wr <= '1';
		when SUB_K =>
			alu_op <= "001";
			acc_wr <= '1';
			flg_wr <= '1';
		when AND_K =>
			alu_op <= "010";
			acc_wr <= '1';
			flg_wr <= '1';
		when ORR_K =>
			alu_op <= "011";
			acc_wr <= '1';
			flg_wr <= '1';
		when XOR_K =>
			alu_op <= "100";
			acc_wr <= '1';
			flg_wr <= '1';
		when LDA_A =>
			alu_op <= "101";
			alu_in <= '1';
			acc_wr <= '1';
			flg_wr <= '1';
		when ADD_A =>
			alu_op <= "000";
			alu_in <= '1';
			acc_wr <= '1';
			flg_wr <= '1';
		when SUB_A =>
			alu_op <= "001";
			alu_in <= '1';
			acc_wr <= '1';
			flg_wr <= '1';
		when AND_A =>
			alu_op <= "010";
			alu_in <= '1';
			acc_wr <= '1';
			flg_wr <= '1';
		when ORR_A =>
			alu_op <= "011";
			alu_in <= '1';
			acc_wr <= '1';
			flg_wr <= '1';
		when XOR_A =>
			alu_op <= "100";
			alu_in <= '1';
			acc_wr <= '1';
			flg_wr <= '1';
		when others =>
			null;
		end case;
	end process;

end Behavioral;

