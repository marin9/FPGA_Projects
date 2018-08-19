library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity datapath is
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
end datapath;

architecture Behavioral of datapath is
	component alu is
	port(	inl: in std_logic_vector(7 downto 0);
			inr: in std_logic_vector(7 downto 0);
			sel: in std_logic_vector(1 downto 0);
			res: out std_logic_vector(7 downto 0);
			carry: out std_logic);
	end component;


	signal reg_acc, reg_ir, reg_mdr: std_logic_vector(7 downto 0);
	signal reg_pc: std_logic_vector(12 downto 0);
	signal aluout, accin: std_logic_vector(7 downto 0);
	signal pcin: std_logic_vector(12 downto 0);
begin

	with sel_accin select accin <=
	aluout	when "00",
	reg_mdr	when "01",
	pin		when others;
	
	pout <= reg_acc;
	dout <= reg_acc;
	
	comp_alu: alu port map(reg_acc, reg_mdr, sel_alu, aluout, carry);
	
	with reg_acc select zero <=
	'1' when "00000000",
	'0' when others;
	
	with sel_pid select pid <=
	"00000000" 	when '0',
	reg_mdr		when others;
	
	with sel_addr select addr <=
	reg_pc 			 when '0',
	"00000" & reg_mdr when others;
	
	with sel_pcin select pcin <=
	reg_pc + 1							when '0',
	reg_ir(4 downto 0) & reg_mdr	when others;
	
	instr <= reg_ir;
	

	ir: process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg_ir <= (others => '0');
			elsif(wr_ir='1') then
				reg_ir <= din;
			end if;
		end if;
	end process;
	
	mdr: process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg_mdr <= (others => '0');
			elsif(wr_mdr='1') then
				reg_mdr <= din;
			end if;
		end if;
	end process;
	
	cc: process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg_acc <= (others => '0');
			elsif(wr_acc='1') then
				reg_acc <= accin;
			end if;
		end if;
	end process;
	
	pc: process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg_pc <= (others => '0');
			elsif(wr_pc='1') then
				reg_pc <= pcin;
			end if;
		end if;
	end process;

end Behavioral;

