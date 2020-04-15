function [ doa_mode, angles, normes ] = mode( Es, P_assumed, N, d )

W2 = Es*Es';
omega=zeros(P_assumed+1);
for aa=1:P_assumed+1
    for cc=1:P_assumed+1
        vv=diag(W2,aa-cc);
        t=min(aa,cc);
        omega(P_assumed+2-aa,P_assumed+2-cc)=sum(vv(t:t+N-P_assumed-1));
    end
end
[V,D]=eig(omega);
%[lambda,I]=min(diag(D)); % ordre croissant --> inutile d'utiliser min
b=V(:,1);
ra3=roots(b);

angles=asin(angle(ra3)/(2*pi*d))*180/pi;
normes=abs(ra3);

doa_mode = sort(angles);

%scatter(asin(angle(ra3)/(2*pi*d))*180/pi,abs(ra3), 'xb');

end

