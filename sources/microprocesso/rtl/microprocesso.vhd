library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity microprocesso is
    port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC
    );
end microprocesso;

architecture Behavioral of microprocesso is

    component rom
        generic(
            WORD_COUNT : positive;
            WORD_SIZE : positive
        );
        port(
            clk : in std_logic;
            addr : in integer range 0 to WORD_COUNT-1;
            rout_rom : out unsigned(WORD_SIZE-1 downto 0)
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

    component bank_register
        generic(
            REG_SIZE : positive;
            REG_COUNT : positive
        );
        port(
            clk : in std_logic;
            rst : in std_logic;
            w : in std_logic;
            data : in unsigned(REG_SIZE-1 downto 0);
            reg_a : in integer range 0 to REG_COUNT-1;
            reg_b : in integer range 0 to REG_COUNT-1;
            reg_w : in integer range 0 to REG_COUNT-1;
            qa : out unsigned(REG_SIZE-1 downto 0);
            qb : out unsigned(REG_SIZE-1 downto 0)
        );
    end component;

    -- Constants
    constant INSTRUCTION_SIZE : integer := 32;
    constant ROM_SIZE : integer := 256;
    constant REG_SIZE : integer := 8;
    constant REG_COUNT : integer := 16;

    -- Constants with opcode
    constant OP_ADD : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) := X"01";
    constant OP_MUL : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) := X"02";
    constant OP_SOU : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) := X"03";
    constant OP_DIV : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) := X"04";
    constant OP_COP : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) := X"05";
    constant OP_AFC : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) := X"06";
    constant OP_LOAD : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) := X"07";
    constant OP_STORE : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) := X"08";

    -- Cablage avec des records
    type out_pipe_line is record
        A : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) ;
        B : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) ;
        C : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) ;
        OP : unsigned(INSTRUCTION_SIZE/4 -1 downto 0) ;
    end record;

    -- Instanciation
    signal instruction_pointer : integer := 0;
    signal out_rom : unsigned(INSTRUCTION_SIZE-1 downto 0);
    signal out_lidi, out_diex, out_exmem, out_memre : out_pipe_line;
    signal lc : std_logic := '1';
    signal mux_qa : unsigned(REG_SIZE-1 downto 0);
    signal mux_cop : unsigned(REG_SIZE-1 downto 0);
begin
    -- Composants
    rom1 : rom
    generic map(ROM_SIZE,INSTRUCTION_SIZE)
    port map(clk,instruction_pointer,out_rom);

    lidi : pipe_line
    generic map(INSTRUCTION_SIZE/4)
    port map(
        clk => clk,
        OP_in => out_rom(31 downto 24),
        A_in => out_rom(23 downto 16),
        B_in => out_rom(15 downto 8),
        C_in => out_rom(7 downto 0),
        A_out => out_lidi.A,
        B_out => out_lidi.B,
        C_out => out_lidi.C,
        OP_out => out_lidi.OP       
    );

    bank_register1: bank_register
    generic map(REG_SIZE,REG_COUNT)
    port map(
        clk => clk,
        rst => rst,
        w => lc,
        reg_w => to_integer(out_memre.A),
        reg_a => to_integer(out_lidi.B),
        reg_b => 0,
        qa => mux_qa,
        data => out_memre.B
    );

    mux_cop <= mux_qa when out_lidi.op = OP_COP else out_lidi.B;

    diex : pipe_line
    generic map(INSTRUCTION_SIZE/4)
    port map(
        clk => clk,
        OP_in => out_lidi.OP,
        A_in => out_lidi.A,
        B_in => mux_cop,
        C_in => (others =>'0'),
        A_out => out_diex.A,
        B_out => out_diex.B,
        OP_out => out_diex.OP
    );

    exmem : pipe_line
    generic map(INSTRUCTION_SIZE/4)
    port map(
        clk => clk,
        OP_in => out_diex.OP,
        A_in => out_diex.A,
        B_in => out_diex.B,
        C_in => (others =>'0'),
        A_out => out_exmem.A,
        B_out => out_exmem.B,
        OP_out => out_exmem.OP
    );

    memre : pipe_line
    generic map(INSTRUCTION_SIZE/4)
    port map(
        clk => clk,
        OP_in => out_exmem.OP,
        A_in => out_exmem.A,
        B_in => out_exmem.B,
        C_in => (others =>'0'),
        A_out => out_memre.A,
        B_out => out_memre.B,
        OP_out => out_memre.OP
    );

    lc <= '1' when out_memre.OP = OP_AFC or out_memre.OP = OP_COP else '0';

end Behavioral;
