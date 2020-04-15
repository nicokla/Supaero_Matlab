

% [imageToComplete, imageGris, good, bad, Mx, My]=getImageAndMask_simple('a1.png');
% [imageUsed, imageGris, good, bad, Mx, My]=getImageAndMask_simple('a2.png');

nameFolder = '../../../Input/ImagesInput_PatchMatch';
nameFile1='a1.png';
nameFile2='a2.png';
[b, imageGris, good, bad, Mx, My]=...
    getImageAndMask_simple(nameFolder, nameFile1);
[c, imageGris, good, bad, Mx, My]=...
    getImageAndMask_simple(nameFolder, nameFile2);
sc(b), figure, sc(c);

[Mx1,My1,~]=size(b);
[Mx2,My2,~]=size(c);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compile the C++ code.

mex -setup cpp
% mex -g generalizedPatchMatch_EuclidianSquared.cpp
% clear mex
mex generalizedPatchMatch_EuclidianSquared.cpp
mex generalizedPatchMatch_EuclidianSquared_patch.cpp
mex generalizedPatchMatch_HellingerSquared.cpp
mex generalizedPatchMatch_Shannon.cpp


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%  [x,y,d]=pm(b,c,nbEtapes,k,good1,good2);


nbEtapes=5;
k=4;
mask=ones(5);
mask=mask/sum(mask(:));
w=size(mask,1);
% good1=true(Mx1,My1);
% good2=true(Mx2,My2);
good1=ones(Mx1,My1);
good2=ones(Mx2,My2);

k=10;
good1(100:200,100:300)=0;
good2=good1;

[x,y,d]=generalizedPatchMatch_EuclidianSquared(...
            b,c,nbEtapes,k,good1,good2);

sc(multiplie2Det3D(good1,c));
mask=ones(1);
% [x,y,d]=pm_3(b,b,nbEtapes,k,mask,good1,good2);
[x,y,d]=pm(b,b,nbEtapes,k,good1,good2);

aaa=1;
sc(x(:,:,aaa), 'jet');
figure,sc(y(:,:,aaa), 'jet');

d(~good1)=0;
imagesc(log(d(:,:,aaa))); colormap('jet');
imagesc(d(:,:,aaa)); colormap('jet');

% sc(d(:,:,1)-d(:,:,15)>=0); colorbar;
sc(keepOnlyCenter(d(:,:,1),6), 'jet'); colorbar %imagesc
d(~good1)=1e9;

% axis off equal; colorbar;

% imagesc((x(:,:,1)==x(:,:,2)) &(y(:,:,1)==y(:,:,2)))

[ imageFinale ] = reconstructImageFromPatch3(...
    b, c, x(:,:,1), y(:,:,1), ones(1), d(:,:,1), good2 );
sc(imageFinale);
sc(imageFinale-b);
sc(keepOnlyCenter( imageFinale-b, 6 ));












