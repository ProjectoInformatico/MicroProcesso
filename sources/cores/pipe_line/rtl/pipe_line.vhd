library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity pipe_line is

    generic(
        SIZE : positive := 8
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

end entity ; -- pipe_line

architecture Behavioral of pipe_line is

begin
    
    pipe_line_main : process( clk )
    begin
        if rising_edge(clk) then
            A_out <= A_in;
            B_out <= B_in;
            C_out <= C_in;
            OP_out <= OP_in;
        end if ;
    end process ; -- pipe_line_main

end architecture ; -- Behavioral of pipe_line
