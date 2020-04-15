function [ doa_music, angles, normes, angles_all, normes_all ] = rootMusic( En, d, N, P_assumed )

a = zeros(2*N-1,1); 
W = En*En';
for n=0:N-1
    a(N+n) = sum(diag(W,-n));
    a(N-n) = conj(a(N+n));
end  
ra = roots(a);
rb = ra(abs(ra)<1);
[~,I] = sort(abs(abs(rb)-1));
doa_music = asin(angle(rb(I(1:P_assumed)))/(2*pi*d))*180/pi;
doa_music = sort(doa_music);
angles=asin(angle(rb)/(2*pi*d))*180/pi;
normes=abs(rb);
angles_all=asin(angle(ra)/(2*pi*d))*180/pi;
normes_all=abs(ra);

end

