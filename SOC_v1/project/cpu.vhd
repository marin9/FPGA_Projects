library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cpu is
port( clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		rom_addr: out std_logic_vector(11 downto 0);
		rom_data: in std_logic_vector(15 downto 0);
		address: out std_logic_vector(7 downto 0);
		data_in: in std_logic_vector(7 downto 0);
		data_out: out std_logic_vector(7 downto 0));
end cpu;

architecture Behavioral of cpu is
	component dec is
	port( instr: in std_logic_vector(5 downto 0);
			flags: in std_logic_vector(1 downto 0);
			alu_op: out std_logic_vector(2 downto 0);
			acc_wr: out std_logic;
			flg_wr: out std_logic;
			alu_in: out std_logic;
			pc_load: out std_logic;
			ir_rst: out std_logic;
			ram_wr: out std_logic);
	end component;
	
	component pc is
	generic(W: integer := 12);
	port( clk: in std_logic;
			rst: in std_logic;
			load: in std_logic;
			input: in std_logic_vector(W-1 downto 0);
			output: out std_logic_vector(W-1 downto 0));
	end component;
	
	component reg is
	generic(W: integer := 8);
	port( clk: in std_logic;
			rst: in std_logic;
			en: in std_logic;
			input: in std_logic_vector(W-1 downto 0);
			output: out std_logic_vector(W-1 downto 0));
	end component;
	
	component alu is
	port( in1: in std_logic_vector(7 downto 0);
			in2: in std_logic_vector(7 downto 0);
			opr: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(7 downto 0);
			flags: out std_logic_vector(1 downto 0));
	end component;


	signal acc_out: std_logic_vector(7 downto 0);
	signal alu_out: std_logic_vector(7 downto 0);
	signal alu_in: std_logic_vector(7 downto 0);
	signal flags_in: std_logic_vector(1 downto 0);
	signal flags_out: std_logic_vector(1 downto 0);
	signal ir_out: std_logic_vector(15 downto 0);
	
	signal alu_op: std_logic_vector(2 downto 0);
	signal acc_wr: std_logic;
	signal flg_wr: std_logic;
	signal alu_mux: std_logic;
	signal pc_load: std_logic;
	signal ir_rst: std_logic;
	signal ram_wr: std_logic;
	
	signal s_irrst: std_logic;
	
begin
	data_out <= acc_out;
	
	with alu_mux select alu_in <=
	data_in 				 when '1',
	ir_out(7 downto 0) when others;
	
	alu_l: alu port map(acc_out, alu_in, alu_op, alu_out, flags_in);	
	acc_reg: reg port map(clk, rst, acc_wr, alu_out, acc_out);	
	flags_reg: reg generic map(2) port map(clk, rst, flg_wr, flags_in, flags_out);
	
	decoder: dec port map(ir_out(15 downto 10), 
								 flags_out,
								 alu_op,
								 acc_wr,
								 flg_wr,
								 alu_mux,
								 pc_load,
								 ir_rst,
								 wr);
	
	s_irrst <= rst or ir_rst;
	ir_reg: reg generic map(16) port map(clk, s_irrst, '1', rom_data, ir_out);
	
	address <= ir_out(7 downto 0);
			
	pc_reg: pc generic map(12) port map(clk, rst, pc_load, ir_out(11 downto 0), rom_addr);

end Behavioral;

