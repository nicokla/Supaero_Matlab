
masque=ones(3);
dirName='../../../Input/ImagesInput_GepshteinAndKeller';
imageName='rice.bmp';
[image, imageGris, good, bad, Mx, My]=...
    getImageAndMask_simple(dirName,imageName);
meanSizeSide=2000;
[ image, imageGris, good, bad, Mx, My ] = ...
    getImageAndMask2( dirName, imageName, meanSizeSide );
sc(good);

tic
    erode1=imerode(good,masque);
toc

tic
    erode2=imerode(good,masque);
toc

sum(sum(abs(erode1-erode2)))


