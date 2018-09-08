library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cpum8 is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: out std_logic;
		pid: out std_logic_vector(7 downto 0);
		pin: in std_logic_vector(7 downto 0);
		pout: out std_logic_vector(7 downto 0);
		addr: out std_logic_vector(12 downto 0);
		din: in std_logic_vector(7 downto 0);
		dout: out std_logic_vector(7 downto 0));
end cpum8;

architecture Behavioral of cpum8 is
	component dec is
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
	end component;
	
	component datapath is
	port(	clk: in std_logic;
			rst: in std_logic;
			zero: out std_logic;
			carry: out std_logic;
			instr: out std_logic_vector(7 downto 0);
			wr_ir: in std_logic; 
			wr_mdr: in std_logic;
			wr_acc: in std_logic; 
			wr_pc: in std_logic;
			sel_alu: in std_logic_vector(1 downto 0); 
			sel_accin: in std_logic_vector(1 downto 0);
			sel_addr: in std_logic; 
			sel_pid: in std_logic; 
			sel_pcin: in std_logic;
			pid: out std_logic_vector(7 downto 0);
			pin: in std_logic_vector(7 downto 0);
			pout: out std_logic_vector(7 downto 0);
			addr: out std_logic_vector(12 downto 0);
			din: in std_logic_vector(7 downto 0);
			dout: out std_logic_vector(7 downto 0));
	end component;


	signal zero: std_logic;
	signal carry: std_logic;
	signal instr: std_logic_vector(7 downto 0);
	signal wr_ir: std_logic; 
	signal wr_mdr: std_logic;
	signal wr_acc: std_logic; 
	signal wr_pc: std_logic;
	signal sel_alu: std_logic_vector(1 downto 0); 
	signal sel_accin: std_logic_vector(1 downto 0);
	signal sel_addr: std_logic; 
	signal sel_pid: std_logic; 
	signal sel_pcin: std_logic;
begin

	decoder: dec port map(clk, rst, zero, carry, instr, wr,
								wr_ir, wr_mdr, wr_acc, wr_pc,
								sel_alu, sel_accin, sel_addr, sel_pid, sel_pcin);	
								
	datap: datapath port map(clk, rst, zero, carry, instr,
									wr_ir, wr_mdr, wr_acc, wr_pc,
									sel_alu, sel_accin, sel_addr, sel_pid, sel_pcin,
									pid, pin, pout, addr, din, dout);

end Behavioral;

