library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpt8 is
  port (CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        EN : in STD_LOGIC;
        SENS : in STD_LOGIC;
        LOAD : in STD_LOGIC;
        Din : in STD_LOGIC_VECTOR(7 downto 0);
        Dout : out STD_LOGIC_VECTOR(7 downto 0));
end cpt8;

architecture Behavioral of cpt8 is
  signal cpt : STD_LOGIC_VECTOR(7 downto 0);
begin

  Dout <= cpt;

  process(CLK)
  begin
    if (rising_edge(CLK)) then
      if (RST = '1') then
        cpt <= (others => '0');
      else
        if (EN = '1') then
          if (LOAD = '1') then
            cpt <= Din;
          else
            if (SENS = '0') then
              cpt <= cpt - '1';
            else
              cpt <= cpt + '1';
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

end Behavioral;
