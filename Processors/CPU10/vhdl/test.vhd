LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_module
    PORT(
         clk50 : IN  std_logic;
         reset : IN  std_logic;
         pinout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk50 : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal pinout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk50_period : time := 80 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_module PORT MAP (
          clk50 => clk50,
          reset => reset,
          pinout => pinout
        );

   -- Clock process definitions
   clk50_process :process
   begin
		clk50 <= '0';
		wait for clk50_period/2;
		clk50 <= '1';
		wait for clk50_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
      wait for clk50_period*5.5;
		reset <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
