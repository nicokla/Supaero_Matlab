function [...
textureDescriptor,...
whereTextureDescriptorIsDefined]=...
	functionToGetDescriptor_LbpRotInvAndVar(...
image3d,...
good,...
paramsToGetDescriptor)


n=paramsToGetDescriptor.n;
R=paramsToGetDescriptor.R;
sigma=paramsToGetDescriptor.sigma;
nbBinsToDiscretizeVar=...
	paramsToGetDescriptor.nbBinsToDiscretizeVar;

imageGris=rgb2gray(image3d);

[lbpRotInvAndVar_pointwise, ...
lbpRotInvAndVar_Hist,...
wherePointwiseLbpIsComputableWithoutArtifacts,...
whereHistogramLbpIsComputableWithoutArtifacts,...
rangePointwise]=...
lbpRotInvAndVar(imageGris, good, n, R, nbBinsToDiscretizeVar, sigma);

textureDescriptor=lbpRotInvAndVar_Hist;
whereTextureDescriptorIsDefined=...
	whereHistogramLbpIsComputableWithoutArtifacts;




	