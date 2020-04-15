function [ imageFinale ] = reconstructImageFromPatch2(...
    imageToComplete, imageUsed, listeX, listeY, sizePatch )
listeX=listeX+1;
listeY=listeY+1;
[Mx,My,Mz]=size(imageToComplete);
nUsed=zeros(Mx,My);
currentSomme=zeros(Mx,My,Mz);
delta=0:(sizePatch-1);
delta=int32(delta);
toto=ones(sizePatch);
for i=1:size(listeX,1)
    for j=1:size(listeX,2)
        currentSomme(i+delta,j+delta,:)=...
          currentSomme(i+delta,j+delta,:)+ ...
          imageUsed(listeX(i,j)+delta,listeY(i,j)+delta,:);
        nUsed(i+delta,j+delta)=nUsed(i+delta,j+delta)+toto;
    end
end

imageFinale=zeros(Mx,My,Mz);
for k=1:Mz
    imageFinale(:,:,k)=currentSomme(:,:,k)./nUsed;
end

%imageFinale=keepOnlyCenter(imageFinale,semiSize);
%imshow(imageFinale);