function [result] = blur( f, diameter, kernelOption, optionForEdges)
% kernelOption :
%     1 : gaussian
%     2 : hanning
%     3 : square
%     4 : disk
% optionForEdges :
%     0 : zero outside, and don't crop at the end
%     1 : zero outside, and crop at the end
%     2 : symmetry outside, and crop at the end.
% For example  blur( f, 15, 2, 2)
if(diameter==0)
    result=f;
else
    h=getSmoothingKernel(kernelOption, diameter);
    result = convUsingCconv(f,h,optionForEdges);
end


% surf(blur(a,15,1,0))
% surf(blur(a,15,2,0))
% surf(blur(1,15,4,0))

% imshow(blur(good,15,4,1))
% imshow(blur(good,15,4,1)>=0.999999)
% toto=blur(good,15,4,1);
% titi=toto>=0.999999;

