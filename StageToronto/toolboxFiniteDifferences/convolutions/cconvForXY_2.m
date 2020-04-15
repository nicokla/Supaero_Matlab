function [ result ] = cconvForXY_2( image3d, kernel )
% Use this one for derivatives for example
% The other is ok just in the case of symmetric kernels,
% (ie when kernel==invertKernelForConv(kernel))
% for example smoothing kernels.
% The other is also ok for echos (opposite of derivative)
kernel=invertKernelForConv(kernel);
result = cconvForXY( image3d, kernel );


