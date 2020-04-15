function [image0, good, imageInReconstr]=...
loadImageAndMask(nameDir, nameFile, maskNumber, ...
inverseValuesOfKnownPixels, unknownPixelsWhite, blurringStdDev)
%% call load Mask
% Is used in 

image0=double(imread([nameDir nameFile]))/255;
image0=imresize(image0,[256 256]);
if(length(size(image0))==3)
    image0=rgb2gray(image0);
end
% image0=image0/max(image0(:));
mini=min(image0(:));
maxi=max(image0(:));
marge=1/255/10;
image0=marge+(image0-mini)/(maxi-mini)*(1-2*marge);
if(inverseValuesOfKnownPixels)
    image0=1-image0;
end
good = loadMask(maskNumber);
bad=1-good;
imageInReconstr=image0.*good;
if blurringStdDev>0
    imageInReconstr=blurPerso(imageInReconstr, blurringStdDev, good);
end
imageInReconstrMax = max(imageInReconstr(:));
imageInReconstr=imageInReconstr/imageInReconstrMax;
if(unknownPixelsWhite)
    imageInReconstr=imageInReconstr + bad;
end
imageplot({image0 good imageInReconstr});


end

