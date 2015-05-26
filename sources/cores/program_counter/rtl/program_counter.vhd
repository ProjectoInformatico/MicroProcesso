library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity program_counter is

	generic(
        ROM_SIZE : positive
	);

	port(
		selector : in std_logic_vector(1 downto 0);
        pc : in integer range 0 to ROM_SIZE-1;
        jump : in integer range 0 to ROM_SIZE-1;
        sortie : out integer range 0 to ROM_SIZE-1
	);
end entity ; -- program_counter

architecture behavioral of program_counter is

begin
	
	sortie <= 	pc + 1 when selector = "01" else 
				pc + jump when selector = "10" else
				pc; 

end architecture ; -- behavioral
