function [ continuousValues, lbpLists, whereItsTrue ] =...
    computeLbpPointwise(imageGris, n, R, good)

[Mx,My]=size(imageGris);
imageGris2 = extendImageByConst( imageGris, R, 0 );
good2 = extendImageByConst( good, R, 0 );
[Mx2,My2]=size(imageGris2);
[Y2,X2] = meshgrid(1:My2,1:Mx2);
[Y,X] = meshgrid(1:My,1:Mx);
Y=Y+R;
X=X+R;
lbpLists=zeros(Mx,My,n);
continuousValues=zeros(Mx,My,n);
whereItsTrue=zeros(Mx,My,n);
for k=0:(n-1)
    Xq=X+R*cos(2*pi*k/n);
    Yq=Y+R*sin(2*pi*k/n);
    continuousValues(:,:,k+1) = interp2(Y2,X2,imageGris2,Yq,Xq);
    lbpLists(:,:,k+1) = continuousValues(:,:,k+1) >= imageGris;
    whereItsTrue(:,:,k+1)=interp2(Y2,X2,good2,Yq,Xq);
end
whereItsTrue=whereItsTrue>0.99;
lbpLists(~whereItsTrue)=0;
whereItsTrue=double(whereItsTrue);


