library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity pipe_line_bench is 
end entity ; -- pipe_line_bench 

architecture behavior of pipe_line_bench is 
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

    -- constants
    constant period : time := 10 ns;
    constant op_size : integer := 8;

    signal clk : std_logic := '1';
    signal A_in, B_in, C_in, OP_in : unsigned(op_size-1 downto 0);
    signal A_out, B_out, C_out, OP_out : unsigned(op_size-1 downto 0);

begin

   uut: pipe_line
        generic map(op_size)
        port map(clk, A_in, B_in, C_in, OP_in, A_out, B_out, C_out, OP_out);

    clk <= not clk after period/2;

    -- Stimulus process
    stim_proc: process
        begin    

        wait for period;
            A_in <= X"01";
            B_in <= X"0A";
            C_in <= X"F0";
            OP_in <= X"FF";
            -- N flag

        -- this is the end
        wait for period;
        wait;
    end process;

end architecture ; -- arch
