library IEEE;  
use IEEE.numeric_std.all;
use IEEE.STD_logic_1164.all;	 

entity tb_ENCODER is 

end tb_ENCODER;			  

architecture beh of tb_ENCODER is   

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

	-- Creazione di alcuni segnali che saranno l'input di encoder, clock e reset
	signal	iw_tb	: std_ulogic_vector(11 downto 1);  
	signal	cw_tb	: std_ulogic_vector(16 downto 1); 

begin 
	
	i_DUT1 : ECC
	port map(				 
		iw		=>	iw_tb,
		ow		=> 	cw_tb
	);	
	
	-- L'input del decoder non è collegato all'output del encoder
	-- perchè vogliamo vedere se il decoder è in grado di correggere errori che metteremo noi.
	i_DUT2 : DECODER
	port map(				
		iw		=>	cw_tb,
		cw		=> 	open
	);
	
	
	drive_p: process
	begin 
		
		-- Test 1
		iw_tb <= "01101010011";
		-- Output corretto: 1011010100011111
		
		-- Test 2
		wait for 150 us;	
		iw_tb <= "00101010011";	   
		-- Output corretto: 1001010110010101
		
		
		-- Test 3
		wait for 150 us;	
		iw_tb <= "01101010111"; 
		-- Output corretto: 0011010100110101
		wait;
	end process;

end beh;			  