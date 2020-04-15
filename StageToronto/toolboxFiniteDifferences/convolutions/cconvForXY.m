function [ result ] = cconvForXY( image3d, kernel )
[Mx,My,numTheta]=size(image3d);
result=zeros(size(image3d));
kernel2=expandKernel(kernel,Mx,My);
result = cconv(image3d,kernel2);
%for i = 1:numTheta
%    result(:,:,i)=cconv(image3d(:,:,i),kernel2) ;
%end


