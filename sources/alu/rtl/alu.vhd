library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
port(
    CLK : in STD_LOGIC ;
    RST : in STD_LOGIC ;
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
    S <= Sortie(7 downto 0);
    O <= Sortie(8);
    C <= '1' when Sortie(8) = '1' and Ctrl_Alu = "001" else '0';
    N <= '1' when Sortie(8) = '1' and Ctrl_Alu = "010" else '0';
    Z <= '1' when Sortie = X"00" else '0';

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '0' then
                Sortie <= (others => '0');
            else 
                case Ctrl_Alu is
                    when "001" => -- 1.Addition
                        Sortie <= ("0" & A) + B;
                    when "010" => -- 2.Soustraction
                        Sortie <= ("0" & A) - B;
                        
                    when others => -- 0.Defaut S=A
                        Sortie <= "0" & A;
                end case;

            end if;
        end if;
    end process;

end architecture ; -- Behavioral of alu
