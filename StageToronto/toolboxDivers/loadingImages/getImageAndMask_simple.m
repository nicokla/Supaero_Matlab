function [image, imageGris, good, bad, Mx, My]=...
    getImageAndMask_simple(dirName,imageName)
% Version simplifiée de getImageAndMask
% S'appelait avant loadExampleImage.m
if(dirName(end)~='/')
    dirName=[dirName '/'];
end
imageCompleteName = [dirName imageName];
image=imread(imageCompleteName);
[Mx,My,~]=size(image);
image=double(image)/255;
if(size(image,3)==3)
    imageGris=rgb2gray(image);
elseif (size(image,3)==1)
    imageGris=image;
else
    imageGris=sum(image,3);
end

if(size(image,3)==3)
    bad=double((image(:,:,1)<=0.01) & ...
        (image(:,:,2)>=0.99) & ...
        (image(:,:,3)<=0.01));
    bad=imdilate(bad,strel('square',3));
else
    bad=zeros(Mx,My);
end



good=1-bad;
for i=1:size(image,3)
    imageChannel=image(:,:,i);
    imageChannel(logical(bad))=0;
    image(:,:,i)=imageChannel;
end
imageGris(logical(bad))=0;


