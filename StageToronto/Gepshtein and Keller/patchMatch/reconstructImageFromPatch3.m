function [ imageFinale ] = reconstructImageFromPatch3(...
    imageToComplete, imageUsed, listeX, ...
    listeY, mask, dist, good2 ) % good1
sizePatch=size(mask,1);
listeX=listeX+1;
listeY=listeY+1;
[Mx1,My1,Mz]=size(imageToComplete);
% [Mx2,My2,~]=size(imageUsed);

nUsed=zeros(Mx1,My1);
currentSomme=zeros(Mx1,My1,Mz);
delta=0:(sizePatch-1);
delta=int32(delta);
% m1=zeros(size(mask));
for i=1:size(listeX,1)
    for j=1:size(listeX,2)
        if(dist(i,j)<1000)
            i2=listeX(i,j);
            j2=listeY(i,j);
            m1=mask.*good2(i2+delta,j2+delta);
            currentSomme(i+delta,j+delta,:)=...
              currentSomme(i+delta,j+delta,:)+ ...
              multiplie2Det3D(...
                 m1,...
                 imageUsed(i2+delta,j2+delta,:));
            nUsed(i+delta,j+delta)=nUsed(i+delta,j+delta) + m1;
        end
    end
end

% imageFinale=zeros(Mx1,My1,Mz);
% for k=1:Mz
%     imageFinale(:,:,k)=currentSomme(:,:,k)./nUsed;
% end
renormMat=1./nUsed;
renormMat(isinf(renormMat))=1;
imageFinale=multiplie2Det3D(renormMat,currentSomme);

% imageFinale(isinf(imageFinale))=0;
% imageFinale(isnan(imageFinale))=0;

%imageFinale=keepOnlyCenter(imageFinale,semiSize);
%imshow(imageFinale);



