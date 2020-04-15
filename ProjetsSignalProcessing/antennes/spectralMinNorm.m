function [ power ] = spectralMinNorm( En, d, N, P_assumed, nfft )
W = En*En';
e1=zeros(N,1);
e1(1)=1;
%e1=rand(N,1); % ---> bad results, the others roots have a norm near 1 also
d_v=W*e1;

power = 1./abs(fftshift(fft(d_v,nfft)));
end

