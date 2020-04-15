function image2 = extendImageBySymmetry2( image, widthAddedAround )
w=widthAddedAround;
[Mx,My,Mz]=size(image);
getInd=@(M,w) [(w+1:-1:2) (1:M) ((M-1):-1:(M-w))];

indicesX=getInd(Mx,w);
indicesY=getInd(My,w);

image2=image(indicesX,indicesY,:);
end

