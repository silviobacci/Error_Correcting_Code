library IEEE;				
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

-- Creazione del decoder che sarà utile nel testbench. Il decoder,
-- dovrà avere in input una parola da 16 bit, cioè la codifica, 
-- in output la parola originale su 11 bit (eventualmente corretta)
-- e 2 bit di errore per capire in quale situazione di errore ci troviamo.
entity DECODER is	
	port(							
		iw		:	in  std_ulogic_vector(16 downto 1);	  
		cw  	:	out std_ulogic_vector(11 downto 1);
		error	: 	out std_ulogic_vector(1 downto 0)
	);		   
end DECODER;

architecture rtl of DECODER is	
	-- Creazione dei segnali che rappresentano i bit di controllo e alcuni
    -- segnali intermedi nel circuito. 
	signal	p		: std_ulogic;
	signal	c		: std_ulogic_vector(4 downto 1);  
	signal	tmp_err	: std_ulogic_vector(1 downto 0);
	signal	tmp_cw	: std_ulogic_vector(16 downto 1); 
	signal	addr	: integer;
	
begin  	 							
	-- I bit di controllo sono: c1 = c(0), c2 = c(1), c3 = c(2), c4 = c(3)
	
	-- Il bit di controllo c1 è ottenuto dallo XOR dei bit p1, D1, D2, D4, D5, D7, D9 e D11	  
	-- Nella codifica questi sono i bit in poszione C1, C3, C5, C7, C9, C11, C13, C15
	c(1) <= iw(1) xor iw(3) xor iw(5) xor iw(7) xor iw(9) xor iw(11) xor iw(13) xor iw(15); 
	
	-- Il bit di controllo c2 è ottenuto dallo XOR dei bit p2, D1, D3, D4, D6, D7, D10 e D11  
	-- Nella codifica questi sono i bit in poszione C2, C3, C6, C7, C10, C11, C14, C15
	c(2) <= iw(2) xor iw(3) xor iw(6) xor iw(7) xor iw(10) xor iw(11) xor iw(14) xor iw(15); 
	
	-- Il bit di controllo c4 è ottenuto dallo XOR dei bit p4, D2, D3, D4, D8, D9, D10 e D11  
	-- Nella codifica questi sono i bit in poszione C4, C5, C6, C7, C12, C13, C14, C15
	c(3) <= iw(4) xor iw(5) xor iw(6) xor iw(7) xor iw(12) xor iw(13) xor iw(14) xor iw(15);  	
	
	-- Il bit di controllo c8 è ottenuto dallo XOR dei bit p8, D5, D6, D7, D8, D9, D10 e D11 
	-- Nella codifica questi sono i bit in poszione C8, C9, C10, C11, C12, C13, C14, C15
	c(4) <= iw(8) xor iw(9) xor iw(10) xor iw(11) xor iw(12) xor iw(13) xor iw(14) xor iw(15);  	 									
	
	-- Il bit di controllo p è ottenuto attraverso lo XOR di tutti i bit della parola Cx
	p  <= iw(1) xor iw(2) xor iw(3) xor iw(4) xor iw(5) xor iw(6) xor iw(7) xor iw(8) xor iw(9) xor iw(10) xor iw(11) xor iw(12) xor iw(13) xor iw(14) xor iw(15) xor iw(16);
	
	-- Calcolo dell'indirizzo del bit errato, ottenuto dalla decodifica decimale di c
	addr <=	TO_INTEGER(unsigned(c));  
	
	-- Identifichiamo i 4 casi in base ai valori della decodifica decimale di c e al valore di p
	tmp_err <= 	"00" when addr  = 0 and p = '0' else		-- Nessun errore
				"01" when addr /= 0 and p = '1' else		-- 1 errore 
				"10" when addr /= 0 and p = '0' else	    -- 2 errori
				"11";										-- 1 errore nel bit p0
	
	-- In caso di un errore, se il bit sbagliato è uno dei bit della parola andiamo a complementare il bit nella posizione indicata dalla 
	-- decodifica decimale di c (addr). Se il bit errato è il bit p0 correggiamo quel bit. In caso di 0 errori o errori non correggibili 
	-- non facciamo niente. Si distinguono i casi con addr >= 2 e addr = 1 per evitare che l'indice di accesso al vettore abbia un valore 
	-- minore di 1.
	tmp_cw <= 	iw(16 downto addr + 1) & not iw(addr) & iw((addr - 1) downto 1) when tmp_err = "01" and addr >= 2 else  -- Correzione del bit in posizione addr
				iw(16 downto addr + 1) & not iw(addr) when tmp_err = "01" and addr = 1 else			 					-- Correzione del bit in posizione addr
				not iw(16) & iw(15 downto 1) when tmp_err = "11" else													-- Correzione del bit p0
			   	iw;		 
	
	-- In uscita tolgo i bit di parità per vedere la parola decodificata 			   
	cw <= tmp_cw(15 downto 9) & tmp_cw(7 downto 5) & tmp_cw(3);   
	
	-- Abbiamo una variabile di appoggio perchè non poteva usare la variabile di uscita stessa.
	error <= tmp_err;
end rtl;	 
