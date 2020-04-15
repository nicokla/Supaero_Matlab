function [ h ] = gaussian2( size, sigma )
h = fspecial('gaussian', size, sigma);
% surf(h);
% imagesc(fspecial('gaussian', 49, 10))

