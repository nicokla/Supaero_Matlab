function v = getHisto2( image,N,mini,maxi,good )
% comme getHisto mais on ne compte pas les points qui ne sont pas connus
v=zeros(N+1,1);
[Mx,My]=size(image);
for i=1:Mx
    for j=1:My
        if(good(i,j))
            k=1+floor(N*(image(i,j)-mini)/(maxi-mini));
            v(k)=v(k)+1;
        end
    end
end
v(end-1)=v(end-1)+v(end);
v=v(1:(end-1));
v=v/sum(v);