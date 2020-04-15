function [ liste, ind1Dto2D, ind2Dto1D ] = getListOfImage3D( image3d, good )
[Mx,My,Mz]=size(image3d);
nbPatches=sum(sum(good));
liste = zeros(nbPatches,Mz);
ind1Dto2D=zeros(nbPatches,2);
ind2Dto1D=zeros(Mx,My);
ind=0;
for i=1:Mx
    for j=1:My
        if good(i,j)
            ind=ind+1;
            ind1Dto2D(ind,1)=i;
            ind1Dto2D(ind,2)=j;
            ind2Dto1D(i,j)=ind;
            temp=image3d(i,j,:);
            liste(ind,:)=reshape(temp,[1,Mz]);
        end
    end
end

end

