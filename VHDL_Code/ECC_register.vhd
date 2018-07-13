library IEEE;				
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

-- Creazione dell' encoder che avrà in ingresso un parola da 11 bit,
-- in uscita una parola da 16 bit ed ovviamente clock e reset.
entity ECC_register is	
	port(					   
		iw	:	in  std_ulogic_vector(11 downto 1);
		ow  :	out std_ulogic_vector(16 downto 1);
		clk	: 	in std_ulogic;
		rst	: 	in std_ulogic
	);		   
end ECC_register;

architecture rtl of ECC_register is		
	-- Creo come componente un registro a Nbit bits
	component regN is
		generic (Nbit : positive := 11);
		port(
			clk		: in  std_ulogic;
			rst		: in  std_ulogic;
			d		: in  std_ulogic_vector(Nbit downto 1);
			q		: out std_ulogic_vector(Nbit downto 1)
		);
	end component;
	
	-- Creazione di un array di segnali che rappresentano i vari bit di parità,
	-- un array di bit in uscita dal registro in ingresso e un array di bit in 
	-- in ingresso al secondo registro.
	signal p 	: std_ulogic_vector(4 downto 0);
	signal din	: std_ulogic_vector(11 downto 1);
	signal dout	: std_ulogic_vector(16 downto 1);
	
begin  	 
	-- Registro inserito in ingresso alla rete per creare un percorso registro-logico-registro
	-- da utilizzare durante la sintesi.
	regIN : regN	
	generic map(Nbit => 11)
	port map(
		clk	=>	clk,
		rst => 	rst,
	   	d	=>	iw,
		q	=>	din
	);	
	
	-- Registro inserito in usicta dalla rete per creare un percorso registro-logico-registro
	-- da utilizzare durante la sintesi.
	regOUT : regN	 
	generic map(Nbit => 16)
	port map(
		clk	=>	clk,
		rst => 	rst,
	   	d	=>	dout,
		q	=>	ow
	);	
							   
	-- I bit di parità sono: p0 = p(0), p1 = p(1), p2 = p(2), p4 = p(3), p8 = p(4)
	
	-- Il bit di parità p1 è ottenuto dallo XOR dei bit D1, D2, D4, D5, D7, D9 e D11	 
	p(1) <= din(1) xor din(2) xor din(4) xor din(5) xor din(7) xor din(9) xor din(11);	
	
	-- Il bit di parità p2 è ottenuto dallo XOR dei bit D1, D3, D4, D6, D7, D10 e D11
	p(2) <= din(1) xor din(3) xor din(4) xor din(6) xor din(7) xor din(10) xor din(11);	
	
	-- Il bit di parità p4 è ottenuto dallo XOR dei bit D2, D3, D4, D8, D9, D10 e D11
	p(3) <= din(2) xor din(3) xor din(4) xor din(8) xor din(9) xor din(10) xor din(11); 
	
	-- Il bit di parità p8 è ottenuto dallo XOR dei bit D5, D6, D7, D8, D9, D10 e D11
	p(4) <= din(5) xor din(6) xor din(7) xor din(8) xor din(9) xor din(10) xor din(11); 
	
	-- Il bit di parità p0 è ottenuto attraverso lo XOR di tutti i bit della parola Dx e dei bit di parità p1, p2, p4 e p8
	p(0) <= din(1) xor din(2) xor din(3) xor din(4) xor din(5) xor din(6) xor din(7) xor din(8) xor din(9) xor din(10) xor din(11) xor p(1) xor p(2) xor p(3) xor p(4);
	
	
	-- In uscita mettiamo i bit nell'ordine richesto dalla codifica di Hamming, ossia
	-- dal più significativo a quello meno significativo abbiamo: 
	-- p0, D11, D10, D9, D8, D7, D6, D5, p8, D4, D3, D2, p4, D1, p2, p1
 	dout <= p(0) & din(11 downto 5) & p(4) & din(4 downto 2) & p(3) & din(1) & p(2) & p(1);	
end rtl;	 
