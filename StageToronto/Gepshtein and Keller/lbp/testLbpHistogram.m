
nameFolder = '../../../Input/ImagesInput_LBP';
nameFile='1.5.01.tiff';
[image, imageGris, good, bad, Mx, My]=...
    getImageAndMask_simple(nameFolder, nameFile);


%% Avec R=3, N=24

% kernelOption :
%     1 : gaussian
%     2 : hanning
%     3 : square
%     4 : disk
% optionForEdges :
%     0 : zero outside, and don't crop at the end
%     1 : zero outside, and crop at the end
%     2 : symmetry outside, and crop at the end.
kernelOption=2; % hanning
optionForEdges=2;
good=ones(size(imageGris,1),size(imageGris,2));
nbBinsToDiscretizeVar=3;
semiSize=4;
n=16;
R=2;

[ lbpHistUniform, lbpHistRotInv, lbpHistRotInvAndDiscretizedVar,...
whereHistogramLbpIsComputableWithoutArtifacts,...
tableUniformToNormal_numOf1,...
tableUniformToNormal_debutDes1,...
tableNormalToUniform2,...
lbpRotInv, ...
lbpUniform,...
rangeRotInv,...
rangeUniform] = computeLbpHistogram2( ...
    imageGris, n, R, good, nbBinsToDiscretizeVar, semiSize, ...
    kernelOption, optionForEdges);


flatPixels=(lbpRotInv>=0 & lbpRotInv<=2) |...
    (lbpRotInv>=n-2 & lbpRotInv<=n);
edgePixels=(lbpRotInv>=n/2-2 & lbpRotInv<=n/2+2);
cornerPixels=(lbpRotInv>=n/4-2 & lbpRotInv<=n/4+2) |...
   (lbpRotInv>=3*n/4-2 & lbpRotInv<=3*n/4+2) ;
pixelOuImpossibleACalculer=lbpRotInv<0;
pixelNonUniform=lbpRotInv>n;

sc(image);
imagesc2(flatPixels,4)
imagesc2(edgePixels,4)
imagesc2(cornerPixels,4)
imagesc2(pixelOuImpossibleACalculer,4);
imagesc2(pixelNonUniform,4);
mean(pixelNonUniform(:))

endroit1=1+[0:2 (n-2):n];
imagesc2(sum(lbpHistRotInv(:,:,endroit1),3),4)
endroit2=1+[(n/2-2):(n/2+2)];
imagesc2(sum(lbpHistRotInv(:,:,endroit2),3),4)
endroit3=1+[(n/4-2):(n/4+2) (3*n/4-2):(3*n/4+2)];
imagesc2(sum(lbpHistRotInv(:,:,endroit3),3),4)

imagesc2(lbpHistRotInv(:,:,1),4,0)

global image3d;
image3d=lbpHistRotInv;
sliderForExploration();
image3d=lbpHistUniform;
sliderForExploration();
image3d=lbpHistRotInvAndDiscretizedVar;
sliderForExploration();

histogram(lbpRotInv(:))
xlim([-1 n+2]-0.5)

zoneOk = lbpRotInv>=0 & lbpRotInv<=n;
histogram(lbpRotInv(zoneOk))
xlim([0 n+1]-0.5)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Avec R=1, N=8, hanning
% kernelOption :
%     1 : gaussian
%     2 : hanning
%     3 : square
%     4 : disk
% optionForEdges :
%     0 : zero outside, and don't crop at the end
%     1 : zero outside, and crop at the end
%     2 : symmetry outside, and crop at the end.
kernelOption=2; % hanning
optionForEdges=2;
good=ones(size(imageGris,1),size(imageGris,2));
nbBinsToDiscretizeVar=3;
semiSize=4;
n=8;
R=1;

[ lbpHistUniform, lbpHistRotInv, lbpHistRotInvAndDiscretizedVar,...
whereHistogramLbpIsComputableWithoutArtifacts,...
tableUniformToNormal_numOf1,...
tableUniformToNormal_debutDes1,...
tableNormalToUniform2,...
lbpRotInv, ...
lbpUniform,...
rangeRotInv,...
rangeUniform] = computeLbpHistogram2( ...
    imageGris, n, R, good, nbBinsToDiscretizeVar, semiSize, ...
    kernelOption, optionForEdges);

histogram(lbpRotInv(:))
xlim([-1 n+2]-0.5)

zoneOk = lbpRotInv>=0 & lbpRotInv<=n;
histogram(lbpRotInv(zoneOk))
xlim([0 n+1]-0.5)

imagesc2(lbpHistRotInv(:,:,5),4,0)
imagesc2(lbpHistRotInv(:,:,1),4,0)

imagesc2(lbpRotInv==0,4,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Avec R=1, N=8, square


% kernelOption :
%     1 : gaussian
%     2 : hanning
%     3 : square
%     4 : disk
% optionForEdges :
%     0 : zero outside, and don't crop at the end
%     1 : zero outside, and crop at the end
%     2 : symmetry outside, and crop at the end.
kernelOption=3; % square
optionForEdges=2;
good=ones(size(imageGris,1),size(imageGris,2));
nbBinsToDiscretizeVar=3;
semiSize=7;
n=8;
R=1;

[ lbpHistUniform, lbpHistRotInv, lbpHistRotInvAndDiscretizedVar,...
whereHistogramLbpIsComputableWithoutArtifacts,...
tableUniformToNormal_numOf1,...
tableUniformToNormal_debutDes1,...
tableNormalToUniform2,...
lbpRotInv, ...
lbpUniform,...
rangeRotInv,...
rangeUniform] = computeLbpHistogram2( ...
    imageGris, n, R, good, nbBinsToDiscretizeVar, semiSize, ...
    kernelOption, optionForEdges);

imhist(lbpRotInv)




