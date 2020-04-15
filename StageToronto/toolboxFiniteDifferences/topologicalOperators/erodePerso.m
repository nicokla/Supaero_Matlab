function answer = erodePerso(binaryMask, kernel, thresh) %optionBlur
if(nargin==2)
	thresh=0.5;
end
answer = 1-dilatePerso(1-binaryMask, kernel, thresh);