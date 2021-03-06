function [x,...
y,...
d]=...
	functionToGetDistances_Hellinger(...
textureDescriptor,...
whereTextureDescriptorIsDefined,...
kForKnn)


% imagesc(sum(textureDescriptor,3));
tic
[x,y,d]=...
	generalizedPatchMatch_HellingerSquared...
(textureDescriptor,...
textureDescriptor,...
5,...
kForKnn,...
whereTextureDescriptorIsDefined,...
whereTextureDescriptorIsDefined);
toc

d=sqrt(abs(d));
x=x+1;
y=y+1;