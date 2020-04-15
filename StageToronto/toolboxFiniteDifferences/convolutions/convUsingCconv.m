function [ result ] = convUsingCconv( image, kernel, optionForEdges )
% optionForEdges :
%     0 : zero outside, and don't crop at the end
%     1 : zero outside, and crop at the end
%     2 : symmetry outside, and crop at the end.

% result = imfilter(image, kernel,'conv');
% result = conv2(image, kernel);
[a,b]=size(kernel);
w1=floor(a/2)+1;
w2=floor(b/2)+1;
if(optionForEdges == 1 || optionForEdges == 0)
    image = extendImageByConst2( image, 0, w1,w2 );
elseif (optionForEdges == 2)
    w=max(w1,w2);
    image = extendImageBySymmetry( image, w );
end
result = cconvForXY( image, kernel );

if(optionForEdges == 1 || optionForEdges == 2)
    result = keepOnlyCenter2( result, w1,w2 );
end