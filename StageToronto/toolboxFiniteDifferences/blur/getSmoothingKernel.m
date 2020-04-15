function [ h ] = getSmoothingKernel(kernelOption , diameter)
% diameter is considered to be 6*sigma

% kernelOption :
%     1 : gaussian
%     2 : hanning
%     3 : square
%     4 : disk

if kernelOption==1
    h = gaussian2( diameter, diameter/6 );
elseif kernelOption==2
    h = hanning2D( diameter+2 ); % +2 because hanning is zero on the edges
    h=h(2:(end-1),2:(end-1));
elseif kernelOption==3
    h = ones(diameter)/(diameter^2);
elseif kernelOption==4
    h = strel('disk',round(diameter/2),0).getnhood;
    h=h/sum(sum(h));
end

% imagesc(fspecial('gaussian', 49, 10))
% imagesc(getSmoothingKernel(1 , 15))
% imagesc(getSmoothingKernel(2 , 15))
% imagesc(getSmoothingKernel(3 , 15))
% imagesc(getSmoothingKernel(4 , 15))

% surf(getSmoothingKernel(1 , 15))
% surf(getSmoothingKernel(2 , 15))
% surf(getSmoothingKernel(3 , 15))
% surf(getSmoothingKernel(4 , 15))

