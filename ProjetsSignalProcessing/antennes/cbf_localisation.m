function [ P_cbf ] = cbf_localisation( N, K, Y, nfft )
P_cbf = fftshift(sum((abs(fft(Y,nfft)).^2).'))/(N^2)/K;
end

