library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity microprocesso is
  port (CLK : in STD_LOGIC);

end microprocesso;

architecture Behavioral of microprocesso is
  -- Composants
  component rom
    generic(
      WORD_COUNT : positive;
      WORD_SIZE : positive
    );

    port(
      clk : in std_logic;
      addr : in integer range 0 to WORD_COUNT-1;
      rout_rom : out std_logic_vector(WORD_SIZE-1 downto 0)
    );
  end component;

  component pipe_line
    generic(
        SIZE : positive
    );
    port(
        clk : in std_logic;
        A_in : in unsigned(SIZE-1 downto 0) ;
        B_in : in unsigned(SIZE-1 downto 0) ;
        C_in : in unsigned(SIZE-1 downto 0) ;
        OP_in : in unsigned(SIZE-1 downto 0) ;
        A_out : out unsigned(SIZE-1 downto 0) ;
        B_out : out unsigned(SIZE-1 downto 0) ;
        C_out : out unsigned(SIZE-1 downto 0) ;
        OP_out : out unsigned(SIZE-1 downto 0) 
    );
  end component;

  -- Constants
  constant instruction_size : integer := 32;
  constant rom_size : integer := 256;

  -- Cablage avec des records
  type out_pipe_line is record
    A : unsigned(instruction_size/4 -1 downto 0) ;
    B : unsigned(instruction_size/4 -1 downto 0) ;
    C : unsigned(instruction_size/4 -1 downto 0) ;
    OP : unsigned(instruction_size/4 -1 downto 0) ;
  end record;

  -- Instanciation
  signal instruction_pointer : integer := 0;
  signal out_rom : std_logic_vector(instruction_size-1 downto 0);
  signal out_lidi : out_pipe_line;

begin
  -- Composants
  rom1 : rom generic map (rom_size,instruction_size) port map(clk,instruction_pointer,out_rom);
  lidi : pipe_line generic map (instruction_size/4) port map(
        clk => clk,
        OP_in =>X"00",
        A_in => X"00",
        B_in => X"00",
        C_in => X"00",
        A_out => out_lidi.A,
        B_out => out_lidi.B,
        C_out => out_lidi.C,
        OP_out => out_lidi.OP       
      );

end Behavioral;
