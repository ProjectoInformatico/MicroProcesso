library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity alu_bench is 
end entity ; -- alu_bench 

architecture behavior of alu_bench is 
    component alu

        generic(
            SIZE : positive
        );

        port(
            A : in unsigned(SIZE-1 downto 0) ;
            B : in unsigned(SIZE-1 downto 0) ;
            Ctrl_Alu : in std_logic_vector(2 downto 0);
            S : out unsigned(SIZE-1 downto 0) ;
            N : out STD_LOGIC;
            O : out STD_LOGIC;
            Z : out STD_LOGIC;
            C : out STD_LOGIC
        );
    end component;

    -- constants
    constant pause : time := 10 ns;
    constant op_size : integer := 8;

    signal A, B, S : unsigned(op_size-1 downto 0);
    signal Ctrl_Alu : std_logic_vector(2 downto 0) ;
    signal N, O, Z, C : std_logic;

begin

   uut: alu
        generic map(op_size)
        port map(A, B, Ctrl_Alu, S, N, O, Z, C);

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

        -- test de la multiplication
        wait for pause;
            Ctrl_Alu <= "011";
            A <= X"00";
            B <= X"FF";
            -- S must be 00 and Z

        wait for pause;
            A <= X"01";
            B <= X"02";
            -- S must be 2

        wait for pause;
            A <= X"80";
            B <= X"02";
            -- S must be 2

        -- this is the end
        wait for pause;
        wait;
    end process;

end architecture ; -- arch
