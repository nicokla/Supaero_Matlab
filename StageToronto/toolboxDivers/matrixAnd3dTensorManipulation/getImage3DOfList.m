function [ image3D ] = getImage3DOfList( liste, ind2Dto1D )
% function [ liste, ind1Dto2D, ind2Dto1D ] = getListOfImage3D( image3d, good )
Mz=size(liste,2);
[Mx,My]=size(ind2Dto1D);
image3D = zeros(Mx,My,Mz);
for i=1:Mx
    for j=1:My
        k=ind2Dto1D(i,j,:);
        if k~=0
            image3D(i,j,:)=reshape(liste(k,:),[1 1 Mz]);
        end
    end
end