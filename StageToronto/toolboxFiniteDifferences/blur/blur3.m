function [result, h] = blur3( f, diameter, kernelOption, optionForEdges)
% Seule difference avec blur : renvoie h aussi.
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
	h=1;
else
    h=getSmoothingKernel(kernelOption, diameter);
    result = convUsingCconv(f,h,optionForEdges);
end
