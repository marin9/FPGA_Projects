library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cpu is
port( clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		pc: out std_logic_vector(9 downto 0);
		instr: in std_logic_vector(12 downto 0);
		addr: out std_logic_vector(7 downto 0);
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0));
end cpu;

architecture Behavioral of cpu is
	component alu is
	port( in1: in std_logic_vector(7 downto 0);
			in2: in std_logic_vector(7 downto 0);
			op: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(7 downto 0);
			z: out std_logic;
			c: out std_logic);
	end component;

	component reg is
	generic(W: integer := 8);
	port( clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic;
			input: in std_logic_vector(W-1 downto 0);
			output: out std_logic_vector(W-1 downto 0));
	end component;

	component dec is
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
	end component;

	component ireg is
	port( clk: in std_logic;
			rst: in std_logic;
			input: in std_logic_vector(12 downto 0);
			output: out std_logic_vector(12 downto 0));
	end component;

	component stack is
	port( clk: in std_logic;
			rst: in std_logic;
			st_ld: in std_logic;
			st_inc: in std_logic;
			reg_en: in std_logic;
			reg_ld: in std_logic;
			input: in std_logic_vector(9 downto 0);
			output: out std_logic_vector(9 downto 0));
	end component;

	signal acc_out: std_logic_vector(7 downto 0);
	signal alu_in: std_logic_vector(7 downto 0);
	signal alu_out: std_logic_vector(7 downto 0);
	signal ir_data: std_logic_vector(7 downto 0);
	signal ir_instr: std_logic_vector(4 downto 0);
	signal ir_addr: std_logic_vector(9 downto 0);
	signal ir_out: std_logic_vector(12 downto 0);

	signal alu_op: std_logic_vector(2 downto 0);
	signal flgs_in: std_logic_vector(1 downto 0);
	signal flgs_out: std_logic_vector(1 downto 0);
	signal mux_addr: std_logic;
	signal mux_alu: std_logic;
	signal en_acc: std_logic;
	signal en_flg: std_logic;
	signal ir_rst: std_logic;
	signal irst: std_logic;
	signal pc_en: std_logic;
	signal pc_ld: std_logic;
	signal st_ld: std_logic;
	signal st_inc: std_logic;
	
begin
	
	alu_l: alu port map(acc_out, alu_in, alu_op, alu_out, flgs_in(0), flgs_in(1));
	acc: reg port map(clk, rst, en_acc, alu_out, acc_out);
	flg: reg generic map(2) port map(clk, rst, en_flg, flgs_in, flgs_out);
	
	output <= acc_out;
	
	with mux_alu select alu_in <=
	input when '0',
	ir_data when others;
	
	with mux_addr select addr <=
	(others => '0') when '0',
	ir_data when others;

	decoder: dec port map(
			ir_instr,
			flgs_out(0),
			flgs_out(1),
			mux_addr,
			mux_alu,
			alu_op,
			en_acc,
			en_flg,
			pc_en,
			pc_ld,
			st_ld,
			st_inc,
			ir_rst,
			wr);
	
	pc_stack: stack port map(clk, rst, st_ld, st_inc, pc_en, pc_ld, ir_addr, pc);
	
	ir: ireg port map(clk, irst, instr, ir_out);
	
	ir_data <= ir_out(7 downto 0);
	ir_addr <= ir_out(9 downto 0);
	ir_instr <= ir_out(12 downto 8);
	
	irst <= rst or ir_rst;

end Behavioral;

