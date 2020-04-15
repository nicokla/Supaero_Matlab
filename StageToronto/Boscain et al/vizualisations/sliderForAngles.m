function sliderForAngles(nameDir, nameFile, maskNumber)
% funcslider2(@(k) image3dFinale(:,:,1+round(29*k)) ,'imagesc(z1)')
if(nargin==2)
    maskNumber=0;
end

global defaultMin defaultMax defaultVal;
global image0 good imageInReconstr thetaNumber;

% nameDir=...
%     '../Boscain et al - images/';
% nameFile='venus_1.png';
% maskNumber=0;
inverseValuesOfKnownPixels=0;
unknownPixelsWhite=0;
blurringStdDev=0;
thetaNumber=30;
[image0, good, imageInReconstr]=...
loadImageAndMask(nameDir, nameFile, maskNumber, ...
inverseValuesOfKnownPixels, unknownPixelsWhite, blurringStdDev);

% options.imageAndMask={nameDir,nameFile,...
%     maskNumber,inverseValuesOfKnownPixels,...
%     unknownPixelsWhite};
% optionLift.thetaNumber=thetaNumber;
% optionLift.type='realisticGrad';

paramGradLift = [0 1 0.38318 0.92991];
defaultMin=[0   1   0   0   0];
defaultMax=[0.2 10  2   2   1];
defaultVal=[paramGradLift 0];
pause(1); % necessaire avant funcslider sinon bug pour une raison inconnue
a=funcslider(@calculThings, 'plotDiscreteAngles(z1,z2)');
[coeffThreshGrad,coeffThreshAnisotropy, sigma_tenseur, sigma_gradient]=...
   deal(a{:});






