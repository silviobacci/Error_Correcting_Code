library IEEE;
use IEEE.std_logic_1164.all;

entity regN is
	generic (Nbit : positive := 8);
	port(
		clk		: in std_ulogic;
		rst		: in std_ulogic;
		d		: in std_ulogic_vector(Nbit - 1 downto 0);
		q		: out std_ulogic_vector(Nbit -1 downto 0)
	);
end regN;

architecture rtl of regN is
component dff is
	port(
		clk		: in std_ulogic;
		rst		: in std_ulogic;
		d		: in std_ulogic;
		q		: out std_ulogic
	);
end component;

begin
gen_label : for i in 0 to Nbit - 1 generate
	dffX : dff
	port map(
		clk	=> clk,
		rst => rst,	
		d   => d(i),
		q   => q(i)
	);
end generate;	
end rtl;
