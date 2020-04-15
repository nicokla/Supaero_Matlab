function [ result ] = convUsingCconv2( image, kernel, optionForEdges)
% Here it's the true convolution thanks to invertKernelForConv,
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

kernel=invertKernelForConv(kernel);
result = cconvForXY( image, kernel );

if(optionForEdges == 1 || optionForEdges == 2)
    result = keepOnlyCenter2( result, w1,w2 );
end