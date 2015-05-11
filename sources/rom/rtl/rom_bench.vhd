library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity rom_bench is
end entity ; -- rom_bench

architecture behavioral of rom_bench is

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

	constant period : time := 10 ns;
	constant word_size : integer := 32;
	constant word_count : integer := 256;

	signal clk : std_logic := '1';
	signal addr : integer range 0 to WORD_COUNT-1;
	signal rout_rom : std_logic_vector(WORD_SIZE-1 downto 0);

begin

	uut: rom
		 generic map(word_count, word_size)
		 port map(clk, addr, rout_rom);

	clk <= not clk after period/2;

	stim : process
	begin
		wait for period;
		addr <= 0;
		for i in 0 to 256 loop
			wait for period;
			addr <= i;
		end loop;

		wait;
	end process ; -- stim

end architecture ; -- behavioral