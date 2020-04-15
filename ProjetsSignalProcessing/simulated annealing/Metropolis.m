function [Xout, Xout_1, Xout_0,Nout] = Metropolis(n, n_t, A, T,Xin, Xin_1, Xin_0, Nin)
    X = Xin;
    Xout_1 = Xin_1;
    Xout_0 = Xin_0;

    % Definition d'un voisin :
    i_1 = ceil(n_t*rand);
    i_0 = ceil((n-n_t)*rand);
    X(Xin_1(i_1)) = 0 ;
    X(Xin_0(i_0)) = 1 ;
    
    % Mesure de performance :
    N = sum(min(A*X,1));
    if N>Nin+T*log(rand)
        Xout=X;
        Xout_1(i_1) = Xin_0(i_0) ;
        Xout_0(i_0) = Xin_1(i_1) ;
        Nout=N;
    else
        Xout=Xin;
        Nout=Nin;
    end
end

