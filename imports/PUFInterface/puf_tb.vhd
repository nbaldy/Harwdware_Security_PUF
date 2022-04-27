--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:46:16 09/20/2011
-- Design Name:   
-- Module Name:   D:/Projects/PUF/puf_tb.vhd
-- Project Name:  PUF
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: puf_control
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
 
ENTITY puf_tb IS
END puf_tb;
 
ARCHITECTURE behavior OF puf_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT puf_top
	port(
		clk: in std_logic;
		rst: in std_logic;
		rx: in std_logic;
		tx: out std_logic;
		puf_en: in std_logic;
		sw : in std_logic_vector(1 downto 0);
		led: out std_logic;
		switch: in std_logic_vector(2 downto 0)
		);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rx : std_logic := '0';
   signal sw : std_logic_vector(1 downto 0) := "00";
	signal puf_en : std_logic := '0';
	signal switch: std_logic_vector(2 downto 0) := "000";

 	--Outputs
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: puf_top PORT MAP (
          clk => clk,
          rst => rst,
          rx => rx,
          tx => tx,
          sw => sw,
			 puf_en => puf_en,
			 switch => switch
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
      -- hold reset state for 100 ns.
	  rst <= '1';
	  puf_en <= '1';
      wait for clk_period;
	  rst <= '0';

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
