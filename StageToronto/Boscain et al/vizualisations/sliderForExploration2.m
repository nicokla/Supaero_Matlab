function sliderForExploration2() %image3d
% A utiliser comme ça :
% global image3d;
% image3d=matricesExponentielles;
% sliderForExploration2()
global defaultMin defaultMax defaultVal matricesExponentielles;
defaultMin=[1 1 0 0 0];
defaultMax=[size(matricesExponentielles,1) size(matricesExponentielles,2) 1 1 1];
defaultVal=[1.01 1.01 0 0 0];
global computeAllExponentialMatrices;
if(computeAllExponentialMatrices)
    funcslider2(@(i,j) {...
        matricesExponentielles(:,:,round(i), round(j)), round(i), round(j)} ,...
        'imagesc(z1{1});title(sprintf(''%d,%d'',z1{2},z1{3}));');
else
    funcslider2(@(i,j) {...
        getExpMat(round(i), round(j)), round(i), round(j)} ,...
        'imagesc(z1{1});title(sprintf(''%d,%d'',z1{2},z1{3}));');
end


