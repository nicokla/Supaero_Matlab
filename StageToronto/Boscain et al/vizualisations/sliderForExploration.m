function sliderForExploration() %image3d
% A utiliser comme ça :
% global image3d;
% image3d=lbpHistRotInv;
% sliderForExploration()
global defaultMin defaultMax defaultVal;
global image3d;
defaultMin=[1 0 0 0 0];
defaultMax=[size(image3d,3) 1 1 1 1];
defaultVal=[1 0 0 0 0];
% Mz=size(image3d,3);
% funcslider2(@(k) image3d(:,:,1+((Mz-1)*k)) ,'imagesc(z1)');
%funcslider2(@(k) image3d(:,:,round(k)) ,'imagesc(z1)');
funcslider2(@(k) {image3d(:,:,round(k)),round(k)} ,...
    'imagesc(z1{1});title(z1{2});');
% imagesc2(z1{1},4,0)