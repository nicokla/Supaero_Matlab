function [Sabs, Sangle, SabsInteresting, SangleInteresting] = fftPerso( s,T_e,N_reel )
N=length(s);
if nargin==2
    N_reel=N;
end
[~, ~, ~, ~, indicesNonNegative] = paramFourier( T_e, N );
S = fftshift(fft(s))/N_reel;
Sabs = abs(S);
Sangle = angle(S);
SabsInteresting = 2*Sabs(indicesNonNegative);
SangleInteresting = Sangle(indicesNonNegative);
end

