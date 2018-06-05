LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.instr.ALL;


ENTITY test_cpu IS
END test_cpu;

ARCHITECTURE behavior OF test_cpu IS 
 
    COMPONENT cpu
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         wr : OUT  std_logic;
         rom_addr : OUT  std_logic_vector(11 downto 0);
         rom_data : IN  std_logic_vector(15 downto 0);
         address : OUT  std_logic_vector(7 downto 0);
         data_in : IN  std_logic_vector(7 downto 0);
         data_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rom_data : std_logic_vector(15 downto 0) := (others => '0');
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal wr : std_logic;
   signal rom_addr : std_logic_vector(11 downto 0);
   signal address : std_logic_vector(7 downto 0);
   signal data_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 40 ns;
 
 
	type ram is array(0 to 255) of std_logic_vector(7 downto 0);
	signal mem: ram;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          clk => clk,
          rst => rst,
          wr => wr,
          rom_addr => rom_addr,
          rom_data => rom_data,
          address => address,
          data_in => data_in,
          data_out => data_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	rst <= '1', '0' after clk_period*2;
 

   -- Stimulus ram
   process(clk, wr) is
	begin
		if(falling_edge(clk) and wr='1') then
			mem(conv_integer(address)) <= data_out;
		end if;
	end process;	
	data_in <= mem(conv_integer(address));

	-- Stimulus rom
--	with rom_addr select rom_data <=
--	LDA_K & x"007" when x"000",
--	STA   & x"000" when x"001",
--	LDA_K & x"00C" when x"002",
--	STA   & x"001" when x"003",
--	LDA_K & x"000" when x"004",
--	STA   & x"002" when x"005",
--
--	LDA_A & x"002" when x"006",
--	ADD_A & x"000" when x"007",
--	STA   & x"002" when x"008",
--	
--	LDA_A & x"001" when x"009",
--	SUB_K & x"001" when x"00A",
--	STA   & x"001" when x"00B",
--	
--	TST & NZ & x"00" when x"00C",
--	JMP   & x"006" when x"00D",
--	
--	JMP   & x"00E" when x"00E",
--	NOP   & x"000" when others;

	with rom_addr select rom_data <=
	LDA_K & x"0FF" when x"000",
	LDA_K & x"0FF" when x"001",
	LDA_K & x"0FF" when x"002",
	JMP   & x"003" when x"003",
	NOP	& x"000"	when others;
END;
