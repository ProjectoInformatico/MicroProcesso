library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity ram is

	generic(
		WORD_COUNT : positive := 256;
		WORD_SIZE : positive := 8
	);

	port(
		clk : in std_logic;
		rst : in std_logic;
		rw : in std_logic;
		addr : in integer range 0 to WORD_COUNT-1;
		rin_ram : in unsigned(WORD_SIZE-1 downto 0) ;
		rout_ram : out unsigned(WORD_SIZE-1 downto 0)
	);
end entity ; -- ram

architecture behavioral of ram is

	subtype word is unsigned(WORD_SIZE-1 downto 0);
	type word_list is array(0 to WORD_COUNT-1) of word;
	
	signal words : word_list := (others => x"f0");
	signal sortie : unsigned(WORD_SIZE-1 downto 0) ;

begin

	rout_ram <= sortie;

	ram_main : process( clk )
	begin
		if rising_edge(clk) then
			
			if rst = '0' then
				words <= (others => (others => '0'));
			elsif rw = '1' then -- lecture
				sortie <= words(addr);
			elsif rw = '0' then -- write
				words(addr) <= rin_ram;
			end if;

		end if ;
	end process ; -- ram_main

end architecture ; -- behavioral
