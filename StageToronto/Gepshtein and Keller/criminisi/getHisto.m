function v = getHisto( image,N,mini,maxi )
v=zeros(N,1);
[Mx,My]=size(image);
for i=1:Mx
    for j=1:My
        k=1+floor(N*(image(i,j)-mini)/(maxi-mini));
        k=min(N,k);%in case image(i,j)==maxi
        v(k)=v(k)+1;
    end
end
v=v/(Mx*My);