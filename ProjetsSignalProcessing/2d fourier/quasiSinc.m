function [ x ] = quasiSinc( T, u , N)
    if(u==0)
        x=1;
    else
        x=1/(2*T+1)*sin(2*pi*u/N*(T+0.5))/sin(pi*u/N);
    end
end

