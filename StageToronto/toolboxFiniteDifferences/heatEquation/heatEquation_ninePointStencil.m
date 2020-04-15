function [ imageAfterIHE ] = heatEquation_ninePointStencil( image, good )
% 9 Points Stencil
% You can generate onther laplacian stencils using the matlab function
% fspecial('laplacian', alpha). This one is for alpha = 0.2.
% It's a second order approximation of the continuous laplacian.

% image3D=image;
% image3D=newCoords2;

bad=1-good;
[Mx,My,Mz]=size(image);

%%%%%%%%%%%%%%%%%%%%
% We construct the indices
sizeBad=sum(sum(bad));
im1Dto2DX=zeros(1,sizeBad);
im1Dto2DY=zeros(1,sizeBad);
im2Dto1D=zeros(Mx,My);
k=0;
for i=1:Mx
    for j=1:My
        if(bad(i,j))
            k=k+1;
            im2Dto1D(i,j)= k;
            im1Dto2DX(k) = i;
            im1Dto2DY(k) = j;
        end
    end
end
% imagesc(im2Dto1D)

%%%%%%%%%%%%%%%%%%%%%%%
% We prepare the equation
imageAfterIHE=image;

% toto=ones(3);
% % toto(1,1)=0;
% % toto(1,3)=0;
% % toto(3,1)=0;
% % toto(3,3)=0;
% % se=strel('arbitrary', toto);
% pointsLimites=imdilate(good,toto) & ~good;
% % imagesc(pointsLimites)
% pointsInterieurs=bad & ~pointsLimites;
% % imagesc(pointsInterieurs)


for allo = 1:Mz
    imageGris=image(:,:,allo);
    
    A=sparse(sizeBad,sizeBad);
    b=sparse(sizeBad,1);

    for i=1:sizeBad
%         somme=0;
        x=im1Dto2DX(i);
        y=im1Dto2DY(i);
        deltaX=[-1,1,0,0,1,1,-1,-1,0];
        deltaY=[0,0,-1,1,1,-1,1,-1,0];
        coeff=[4,4,4,4,1,1,1,1,-20];
        for indice=1:9
            x2=x+deltaX(indice);
            y2=y+deltaY(indice);
            
            % Von Neumann conditions
            if(x2<1)
                x2=1; % (1-x2)
            elseif(x2>Mx)
                x2=Mx; % ((2*Mx)+1-x2)
            end
            if(y2<1)
                y2=1;
            elseif(y2>My)
                y2=My;
            end
            
            if bad(x2,y2)
                j=im2Dto1D(x2,y2);
                A(i,j)=A(i,j)+coeff(indice);
            else
                b(i)=b(i)-imageGris(x2,y2)*coeff(indice);
            end
        end
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

