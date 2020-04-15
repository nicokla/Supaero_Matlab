function image3d = liftFourier(image, thetaNumber)
% [thetaNumber, i0, j0]=deal(30,256,256);
thetaNumber=30;
[i0,j0]=size(image);
milieu=@(i)floor(i/2)+1;
%milieu2=@(i,j)[milieu(i), milieu(j)];
liste=@(i)[1:i]-milieu(i);
%[X,Y]=meshgrid(liste(i0),liste(j0));
%Y=-Y;
[Y,X]=meshgrid(liste(i0),liste(j0));
angles=mod(atan(Y./X),pi);
angles(milieu(i0), milieu(j0))=0; % false but instead of NaN
%imagesc(angles), colormap hsv
fftImage=fftshift(fft2(image));



% approx ok if square. Else need improvement (area of cutted zones, like rotation)
image3dFourier=zeros(i0,j0,thetaNumber);
image3d=zeros(i0,j0,thetaNumber);
masques=zeros(i0,j0,thetaNumber);
for i=1:thetaNumber
    if(i==1)
        masque=double((angles>(mod(((i-1.5)*(pi/thetaNumber)),pi)))|...
        (angles<((i-0.5)*(pi/thetaNumber))));
        masque(angles==mod((i-1.5)*(pi/thetaNumber),pi))=0.5;
    else
        masque=double((angles>(i-1.5)*(pi/thetaNumber))&...
        (angles<(i-0.5)*(pi/thetaNumber)));
        masque(angles==(i-1.5)*(pi/thetaNumber))=0.5;
    end
    masque(angles==(i-0.5)*(pi/thetaNumber))=0.5;
    masque(milieu(i0), milieu(j0))=(1/thetaNumber);
    if(mod(i0,2)==0)
        for k=2:(i0/2)
            a=masque(k,1)+masque(i0+2-k,1);
            masque(k,1)=a/2;
            masque(i0+2-k,1)=a/2;
%              masque(k,1)=0;
%              masque(i0+2-k,1)=0;
        end
    end
    if(mod(j0,2)==0)
        for k=2:(j0/2)
            a=masque(1,k)+masque(1,j0+2-k);
            masque(1,k)=a/2;
            masque(1,j0+2-k)=a/2;
%             masque(1,k)=0;
%             masque(1,j0+2-k)=0;
        end
    end
%     masque(i0/2+1,1)=0;
%     masque(1,i0/2+1)=0;
%     masque(1,1)=0;
    masques(:,:,i)=masque;
    image3dFourier(:,:,i)=fftImage.*masque;
    image3d(:,:,i)=ifft2(ifftshift(image3dFourier(:,:,i)));
end





%image3d=ifft2(ifftshift(image3dFourier,3));
end


% imagesc(max(abs(image3d),[],3))

% image3dHighPassFilteredFourier=zeros(size(image3dFourier));
% a=20
% masque=(abs(X)<a & abs(Y)<a);%not
% %imagesc(masque)
% for i=1:thetaNumber
%     image3dHighPassFilteredFourier(:,:,i)=...
%         image3dFourier(:,:,i).*...
%         masque;
% end
% for i=1:thetaNumber
%     image3dHighPassFiltered(:,:,i)=...
%         ifft2(ifftshift(image3dHighPassFilteredFourier(:,:,i)));
% end
% imagesc(image3dHighPassFiltered(:,:,3));
% figure,imagesc(max(abs(image3dHighPassFiltered),[],3))
% figure,imagesc(max(image3dHighPassFiltered,[],3))
% figure,imagesc(sum(image3dHighPassFiltered,3))
% colormap gray








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% imagesc(real(sum(image3d,3)));
% imagesc(image3d(:,:,2))
% coco=sum((image3d),3);%-image;
% imagesc(coco);
% imagesc(coco-image);
% imagesc(sum(masques,3));
% imagesc(imag(ifft2(ifftshift(image3dFourier(:,:,1)))));
% imagesc(imag(image3d(:,:,1)))
% imagesc(masques(:,:,1))
% 
% [u1,v1]=max(abs(imag(ifft2(ifftshift(image3dFourier)))));
% [u2,v2]=max(u1);
% [u3,v3]=max(u2);
% u3
% imag(image3d(v1(1,v2(v3),v3),v2(v3),v3))
% imagesc(imag(image3d(:,:,2))*10^17)
% imagesc(masques(:,:,2))
% 
% toto=image3dFourier(:,:,1);
% coucou=toto(2:end,2:end)+toto(end:-1:2,end:-1:2);
% imagesc(coucou);
% figure,imagesc(imag(coucou))
% figure,imagesc(imag(coucou*1e17))
% imagesc(ifft2(ifftshift(toto)));
% imagesc(image3d(:,:,1)<0)
% imagesc(image3d(:,:,1))
% 
% 1e-323==0
% 1e-324==0


% youp=100;
% imagesc(angles), colormap gray;
% imagesc(masques(:,:,16))
% imagesc(sum(masques,3))
% max(abs(imag(image3d(:))))

% imagesc(image-abs(sum(image3d,3)))
% masque=zeros(256);
% masque(1,:)=1;
% masque(:,1)=1;
% imagesc(real(ifft2(ifftshift(masque.*fftImage))))
% imagesc(imag(ifft2(ifftshift(masque.*fftImage))))

% everything is more simple when the dimension is odd than when it's even,
% because opposite frequencies cancel everytime.
% For even numbers, there is an exception for the side opposite to the 
% zero frequency (which is for the pi frequency).
% coco2=fftImage(1,2:end)
% coco=fftImage(1,end:-1:2)
% coco+coco2