library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity microprocesso_bench is
end entity ; -- microprocesso_bench

architecture behavior of microprocesso_bench is

	component microprocesso
		port(
		    CLK : in STD_LOGIC;
		    RST : in STD_LOGIC
		);
	end component;

	constant period : time := 10 ns;

	signal clk : std_logic := '1';
	signal rst : std_logic := '0';

begin

	uut: microprocesso
	port map(clk, rst);

	clk <= not clk after period/2;

	stim : process
	begin
		wait for 100 ns;

		rst <= '1';
		wait for period*10;

		wait;
	end process ; -- stim

end architecture ; -- behavior
