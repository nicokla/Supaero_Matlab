function [ canBeLifted, anglesExacts ] = calculThings3(...
sigma_gradient, sigma_tenseur,...
coeffThreshGrad, coeffThreshAnisotropy)

% These variables should have been declared before, and set global before
% also.
% global imageInReconstr good thetaNumber;
global image0  thetaNumber;%imageInReconstr good

order=2;
displayThings=false;

[ ~, ~, ~, ~, ~,...
normeOfGrad, anisotropy, ~,...
anglesExacts, ~] = ...
getAngles(image0, ones(size(image0)), sigma_tenseur,...
sigma_gradient, thetaNumber, order, displayThings);
% imageInReconstr, good,


canBeLifted=(normeOfGrad>=coeffThreshGrad) &...
    (anisotropy >= coeffThreshAnisotropy);

end

