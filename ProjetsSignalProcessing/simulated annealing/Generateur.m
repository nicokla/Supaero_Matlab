function A=Generateur(n,p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cette fonction g ́n`re un probl`me de test en g ́n ́rant %
% une matrice binaire carr ́e de taille n dont les termes %
% diagonaux sont  ́gaux ` 1 et dont les termes rectangle %
% sont al ́atoires, ind ́pendants et  ́gaux ` 1 avec la %
% probabilit ́ p. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A_1 = eye(n);
A_2 = rand(n,n);
A_3 = (1-p)*ones(n);
A = max(A_1,A_3<A_2);


end

