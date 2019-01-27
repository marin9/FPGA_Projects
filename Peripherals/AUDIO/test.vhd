--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:27:03 01/27/2019
-- Design Name:   
-- Module Name:   /home/ise/Desktop/Audio/test.vhd
-- Project Name:  Audio
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: audio
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
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT audio
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         wr : IN  std_logic;
         data : IN  std_logic_vector(7 downto 0);
         full : OUT  std_logic;
         aout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal wr : std_logic := '0';
   signal data : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal full : std_logic;
   signal aout : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: audio PORT MAP (
          clk => clk,
          rst => rst,
          wr => wr,
          data => data,
          full => full,
          aout => aout
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

		
		data <= x"F0";
		wr <= '1';
		wait for  1 us;
		wr <= '0';
		wait for  1 us;
		
		data <= x"03";
		wr <= '1';
		wait for 1 us;
		wr <= '0';
		wait for  1 us;
		
		data <= x"F0";
		wr <= '1';
		wait for 1 us;
		wr <= '0';
		wait for  1 us;
		
		data <= x"03";
		wr <= '1';
		wait for  1 us;
		wr <= '0';
		wait for  1 us;
		
		data <= x"F0";
		wr <= '1';
		wait for  1 us;
		wr <= '0';
		wait for  1 us;

      wait;
   end process;

END;
