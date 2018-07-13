library IEEE;				
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

-- Creazione dell' encoder che avrà in ingresso un parola da 11 bit,
-- in uscita una parola da 16 bit ed ovviamente clock e reset.
entity ECC is	
	port(					   
		iw	:	in  std_ulogic_vector(11 downto 1);
		ow  :	out std_ulogic_vector(16 downto 1)
	);		   
end ECC;

architecture rtl of ECC is		
	-- Creazione di un array di segnali che rappresentano i vari bit di parità 
	signal p : std_ulogic_vector(4 downto 0); 
	
begin  	
	-- I bit di parità sono: p0 = p(0), p1 = p(1), p2 = p(2), p4 = p(3), p8 = p(4)
	
	-- Il bit di parità p1 è ottenuto dallo XOR dei bit D1, D2, D4, D5, D7, D9 e D11	 
	p(1) <= iw(1) xor iw(2) xor iw(4) xor iw(5) xor iw(7) xor iw(9) xor iw(11);	
	
	-- Il bit di parità p2 è ottenuto dallo XOR dei bit D1, D3, D4, D6, D7, D10 e D11
	p(2) <= iw(1) xor iw(3) xor iw(4) xor iw(6) xor iw(7) xor iw(10) xor iw(11);	
	
	-- Il bit di parità p4 è ottenuto dallo XOR dei bit D2, D3, D4, D8, D9, D10 e D11
	p(3) <= iw(2) xor iw(3) xor iw(4) xor iw(8) xor iw(9) xor iw(10) xor iw(11); 
	
	-- Il bit di parità p8 è ottenuto dallo XOR dei bit D5, D6, D7, D8, D9, D10 e D11
	p(4) <= iw(5) xor iw(6) xor iw(7) xor iw(8) xor iw(9) xor iw(10) xor iw(11); 
	
	-- Il bit di parità p0 è ottenuto attraverso lo XOR di tutti i bit della parola Dx e dei bit di parità p1, p2, p4 e p8
	p(0) <= iw(1) xor iw(2) xor iw(3) xor iw(4) xor iw(5) xor iw(6) xor iw(7) xor iw(8) xor iw(9) xor iw(10) xor iw(11) xor p(1) xor p(2) xor p(3) xor p(4);
	
	
	-- In uscita mettiamo i bit nell'ordine richesto dalla codifica di Hamming, ossia
	-- dal più significativo a quello meno significativo abbiamo: 
	-- p0, D11, D10, D9, D8, D7, D6, D5, p8, D4, D3, D2, p4, D1, p2, p1
 	ow <= p(0) & iw(11 downto 5) & p(4) & iw(4 downto 2) & p(3) & iw(1) & p(2) & p(1);	
end rtl;	 
