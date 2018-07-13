function code = encoder(word)
    % Faccio il flip dell'array di bit per ragionare dal bit meno
    % significativo al più significativo
    word = fliplr(word);
    
    % Calcolo i bit di parità attraverso lo xor dei bit necessari
    p1 = xor(xor(xor(xor(xor(xor(word(1),word(2)),word(4)),word(5)),word(7)),word(9)),word(11));
    p2 = xor(xor(xor(xor(xor(xor(word(1),word(3)),word(4)),word(6)),word(7)),word(10)),word(11));
    p4 = xor(xor(xor(xor(xor(xor(word(2),word(3)),word(4)),word(8)),word(9)),word(10)),word(11));
    p8 = xor(xor(xor(xor(xor(xor(word(5),word(6)),word(7)),word(8)),word(9)),word(10)),word(11));
    p0 = xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(word(1),word(2)),word(3)),word(4)),word(5)),word(6)),word(7)),word(8)),word(9)),word(10)),word(11)),p1),p2),p4),p8);
    
    % Creo la codifica dal meno significativo al più significativo
    code = [p1 p2 word(1) p4 word(2:4) p8 word(5:11) p0];
    
    % Faccio il flip dell'array di bit per ottenere l'output corretto
    code = fliplr(code);
end