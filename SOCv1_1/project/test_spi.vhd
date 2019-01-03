LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY test_spi IS
END test_spi;
 
ARCHITECTURE behavior OF test_spi IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ss : OUT  std_logic;
         sck : OUT  std_logic;
         si : OUT  std_logic;
         so : IN  std_logic;
         wr : OUT  std_logic;
         addr : OUT  std_logic_vector(11 downto 0);
         data : OUT  std_logic_vector(15 downto 0);
         fin : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal so : std_logic := '0';

 	--Outputs
   signal ss : std_logic;
   signal sck : std_logic;
   signal si : std_logic;
   signal wr : std_logic;
   signal addr : std_logic_vector(11 downto 0);
   signal data : std_logic_vector(15 downto 0);
   signal fin : std_logic;

   -- Clock period definitions
   constant clk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi PORT MAP (
          clk => clk,
          rst => rst,
          ss => ss,
          sck => sck,
          si => si,
          so => so,
          wr => wr,
          addr => addr,
          data => data,
          fin => fin
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

   -- Stimulus process
   stim_proc: process
   begin		
      

      wait;
   end process;

END;
