function anisotropy = getAnisotropy( sigma_gradient, sigma_tenseur )
global image0  thetaNumber;%imageInReconstr good

order=2;
displayThings=false;
% [ S, lambda1, lambda2, e1, e2,...
%     normeOfGrad, anisotropy, anisotropyLog,...
%     anglesExacts, anglesApprox] = ...
[ ~, ~, ~, ~, ~,...
    ~, anisotropy, ~,...
    ~, ~] = ...
getAngles(image0, ones(size(image0)), sigma_tenseur,...
    sigma_gradient, thetaNumber, order, displayThings);
% imageInReconstr, good,
end

