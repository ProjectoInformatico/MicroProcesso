library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity bank_register is

	generic(
		REG_SIZE : positive := 8;
		REG_COUNT : positive := 16
	);

	port(
		clk : in std_logic;
		rst : in std_logic;
		w : in std_logic;
		data : in unsigned(REG_SIZE-1 downto 0);
		reg_a : in integer range 0 to REG_COUNT-1;
		reg_b : in integer range 0 to REG_COUNT-1;
		reg_w : in integer range 0 to REG_COUNT-1;
		qa : out unsigned(REG_SIZE-1 downto 0);
		qb : out unsigned(REG_SIZE-1 downto 0)
	);
end entity ; -- bank_register

architecture behavioral of bank_register is

	subtype reg is unsigned(REG_SIZE-1 downto 0);
	type reg_list is array(0 to REG_COUNT) of reg;
	signal regs : reg_list := (1=>x"10", others=>x"00");

begin

	qa <= data when w = '1' and reg_a = reg_w else regs(reg_a); -- when read and write on same register
	qb <= data when w = '1' and reg_b = reg_w else regs(reg_b);

	bank_register_main : process( clk )
	begin
		if rising_edge(clk) then

			if rst = '0' then -- reset everything
				regs <= (others => (others => '0'));
			elsif w = '1' then -- write data on register reg_w
				regs(reg_w) <= data;
			end if ;

		end if ;
	end process ; -- bank_register_main

end architecture ; -- behavioral
