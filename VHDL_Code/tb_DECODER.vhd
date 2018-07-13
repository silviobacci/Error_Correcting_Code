library IEEE;  
use IEEE.numeric_std.all;
use IEEE.STD_logic_1164.all;	 

entity tb_DECODER is 

end tb_DECODER;			  

architecture beh of tb_DECODER is   

-- Creazione dei componenti encoder e decoder
component ECC 	
	port(					   
		iw	:	in  std_ulogic_vector(11 downto 1);
		ow  :	out std_ulogic_vector(16 downto 1)
	);		   
end component ECC; 

component DECODER is	
	port(							
		iw		:	in  std_ulogic_vector(16 downto 1);
		cw  	:	out std_ulogic_vector(11 downto 1);
		error	: 	out std_ulogic_vector(1 downto 0)
	);		   
end component DECODER;

	-- Creazione di alcuni segnali che saranno l'input di encoder e decoder,
	-- output del encoder, clock e reset
	signal	iw_tb1	: std_ulogic_vector(11 downto 1);  	 
	signal	iw_tb2	: std_ulogic_vector(16 downto 1);  
	signal	ow_tb	: std_ulogic_vector(16 downto 1); 

begin 								  
	
	i_DUT1 : ECC
	port map(			   
		iw		=>	iw_tb1,
		ow		=> 	ow_tb
	);	
	
	-- L'input del decoder non è collegato all'output del encoder
	-- perchè vogliamo vedere se il decoder è in grado di correggere errori che metteremo noi.
	i_DUT2 : DECODER
	port map(				
		iw		=>	iw_tb2,
		cw		=> 	open
	);
	
	
	drive_p: process
	begin 			
		
		-- Input corretto
		iw_tb1 <= "01101010011"; 
		iw_tb2 <= "1011010100011111";  
		
		-- Input con D8 errato
		wait for 150 us;	
		iw_tb2 <= "1011110100011111"; 
		
		-- Input con D8 e P2 errato
		wait for 150 us;	
		iw_tb2 <= "1011110100011101"; 
		
		-- Input con D6, D8 e P2 errato
		wait for 150 us;	
		iw_tb2 <= "1011111100011101"; 
		
		-- Input con D1, D6, D8 e P2 errato
		wait for 150 us;	
		iw_tb2 <= "1011111100011001"; 					
		
		-- Input con P0 errato	
		wait for 150 us;
		iw_tb2 <= "0011010100011111";   	 
		
		-- Input corretto	
		wait for 150 us;		  
		iw_tb2 <= "1011010100011111";  
		
		wait;
	end process;

end beh;			  