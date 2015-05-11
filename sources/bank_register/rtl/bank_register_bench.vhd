library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity bank_register_bench is
end entity ; -- bank_register_bench

architecture behavioral of bank_register_bench is

	component bank_register

		generic(
			REG_SIZE : positive := 8;
			REG_COUNT : positive := 16
		);

		port(
			clk : in std_logic;
			rst : in std_logic;
			w : in std_logic;
			data : in std_logic_vector(REG_SIZE-1 downto 0);
			reg_a : in integer range 0 to REG_COUNT-1;
			reg_b : in integer range 0 to REG_COUNT-1;
			reg_w : in integer range 0 to REG_COUNT-1;
			qa : out std_logic_vector(REG_SIZE-1 downto 0);
			qb : out std_logic_vector(REG_SIZE-1 downto 0)
		);

	end component;

	constant period : time := 10 ns;
	constant reg_size : integer := 8;
	constant reg_count : integer := 16;

	signal clk : std_logic := '1';
	signal rst : std_logic := '0';
	signal w : std_logic := '0';
	signal data : std_logic_vector(REG_SIZE-1 downto 0);
	signal reg_a : integer range 0 to REG_COUNT-1 := 0;
	signal reg_b : integer range 0 to REG_COUNT-1 := 0;
	signal reg_w : integer range 0 to REG_COUNT-1 := 0;
	signal qa : std_logic_vector(REG_SIZE-1 downto 0);
	signal qb : std_logic_vector(REG_SIZE-1 downto 0);

begin

	uut: bank_register
		 generic map(reg_size, reg_count)
		 port map(clk, rst, w, data, reg_a, reg_b, reg_w, qa, qb);

	clk <= not clk after period/2;

	stim : process
	begin

		wait for period*2;
		rst <= '1';

		-- écriture dans le premier registre
		data <= X"0A";
		W <= '1';
		reg_w <= 1;
		wait for period;
		W <= '0';

		-- lecture de la valeur écrite
		wait for period;
		reg_a <= 1;

		-- Bypass D->Q
		wait for period;
		data<=X"FF";
		W <= '1';
		reg_w <= 1;
		wait for period;
		W <= '0';


		wait;
	end process ; -- stim

end architecture ; -- behavioral