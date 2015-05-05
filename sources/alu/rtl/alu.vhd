library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
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
end entity ; -- alu

architecture Behavioral of alu is
    signal Sortie : std_logic_vector(8 downto 0);
begin

    Sortie <= ("0" & A) when Ctrl_Alu = "000" else -- simple copy
              ("0" & A) + B when Ctrl_Alu = "001" else -- addition
              ("0" & A) - B when Ctrl_Alu = "010" else "000000000"; -- substraction

    S <= Sortie(7 downto 0);
    Z <= '1' when Sortie(7 downto 0) = X"00" else '0';
    O <= '1' when A(7) = B(7) and Sortie(7) /= A(7) else '0'; -- quand on change de signe en add/sub/mult des nombres de même signe
    C <= Sortie(8);
    N <= Sortie(7);

end architecture ; -- Behavioral of alu
