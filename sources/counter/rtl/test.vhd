library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity system is
  port (CLK : in STD_LOGIC;
        SW : in STD_LOGIC_VECTOR(7 downto 0);
        BT : in STD_LOGIC_VECTOR(4 downto 0);
        LEDS : out STD_LOGIC_VECTOR(7 downto 0));

end system;

architecture Behavioral of system is
  -- Composants
  component cpt8 Port(CLK : in STD_LOGIC;                       
                      RST : in STD_LOGIC;
                      EN : in STD_LOGIC;
                      SENS : in STD_LOGIC;
                      LOAD : in STD_LOGIC;
                      Din : in STD_LOGIC_VECTOR(7 downto 0);
                      Dout : out STD_LOGIC_VECTOR(7 downto 0));
  end component;

  -- Cablage avec des records
  type cpt8_in_out is record
    CLK : STD_LOGIC;                    
    RST : STD_LOGIC;
    EN : STD_LOGIC;
    SENS : STD_LOGIC;
    LOAD : STD_LOGIC;
    Din : STD_LOGIC_VECTOR(7 downto 0);
    Dout : STD_LOGIC_VECTOR(7 downto 0);
  end record;

  -- Instanciation
  signal cpt_con : cpt8_in_out;

begin
  -- Composants
  cpt : cpt8 port map(cpt_con.CLK,
                      cpt_con.RST,
                      cpt_con.EN,
                      cpt_con.SENS,
                      cpt_con.LOAD,
                      cpt_con.Din,
                      cpt_con.Dout);

  -- Connexion
  cpt_con.CLK <= BT(2);
  cpt_con.RST <= BT(0);
  LEDS <= cpt_con.Dout;
  cpt_con.Din <= SW;
  cpt_con.SENS <= '1';
  cpt_con.EN <= '1';
  cpt_con.LOAD <= BT(1);

end Behavioral;
