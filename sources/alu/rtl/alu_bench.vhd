LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 

entity alu_bench is 
end entity ; -- alu_bench 

architecture behavior of alu_bench is 
  component alu 
  port(
    A : in std_logic_vector(7 downto 0) ;
    B : in std_logic_vector(7 downto 0) ;
    Ctrl_Alu : in std_logic_vector(2 downto 0);
    S : out std_logic_vector(7 downto 0) ;
    N : out STD_LOGIC;
    O : out STD_LOGIC;
    Z : out STD_LOGIC;
    C : out STD_LOGIC
    );
  end component;

   --Inputs
   signal Ctrl_Alu : std_logic_vector(2 downto 0) := (0 => '1', others => '0');
   signal A : std_logic_vector(7 downto 0) := (0 => '1', others => '0');
   signal B : std_logic_vector(7 downto 0) := ( others => '1');

  --Outputs
   signal S : std_logic_vector(7 downto 0);
   signal O : STD_LOGIC;
   signal C : STD_LOGIC;
   signal N : STD_LOGIC;
 
begin 
  -- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          Ctrl_Alu => Ctrl_Alu,
          A => A,
          B => B,
          S => S,
          O => O,
          C => C,
          N => N
        );
 

   -- Stimulus process
   stim_proc: process
   begin    
      -- hold reset state for 100 ns.
      
      wait;
   end process;

end architecture ; -- arch