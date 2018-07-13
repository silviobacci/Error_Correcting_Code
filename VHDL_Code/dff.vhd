library IEEE;
use IEEE.std_logic_1164.all;

entity dff is
	port(
		clk		: in std_ulogic;
		rst		: in std_ulogic;
		d		: in std_ulogic;
		q		: out std_ulogic
	);
end dff;

architecture rtl of dff is
begin
	dff_p : process(clk, rst) 
	begin
		if rst = '1' then
			q <= '0';
		elsif (clk = '1' and clk'event) then
			q <= d;
		end if;	
	end process;
	
end rtl;

