function image2 = extendImageBySymmetry( image, widthAddedAround )
w=widthAddedAround;
[Mx,My,Mz]=size(image);
getInd=@(M,w) [(w:(-1):1) (1:M) (M:(-1):(M-w+1))];

indicesX=getInd(Mx,w);
indicesY=getInd(My,w);

image2=image(indicesX,indicesY,:);
end

