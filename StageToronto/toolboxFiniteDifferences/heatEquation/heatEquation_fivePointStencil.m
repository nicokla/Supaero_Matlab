function [ imageAfterIHE ] = heatEquation_fivePointStencil( image3D, good )
% image3D=image;
% image3D=newCoords2;

bad=1-good;
[Mx,My,Mz]=size(image3D);

%%%%%%%%%%%%%%%%%%%%
% We construct the indices
im1Dto2DX=[];
im1Dto2DY=[];
im2Dto1D=zeros(Mx,My);
k=0;
for i=1:Mx
    for j=1:My
        if(bad(i,j))
            k=k+1;
            im2Dto1D(i,j)=k;
            im1Dto2DX=[im1Dto2DX i];
            im1Dto2DY=[im1Dto2DY j];
        end
    end
end
% imagesc(im2Dto1D)

%%%%%%%%%%%%%%%%%%%%%%%
% We prepare the equation
imageAfterIHE=image3D;
toto=ones(3);
toto(1,1)=0;
toto(1,3)=0;
toto(3,1)=0;
toto(3,3)=0;
% se=strel('arbitrary', toto);
pointsLimites=imdilate(good,toto) & ~good;
% imagesc(pointsLimites)
pointsInterieurs=bad & ~pointsLimites;
% imagesc(pointsInterieurs)
sizeBad=sum(sum(bad));

for allo = 1:Mz
    image=image3D(:,:,allo);
    
    A=sparse(sizeBad,sizeBad);
    b=sparse(sizeBad,1);

    for i=1:sizeBad
        somme=0;
        x=im1Dto2DX(i);
        y=im1Dto2DY(i);
        listeX_1=[x-1,x+1,x,x];
        listeY_1=[y,y,y-1,y+1];
        for indice=1:4
            listeX=listeX_1(indice);
            listeY=listeY_1(indice);
            if(isIn(listeX,1,Mx) && isIn(listeY,1,My))
                somme=somme+1;
                j=im2Dto1D(listeX,listeY);
                if(j~=0) % equivalent to (if listeX,listeY isIn bad)
                    A(i,j)=1;
                else
                    b(i)=b(i)-image(listeX,listeY);
                end
            end
        end
        A(i,i)=-somme;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%
    % We solve the matrix equation using the conjugate gradient method
%     tol=1e-6;
%     maxit=1e7;
%     x0 = cgs(A,b,tol,maxit);
    x0=A\b;

    %%%%%%%%%%%%%%%%%%%%%
    % We reconstruct the image
    
    for i=1:sizeBad
        x=im1Dto2DX(i);
        y=im1Dto2DY(i);
        imageAfterIHE(x,y,allo)=...
            x0(i);
    end
%     imshow(imageAfterIHE(:,:,allo))
end


end

