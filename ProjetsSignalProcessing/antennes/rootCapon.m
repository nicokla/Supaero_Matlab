function [ doa, angles, normes ] = rootCapon( Rsmi, d, N, P_assumed )
W = Rsmi\eye(N);
a = zeros(2*N-1,1); 
for n=0:N-1
    a(N+n) = sum(diag(W,-n));
    a(N-n) = conj(a(N+n));
end  
ra = roots(a);
rb = ra(abs(ra)<1);
[~,I] = sort(abs(abs(rb)-1));
doa = asin(angle(rb(I(1:P_assumed)))/(2*pi*d))*180/pi;
doa = sort(doa);
angles=asin(angle(rb)/(2*pi*d))*180/pi;
normes=abs(rb);

end

