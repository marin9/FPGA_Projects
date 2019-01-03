LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
--USE work.instructions.ALL;

 
ENTITY test_cpu IS
END test_cpu;
 
ARCHITECTURE behavior OF test_cpu IS 
    COMPONENT cpu
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         wr : OUT  std_logic;
         pc : OUT  std_logic_vector(9 downto 0);
         instr : IN  std_logic_vector(12 downto 0);
         addr : OUT  std_logic_vector(7 downto 0);
         input : IN  std_logic_vector(7 downto 0);
         output : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal instr : std_logic_vector(12 downto 0) := (others => '0');
   signal input : std_logic_vector(7 downto 0) := (others => '0');
 	--Outputs
   signal wr : std_logic;
   signal pc : std_logic_vector(9 downto 0);
   signal addr : std_logic_vector(7 downto 0);
   signal output : std_logic_vector(7 downto 0);
   -- Clock period definitions
   constant clk_period : time := 80 ns;
	
	type ram is array(0 to 255) of std_logic_vector(7 downto 0);
	signal mem: ram;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          clk => clk,
          rst => rst,
          wr => wr,
          pc => pc,
          instr => instr,
          addr => addr,
          input => input,
          output => output
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	-- RAM Simulation
	process(clk, wr) is
	begin
		if(rising_edge(clk) and wr='1') then
			mem(conv_integer(addr)) <= output;
		end if;
	end process;
	input <= mem(conv_integer(addr));
 
	-- Reset
	rst <= '1', '0' after clk_period*7/2;

   -- ROM Simulation 1
--	with pc select instr <=
--	ORRK   & x"00" when "0000000000",
--	TST_Z  & x"00" when "0000000001",
--	ADDK   & x"01" when "0000000010",
--	ADDK   & x"03" when "0000000011",
--	STA    & x"00" when "0000000100",
--	LDAK   & x"01" when "0000000101",
--	SUBA   & x"00" when "0000000110",
--	TST_NC & x"00" when "0000000111",
--	LDAK   & x"00" when "0000001000",
--	STA    & x"01" when "0000001001",
--	NOP    & x"00" when others;
	-- 0: 4, 1: -3
	
	-- ROM Simulation 2
--	with pc select instr <=
--	LDAK    & x"f0" when "0000000000",
--	CMPK    & x"03" when "0000000001",
--	TST_Z   & x"00" when "0000000010",
--	JMP&"01"& x"00" when "0000000011",
--	CMPK    & x"f0" when "0000000100",
--	TST_Z   & x"00" when "0000000101",
--	JMP&"01"& x"03" when "0000000110",
--	LDAK    & x"ff" when "0000000111",
--	STA     & x"00" when "0000001000",
--	JMP&"00"& x"09" when "0000001001",
--	
--	LDAK    & x"01" when "0100000000",
--	STA     & x"00" when "0100000001",
--	JMP&"01"& x"02" when "0100000010",
--	LDAK    & x"02" when "0100000011",
--	STA     & x"00" when "0100000100",
--	JMP&"01"& x"05" when "0100000101",
--	
--	NOP     & x"00" when others;
	-- 0: 2
	
	-- ROM Simulation 3
	--with pc select instr <=
	--LDAK    & x"09" when "0000000000",
	--CAL&"01"& x"00" when "0000000001",
	--STA     & x"00" when "0000000010",
	--CAL&"01"& x"02" when "0000000011",
	--STA     & x"01" when "0000000100",
	--CAL&"01"& x"0a" when "0000000101",
	--STA     & x"02" when "0000000110",
	--JMP&"00"& x"07" when "0000000111",
	--
	--LDAK    & x"01" when "0100000000",
	--RET     & x"00" when "0100000001",
	--LDAK    & x"09" when "0100000010",
	--RETK    & x"02" when "0100000011",
	--LDAK    & x"ff" when "0100000100",
	--STA     & x"00" when "0100000101",
	--
	--CAL&"11"& x"0a" when "0100001010",
	--RET     & x"00" when "0100001011",
	--
	--LDAK    & x"55" when "1100001010",
	--RETK    & x"77" when "1100001011",
	--
	--NOP     & x"00" when others;
	-- 0: 1, 1: 2, 2: 77
	
	
	-- ROM Simulation 4
	with pc select instr <=
	"01110" & x"05" when "0000000000",
	"00011" & x"ff" when "0000000001",
	"11100" & x"05" when "0000000010",
	"00011" & x"ff" when "0000000011",
	"11000" & x"04" when "0000000100",
	"01110" & x"00" when "0000000101",
	"01000" & x"07" when "0000000110",
	"00010" & x"09" when "0000000111",
	"00000" & x"00" when others;
END;
