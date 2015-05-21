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
		rout_rom : out unsigned(WORD_SIZE-1 downto 0) := (others => '0')
	);
end entity ; -- rom

architecture behavioral of rom is

	subtype word is unsigned(WORD_SIZE-1 downto 0);
	type word_list is array(0 to WORD_COUNT-1) of word;
	signal words : word_list := (
		0 => x"06001000", -- AFC R0 0x10
		1 => x"00000000", -- NOP
		2 => x"00000000", -- NOP
		3 => x"00000000", -- NOP
		4 => x"08000000", -- STORE R0 @0
		5 => x"06010100", -- APC R1 0x01
		6 => x"00000000", -- NOP
		7 => x"00000000", -- NOP
		8 => x"00000000", -- NOP
		9 => x"01000001", -- ADD R0 R0 R1

		others => x"00000000");

begin

	rom_main : process( clk )
	begin
		if rising_edge(clk) then
			rout_rom <= words(addr);
		end if ;
	end process ; -- rom_main

end architecture ; -- behavioral
