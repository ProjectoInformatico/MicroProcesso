library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- pourquoi y'a 3bits pour le ctrl alu ?
-- la clock sur l'alu
-- le reset sur l'alu
-- comment on récupère les flags ?
-- travaille t'on sur des nombres négatif ?

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

    type alu_flags is record 
        C : STD_LOGIC;
        O : STD_LOGIC;
        N : STD_LOGIC;
        Z : STD_LOGIC;
    end record;

    signal flags : alu_flags;

begin
    S <= Sortie(7 downto 0);
    O <= flags.O;
    C <= flags.C;
    Z <= flags.Z;
    N <= '1' when Sortie = X"00" else '0';

    process(CLK)
    begin
        if rising_edge(CLK) then
            flags <= (others => '0');
            if RST = '0' then
                Sortie <= (others => '0');
            else 
                case Ctrl_Alu is
                    when others => -- 0.Defaut S=A
                        Sortie <= "0" & A;
                    --when "001" => -- 1.Addition
                    --    Temp <= (unsigned("0" & A) + unsigned(B));
                    --when "010" => -- 2.Soustraction
                    --    Temp <= ("0" & A) - B;
                end case;

            end if;
        end if;
    end process;

end architecture ; -- Behavioral of alu
