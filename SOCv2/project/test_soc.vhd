--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:57:32 08/19/2018
-- Design Name:   
-- Module Name:   /home/ise/Desktop/SOCv3/test_soc.vhd
-- Project Name:  SOCv3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: soc
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_soc IS
END test_soc;
 
ARCHITECTURE behavior OF test_soc IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT soc
    PORT(
         clk50 : IN  std_logic;
         rst1 : IN  std_logic;
         rst2 : IN  std_logic;
         prog : IN  std_logic;
         ready : OUT  std_logic;
         ss_p : IN  std_logic;
         sck_p : IN  std_logic;
         si_p : IN  std_logic;
         so_p : OUT  std_logic;
         ss_r : OUT  std_logic;
         sck_r : OUT  std_logic;
         si_r : OUT  std_logic;
         so_r : IN  std_logic;
         rx : IN  std_logic;
         tx : OUT  std_logic;
         pwmpin : OUT  std_logic;
         gpiop : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk50 : std_logic := '0';
   signal rst1 : std_logic := '0';
   signal rst2 : std_logic := '0';
   signal prog : std_logic := '0';
   signal ss_p : std_logic := '0';
   signal sck_p : std_logic := '0';
   signal si_p : std_logic := '0';
   signal so_r : std_logic := '0';
   signal rx : std_logic := '0';

	--BiDirs
   signal gpiop : std_logic_vector(7 downto 0);

 	--Outputs
   signal ready : std_logic;
   signal so_p : std_logic;
   signal ss_r : std_logic;
   signal sck_r : std_logic;
   signal si_r : std_logic;
   signal tx : std_logic;
   signal pwmpin : std_logic;

   -- Clock period definitions
   constant clk50_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: soc PORT MAP (
          clk50 => clk50,
          rst1 => rst1,
          rst2 => rst2,
          prog => prog,
          ready => ready,
          ss_p => ss_p,
          sck_p => sck_p,
          si_p => si_p,
          so_p => so_p,
          ss_r => ss_r,
          sck_r => sck_r,
          si_r => si_r,
          so_r => so_r,
          rx => rx,
          tx => tx,
          pwmpin => pwmpin,
          gpiop => gpiop
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk50_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
