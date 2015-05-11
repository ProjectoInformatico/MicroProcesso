library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity rom is

	generic(
		WORD_COUNT : positive := 256;
		WORD_SIZE : positive := 32
	);

	port(
		clk : in std_logic;
		addr : in integer range 0 to WORD_COUNT-1;
		rout_rom : out std_logic_vector(WORD_SIZE-1 downto 0)
	);
end entity ; -- rom

architecture behavioral of rom is

	subtype word is std_logic_vector(WORD_SIZE-1 downto 0);
	type word_list is array(0 to WORD_COUNT-1) of word;
	signal words : word_list := (others => x"aaaaaaaa");

begin

	rom_main : process( clk )
	begin
		if rising_edge(clk) then
			rout_rom <= words(addr);
		end if ;
	end process ; -- rom_main

end architecture ; -- behavioral
