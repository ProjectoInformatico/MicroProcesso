library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity program_counter_bench is 
end entity ; -- program_counter_bench 

architecture behavior of program_counter_bench is 
    component program_counter
        generic(
            ROM_SIZE : positive
        );
        port(
            selector : in std_logic_vector(1 downto 0);
            pc : in integer range 0 to ROM_SIZE-1;
            jump : in integer range 0 to ROM_SIZE-1;
            sortie : out integer range 0 to ROM_SIZE-1
        );
    end component;

    -- constants
    constant period : time := 10 ns;
    constant rom_size : integer := 8;

    signal selector : std_logic_vector(1 downto 0);
    signal pc,jump,sortie : integer range 0 to ROM_SIZE-1;

begin

   uut: program_counter
        generic map(rom_size)
        port map(selector, pc, jump, sortie);

    -- Stimulus process
    stim_proc: process
        begin    
        pc <= 0;
        wait for period;
        selector <= "00";
        pc <= 1;

        wait for period;
        selector <= "01";

        wait for period;
        selector <= "10";
        jump <= 3;

        -- this is the end
        wait for period;
        wait;
    end process;

end architecture ; -- arch
