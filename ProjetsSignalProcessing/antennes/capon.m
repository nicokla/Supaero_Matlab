function [ P_capon ] = capon( Rsmi, nfft, N )

%Capon
iRsmi = Rsmi\eye(N);
z = zeros(N,1);
z(1,1) = 0.5 * real(trace(iRsmi));
for n=1:N-1
   z(n+1,1) = sum(diag(iRsmi,-n));
end
%Real part of Fourier Transform of z
P_capon = 1./(2*real(fftshift(fft(z,nfft))));

end

