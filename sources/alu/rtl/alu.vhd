library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- pourquoi y'a 3bits pour le ctrl alu ?
-- la clock sur l'alu
-- le reset sur l'alu
-- comment on récupère les flags ?

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
    signal Temp : std_logic_vector(8 downto 0);
begin
    S<=Temp(7 downto 0);
    O <= Temp(8);
    C <= Temp(8);

    process(Ctrl_Alu)
    begin
        N <= '0';
        O <= '0';
        Z <= '0';
        C <= '0';
        case Ctrl_Alu is
            when "000" => -- Addition
                Temp <= (unsigned("0" & A) + unsigned(B));
            when others =>
                Temp <= (others => '0');
        end case;
    end process;

end architecture ; -- Behavioral of alu
