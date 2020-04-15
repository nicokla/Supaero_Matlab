function [ doa_minNorm, angles, normes ] = minNorm( En, d, N, P_assumed )
W = En*En';
e1=zeros(N,1);
e1(1)=1;
%e1=rand(N,1); % ---> bad results, the others roots have a norm near 1 also
d_v=W*e1/(e1'*W*e1);

% equivalent to define d_v
% d_v=zeros(N,1);
% d_v(1)=1;
% g=Es(1,:)';
% Es_p=Es(2:end,:);
% d_v(2:end)=(-Es_p*g/(1-(g'*g)));

ra2 = roots(d_v);
[~,I2] = sort(abs(abs(ra2)-1));
doa_minNorm = asin(angle(ra2(I2(1:P_assumed)))/(2*pi*d))*180/pi;
doa_minNorm = sort(doa_minNorm);
angles=asin(angle(ra2)/(2*pi*d))*180/pi;
normes=abs(ra2);

%figure
%polar(asin(angle(ra)/(2*pi*d)),abs(ra),'b+');
%title('Root-MUSIC','FontSize',14);

% scatter(asin(angle(ra2)/(2*pi*d))*180/pi,abs(ra2), 'xb');
% hold on;
% scatter(asin(angle(rb)/(2*pi*d))*180/pi,abs(rb), 'xr');

end

