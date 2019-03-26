LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         wr : IN  std_logic;
         rd : IN  std_logic;
         busy : OUT  std_logic;
         input : IN  std_logic_vector(7 downto 0);
         output : OUT  std_logic_vector(7 downto 0);
         ss : OUT  std_logic;
         sc : OUT  std_logic;
         so : OUT  std_logic;
         si : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal wr : std_logic := '0';
   signal rd : std_logic := '0';
   signal input : std_logic_vector(7 downto 0) := (others => '0');
   signal si : std_logic := '0';

 	--Outputs
   signal busy : std_logic;
   signal output : std_logic_vector(7 downto 0);
   signal ss : std_logic;
   signal sc : std_logic;
   signal so : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          wr => wr,
          rd => rd,
          busy => busy,
          input => input,
          output => output,
          ss => ss,
          sc => sc,
          so => so,
          si => si
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	si_process :process
   begin
		si <= '1';
		wait for clk_period*2;
		si <= '0';
		wait for clk_period*2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';
      wait for clk_period*10;
		
		en <= '1';
		wait for clk_period;
		wait until busy='0';
		
		input <= "00000011";
		wr <= '1';
		wait for clk_period*20;
		wr <= '0';
		wait until busy='0';
		
		rd <= '1';
		wait for clk_period*2;
		wr <= '0';
		wait until busy='0';
		
		en <= '0';
      -- insert stimulus here 
      wait;
   end process;

END;
