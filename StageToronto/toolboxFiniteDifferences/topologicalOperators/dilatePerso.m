function answer = dilatePerso(binaryMask, kernel, thresh) 
% en pratique binaryMask n'est pas binary mais double pour pouvoir faire la convolution.
optionForEdges = 2;
continuousBlur = convUsingCconv( binaryMask, kernel, optionForEdges );
if(nargin==2)
	thresh=0.5;
end
answer = continuousBlur>=thresh;