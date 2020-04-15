function [ P_music ] = spectralMusic( En, nfft, N )
    %P_music = 1./(N-sum((abs(fftshift(fft(Es,nfft))).^2).'));
    P_music = 1./(sum((abs(fftshift(fft(En,nfft))).^2).'));
end

