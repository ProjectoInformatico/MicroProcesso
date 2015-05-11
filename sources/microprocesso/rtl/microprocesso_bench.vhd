--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:05:21 02/11/2015
-- Design Name:   
-- Module Name:   counter/rtl/microprocesso_bench.vhd
-- Project Name:  counter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: system
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This microprocessobench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under microprocesso.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the microprocessobench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY microprocesso_bench IS
END microprocesso_bench;
 
ARCHITECTURE behavior OF microprocesso_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT microprocesso
    PORT(
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: microprocesso PORT MAP (
          CLK => CLK
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
      
      -- insert stimulus here 

      wait;
   end process;

END;
