function [masque] = loadMasque( nMasque )


%%%%%%%%%%%%%%%%%%%%%%
%%
%masques={};

% 3 pixels wide black lines, 67% of pixels unknown
if(nMasque==1)
a=[1 1 1 1 0 0 0];
b=[repmat(a,1,36) 1 1 1 1];
masque=b'*b;
%masques{1}=b'*b;
%sum(masque(:))/256^2

% 6 pixels wide black lines, 67% of pixels unknown
elseif(nMasque==2)
a=[ones(1,8), zeros(1,6)];
b=[repmat(a,1,18) 1 1 1 1];
masque=b'*b;
%masques{2}=b'*b;
%sum(masque(:))/256^2

  
% 3 pixels wide black lines, 37% of pixels unknown
elseif(nMasque==4)
a=[ones(1,11), zeros(1,3)];
b=[repmat(a,1,18) 1 1 1 1];
masque=b'*b;
%masques{4}=b'*b;
%sum(masque(:))/256^2


% N = 21;
% bias = 97/N; %97/N
% scale = bias*1/2;
% int_gauss = round(scale*randn(1,128)+bias);
% int_gauss=max(1,int_gauss);
% scale2 = scale*157/97;
% bias2 = bias*157/97;
% int_gauss2 = round(scale2*randn(1,128)+bias2);
% int_gauss2=max(1,int_gauss2);
% int_gauss=[int_gauss; int_gauss2];
% l=[]
% continuer=true
% i=1; s=0; j=1;
% while(continuer)
%     if(j==1)
%         l=[l ones(1,int_gauss(j,i))];
%     else
%         l=[l zeros(1,int_gauss(j,i))];
%     end
%     s=s+int_gauss(j,i);
%     continuer=s<256;
%     i=i+1; j=3-j;
% end
% l=l(1:254);
% masque3=l'*l;
% masque3=[ones(1,254); masque3; ones(1,254)];
% masque3=[ones(256,1) masque3 ones(256,1)];
% imshow(masque3);
% sum(masque3(:))/(256^2)
% save('masque3','masque3');

% random, 85%
elseif nMasque==3
load('masque3');
masque=masque3;
%masques{3}=masque3;
%imshow(masques{3});
%sum(masques{3}(:))/(256^2);

elseif nMasque==0
    masque=ones(256);

elseif nMasque==5
    masque=logical(eye(256));
    masque=masque | masque(:,end:-1:1);
    se=strel('disk',2,0);
    masque=imdilate(masque,se);
    masque(73:75,:)=1;
    masque= (~masque);
    masque=double(masque);
end


% Deuxieme choix
%nMasque=4;
%masque=masques{nMasque};
%imageObs=image.*masque;
%masque=double(masque);
%imshow(imageObs)

end

