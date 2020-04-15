function [ matFinal ] = multRgb( image, condition )
%MULTRGB Summary of this function goes here
%   Detailed explanation goes here

matFinal = zeros(size(image),'uint8');
matFinal(:,:,1)=condition.*image(:,:,1);
matFinal(:,:,2)=condition.*image(:,:,2);
matFinal(:,:,3)=condition.*image(:,:,3);
%figure, imshow(matFinal);

end

