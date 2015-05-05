library ieee;
use ieee.std_logic_1164.all;


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
    signal Ctrl_Alu : std_logic_vector(2 downto 0);
    signal A : std_logic_vector(7 downto 0);
    signal B : std_logic_vector(7 downto 0);

    --Outputs
    signal S : std_logic_vector(7 downto 0);
    signal O : STD_LOGIC;
    signal C : STD_LOGIC;
    signal N : STD_LOGIC;
    signal Z : STD_LOGIC;
     
    -- constants
    constant pause : time := 50 ns;

begin 
  -- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          Ctrl_Alu => Ctrl_Alu,
          A => A,
          B => B,
          S => S,
          O => O,
          C => C,
          N => N,
          Z => Z
        );


    -- Stimulus process
    stim_proc: process
        begin    

        -- test de la copie de A
        wait for pause;
            Ctrl_Alu <= "000";
            A <= X"FF";
            -- N flag

        -- test de l'addition
        wait for pause;
            Ctrl_Alu <= "001";
            A <= X"01";
            B <= X"04";
            -- S must be 05 and no flagz.

        wait for pause;
            A <= X"FF";
            B <= X"01";
            -- S must be 00 and Z, C flag

        wait for pause;
            A <= X"7F";
            B <= X"7F";
            -- S must be FE and N, O flag

        wait for pause;
            A <= X"99";
            B <= X"BB";
            -- S must be 54 and C, O flag

        -- test de la soustraction
        wait for pause;
            Ctrl_Alu <= "010";
            A <= X"00";
            B <= X"FF";
            -- S must be 01 and C flag

        wait for pause;
            A <= X"FF";
            -- S must be 00 and Z, O flag

        wait for pause;
            A <= X"99";
            B <= X"BB";
            -- S must be DE and C, N flag

        -- this is the end
        wait for pause;
        wait;
    end process;

end architecture ; -- arch