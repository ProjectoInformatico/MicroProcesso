library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity ram_bench is
end entity ; -- ram_bench

architecture behavioral of ram_bench is

	component ram

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

	end component;

	constant period : time := 10 ns;
	constant word_size : integer := 8;
	constant word_count : integer := 256;

	signal clk : std_logic := '1';
	signal rst : std_logic := '0';
	signal rw : std_logic := '1'; -- read by default
	signal addr : integer range 0 to WORD_COUNT-1;
	signal rin_ram : unsigned(WORD_SIZE-1 downto 0);
	signal rout_ram : unsigned(WORD_SIZE-1 downto 0);

begin

	uut: ram
		 generic map(word_count, word_size)
		 port map(clk, rst, rw, addr, rin_ram, rout_ram);

	clk <= not clk after period/2;

	stim : process
	begin

		wait for period;
		rst <= '1';
		addr <= 0;
		rw <= '0';
		rin_ram <= X"42";

		wait for period;
		rw <= '1';

		wait;
	end process ; -- stim

end architecture ; -- behavioral