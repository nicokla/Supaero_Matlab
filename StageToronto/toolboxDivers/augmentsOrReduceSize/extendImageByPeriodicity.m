function image2 = extendImageByPeriodicity( image, widthAddedAround )
w=widthAddedAround;
[Mx,My,Mz]=size(image);
getInd=@(M,w) [(M:-1:(M-w+1)) (1:M) (1:w) ];

indicesX=getInd(Mx,w);
indicesY=getInd(My,w);

image2=image(indicesX,indicesY,:);
end

