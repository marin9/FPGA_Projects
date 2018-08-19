LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY test_dec IS
END test_dec;
 
ARCHITECTURE behavior OF test_dec IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dec
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         zero : IN  std_logic;
         carry : IN  std_logic;
         instr : IN  std_logic_vector(7 downto 0);
         wr : OUT  std_logic;
         wr_ir : OUT  std_logic;
         wr_mdr : OUT  std_logic;
         wr_acc : OUT  std_logic;
         wr_pc : OUT  std_logic;
         sel_alu : OUT  std_logic_vector(1 downto 0);
         sel_accin : OUT  std_logic_vector(1 downto 0);
         sel_addr : OUT  std_logic;
         sel_pid : OUT  std_logic;
         sel_pcin : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal zero : std_logic := '0';
   signal carry : std_logic := '0';
   signal instr : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal wr : std_logic;
   signal wr_ir : std_logic;
   signal wr_mdr : std_logic;
   signal wr_acc : std_logic;
   signal wr_pc : std_logic;
   signal sel_alu : std_logic_vector(1 downto 0);
   signal sel_accin : std_logic_vector(1 downto 0);
   signal sel_addr : std_logic;
   signal sel_pid : std_logic;
   signal sel_pcin : std_logic;

   -- Clock period definitions
   constant clk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dec PORT MAP (
          clk => clk,
          rst => rst,
          zero => zero,
          carry => carry,
          instr => instr,
          wr => wr,
          wr_ir => wr_ir,
          wr_mdr => wr_mdr,
          wr_acc => wr_acc,
          wr_pc => wr_pc,
          sel_alu => sel_alu,
          sel_accin => sel_accin,
          sel_addr => sel_addr,
          sel_pid => sel_pid,
          sel_pcin => sel_pcin
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
		wait for clk_period*3.5;
		rst <= '0';
		instr <= "11000001";
		zero <= '0';
		wait for clk_period*15;
		zero <= '1';
		wait for clk_period*5;
		zero <= '0';
		

      wait;
   end process;

END;
