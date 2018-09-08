library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity fifo is
port(	clk: in std_logic;
		rst: in std_logic;
		wr: in std_logic;
		rd: in std_logic;
		full: out std_logic;
		empty: out std_logic;
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0));
end fifo;

architecture Behavioral of fifo is
	type memory is array(0 to 15) of std_logic_vector(7 downto 0);
	signal data: memory;
	
	signal reg_pointer_rd, next_pointer_rd: std_logic_vector(3 downto 0);
	signal reg_pointer_wr, next_pointer_wr: std_logic_vector(3 downto 0);
	signal reg_empty, next_empty: std_logic;
	signal reg_full, next_full: std_logic;
	signal op: std_logic_vector(1 downto 0);
begin

	op <= wr & rd;
	
	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				data <= (others => (others => '0')); 
			elsif(wr='1' and reg_full='0') then
				data(conv_integer(reg_pointer_wr)) <= input;
			end if;
		end if;
	end process;
	

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				reg_pointer_rd <= (others => '0');
				reg_pointer_wr <= (others => '0');
				reg_empty <= '1';
				reg_full <= '0';
			else
				reg_pointer_rd <= next_pointer_rd;
				reg_pointer_wr <= next_pointer_wr;
				reg_empty <= next_empty;
				reg_full <= next_full;
			end if;
		end if;
	end process;


	process(op, reg_pointer_rd, reg_pointer_wr, reg_full, reg_empty) is
	begin
		next_full <= reg_full;
		next_empty <= reg_empty;
		next_pointer_rd <= reg_pointer_rd;
		next_pointer_wr <= reg_pointer_wr;
	
		case op is
		when "00" => --no op
			null;
		when "01" => --read
			if(reg_empty='0') then
				next_pointer_rd <= reg_pointer_rd + 1;
				next_full <= '0';
				if(reg_pointer_wr=(reg_pointer_rd+1)) then
					next_empty <= '1';
				end if;
			end if;
		when "10" => --write
			if(reg_full='0') then
				next_pointer_wr <= reg_pointer_wr + 1;
				next_empty <= '0';
				if(reg_pointer_rd=(reg_pointer_wr+1)) then
					next_full <= '1';
				end if;
			end if ;
		when others => --read&write
			next_pointer_wr <= reg_pointer_wr + 1;	
			next_pointer_rd <= reg_pointer_rd + 1;
		end case;
	end process;

	full <= reg_full;
	empty <= reg_empty;
	output <= data(conv_integer(reg_pointer_rd));

end Behavioral;