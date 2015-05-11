library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity alu is

    generic(
        SIZE : positive := 8
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

end entity ; -- alu

architecture Behavioral of alu is

    signal Sortie : unsigned(SIZE downto 0);
    signal Sortie_mul : unsigned(SIZE*2-1 downto 0);
begin

    Sortie <= ("0" & A) when Ctrl_Alu = "000" else -- simple copy
              ("0" & A) + B when Ctrl_Alu = "001" else -- addition
              ("0" & A) - B when Ctrl_Alu = "010" else -- substraction
              Sortie_mul(SIZE downto 0) when Ctrl_Alu = "011" else -- multiplication
              ("0" & A) / B when Ctrl_Alu = "100" else -- division
              (others => '0'); 


    Sortie_mul <= A * B when Ctrl_Alu = "011" else  (others => '0');

    S <= Sortie(SIZE-1 downto 0);
    Z <= '1' when Sortie(SIZE-1 downto 0) = 0 else '0';
    O <= '1' when A(SIZE-1) = B(SIZE-1) and Sortie(SIZE-1) /= A(SIZE-1) else '0'; -- quand on change de signe en add/sub/mult des nombres de même signe
    C <= Sortie(SIZE);
    N <= Sortie(SIZE-1);

end architecture ; -- Behavioral of alu
