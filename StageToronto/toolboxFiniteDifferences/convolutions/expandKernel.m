function [ k2 ] = expandKernel( k1, Mx, My )
% Test the function : expandKernel(ones(3),8,8)

centerK2_x=ceil((Mx+1)/2);
centerK2_y=ceil((My+1)/2);
[sizeK1_x,sizeK1_y]=size(k1);

if(mod(sizeK1_x,2)==1)
    semiSizeK1_x=(sizeK1_x-1)/2;
    deltaX=(centerK2_x-semiSizeK1_x):(centerK2_x+semiSizeK1_x);
else
    semiSizeK1_x=(sizeK1_x)/2;
    deltaX=(centerK2_x-semiSizeK1_x+1):(centerK2_x+semiSizeK1_x);
end

if(mod(sizeK1_y,2)==1)
    semiSizeK1_y=(sizeK1_y-1)/2;
    deltaY = (centerK2_y-semiSizeK1_y):(centerK2_y+semiSizeK1_y);
else
    semiSizeK1_y=(sizeK1_y)/2;
    deltaY = (centerK2_y-semiSizeK1_y+1):(centerK2_y+semiSizeK1_y);
end

k2=zeros(Mx,My);
k2(deltaX,deltaY)=k1;

% necessary because that's how we can do everything in fourier,
% else if it's centered we have a shift.
k2=ifftshift(k2);
end

