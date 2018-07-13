function [word, error] = decoder(code)
    % Faccio il flip dell'array di bit per ragionare dal bit meno
    % significativo al più significativo
    code = fliplr(code);
    
    % Mi salvo i bit di parità della parola ricevuta
    p1 = code(1);
    p2 = code(2);
    p4 = code(4);
    p8 = code(8);
    p0 = code(16);
    
    % Creo un array con la parola ricevuta senza i bit di parità
    w_rec = [code(3) code(5:7) code(9:15)];

    % Calcolo i bit di controllo con lo xor dei bit richiesti
    c(1) = xor(xor(xor(xor(xor(xor(xor(w_rec(1),w_rec(2)),w_rec(4)),w_rec(5)),w_rec(7)),w_rec(9)),w_rec(11)),p1);
    c(2) = xor(xor(xor(xor(xor(xor(xor(w_rec(1),w_rec(3)),w_rec(4)),w_rec(6)),w_rec(7)),w_rec(10)),w_rec(11)),p2);
    c(3) = xor(xor(xor(xor(xor(xor(xor(w_rec(2),w_rec(3)),w_rec(4)),w_rec(8)),w_rec(9)),w_rec(10)),w_rec(11)),p4);
    c(4) = xor(xor(xor(xor(xor(xor(xor(w_rec(5),w_rec(6)),w_rec(7)),w_rec(8)),w_rec(9)),w_rec(10)),w_rec(11)),p8);
    p = xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(w_rec(1),w_rec(2)),w_rec(3)),w_rec(4)),w_rec(5)),w_rec(6)),w_rec(7)),w_rec(8)),w_rec(9)),w_rec(10)),w_rec(11)),p1),p2),p4),p8),p0);
    
    % Calcolo la codifica decimale dell'array dei bit di controllo
    addr = bi2de(c);
    
    if addr == 0 && p == 0
        error = [0 0];      % Nessun errore
    elseif addr ~= 0 && p == 1
        error = [0 1];      % 1 errore
        code(addr) = ~code(addr);
    elseif addr ~= 0 && p == 0
        error = [1 0];      % 2 errori
    else
        error = [1 1];      % Errore nel bit p0
        code(16) = ~code(16);
    end
    
    % In output avrò la parola originale eventualmente modificata
    word = [code(3) code(5:7) code(9:15)];
    
    % Faccio il flip dell'array di bit per ottenere l'output corretto
    word = fliplr(word);
end