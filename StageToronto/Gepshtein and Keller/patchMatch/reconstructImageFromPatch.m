function [ imageFinale ] = reconstructImageFromPatch(...
    imageToComplete, imageUsed, listeX, listeY, semiSize )

[Mx,My,Mz]=size(imageToComplete);
nUsed=zeros(Mx,My);
currentSomme=zeros(Mx,My,Mz);
delta=(-semiSize):semiSize;
delta=int32(delta);
toto=ones(length(delta));
for i=(1+semiSize):(Mx-semiSize)
    for j=(1+semiSize):(My-semiSize)
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

imageFinale=keepOnlyCenter(imageFinale,semiSize);
imshow(imageFinale);