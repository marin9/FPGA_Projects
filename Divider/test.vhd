LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT divider
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         wr1 : IN  std_logic;
         wr2 : IN  std_logic;
         err : OUT  std_logic;
         rdy : OUT  std_logic;
         input : IN  std_logic_vector(3 downto 0);
         outQ : OUT  std_logic_vector(3 downto 0);
         outR : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal wr1 : std_logic := '0';
   signal wr2 : std_logic := '0';
   signal input : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal err : std_logic;
   signal rdy : std_logic;
   signal outQ : std_logic_vector(3 downto 0);
   signal outR : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: divider PORT MAP (
          clk => clk,
          rst => rst,
          wr1 => wr1,
          wr2 => wr2,
          err => err,
          rdy => rdy,
          input => input,
          outQ => outQ,
          outR => outR
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
      wait for 100 ns;	
		rst <= '0';
      wait for clk_period*2;

		input <= "1110";
		wr1 <= '1';
		wait for clk_period;
		wr1 <= '0';
		input <= "0011";
		wr2 <= '1';
		wait for clk_period;
		wr2 <= '0';
		
		
      -- insert stimulus here 

      wait;
   end process;

END;
