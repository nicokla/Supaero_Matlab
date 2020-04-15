function [X, X_1, X_0, N]=Init_alea(A,n_t);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % function [X, X_1, X_0, N]=Init_alea(A,n_t)
    % Cette fonction choisit aleatoirement un ensemble de n_t tests sous
    % forme d'un vecteur binaire (n,1) a partir de la matrice d'affectation
    % A et de deux vecteurs d'entiers indiquant les numeros d'ordre des
    % tests selectionnes et des tests non selectionnes. Enfin la performance N
    % est renvoyee
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [n p]=size(A);
    X=zeros(p,1);
    I=randperm(n);
    for j=0:n_t-1,
        X(I(n-j))=1;
    end;
    X_0=I(1:n-n_t);
    X_1=I((n-n_t+1):n);
    N=sum(min(A*X,1));
end

