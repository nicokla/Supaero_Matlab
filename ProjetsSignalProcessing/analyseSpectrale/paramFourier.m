function [F_e, t, freq, freqPositivesOuNulle, indicesNonNegative] = paramFourier( T_e, N )
    F_e = 1/T_e;
    T_max=(N-1)*T_e;
    t = 0:T_e:T_max;
    if(mod(N,2)==0) % cas dissymetrique autour de la frequence nulle
        % fftshift convention --> la frequence max est negative
        freqPositivesOuNulle = 0:1/(N*T_e):(1/(2*T_e)-1/(N*T_e)) ;
        freqNegatives = -1/(2*T_e):1/(N*T_e):-1/(N*T_e);
    else
        freqPositivesOuNulle = 0:1/(N*T_e):1/(2*T_e);
        freqNegatives = -freqPositivesOuNulle(end):1/(N*T_e):-1/(N*T_e);
    end
    freq = [freqNegatives freqPositivesOuNulle];
    indicesNonNegative = (length(freqNegatives)+1):length(freq);
end

