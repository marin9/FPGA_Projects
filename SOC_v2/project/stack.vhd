library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity stack is
port( clk: in std_logic;
		rst: in std_logic;
		st_ld: in std_logic;
		st_inc: in std_logic;
		reg_en: in std_logic;
		reg_ld: in std_logic;
		input: in std_logic_vector(9 downto 0);
		output: out std_logic_vector(9 downto 0));
end stack;

architecture Behavioral of stack is
	signal sel_reg: std_logic_vector(2 downto 0);
	signal sel_add: std_logic_vector(2 downto 0);
	signal sel_out: std_logic_vector(2 downto 0);
	
	type memory is array(0 to 7) of std_logic_vector(9 downto 0);
	signal regs: memory;
	
	signal s_input: std_logic_vector(9 downto 0);
	signal s_output: std_logic_vector(9 downto 0);
begin
	
	--select logic
	process(clk, rst) is
	begin
		if(rst='1') then
			sel_reg <= (others => '0');
		elsif(falling_edge(clk)) then
			sel_reg <= sel_out;
		end if;
	end process;
	
	with st_inc select sel_add <=
	sel_reg + 1 when '1',
	sel_reg -1 when others;
	
	with st_ld select sel_out <=
	sel_add when '1',
	sel_reg when others;
	
	
	--registers logic
	process(clk, rst, regs, sel_out, reg_en) is
	begin
		if(rst='1') then
			for i in 0 to 7 loop
				regs(i) <= (others => '0');
			end loop;
		elsif(falling_edge(clk) and reg_en='1') then
			regs(conv_integer(sel_out)) <= s_input;
		end if;
		s_output <= regs(conv_integer(sel_out));
	end process;

	with reg_ld select s_input <=
	input 		 when '1',
	s_output + 1 when others;
	
	output <= s_output;
	
end Behavioral;

