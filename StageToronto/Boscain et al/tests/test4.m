%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Static restoration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

defaultDirName=...
    '../../Input/ImagesInput_BoscainEtAl/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Global variables
global image0;
global good imageInReconstr thetaNumber;

global matricesExponentielles;

global image3d;
global defaultMin defaultMax defaultVal;

global computeAllExponentialMatrices;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Here is the test for a diffusion with inpainting.
% The description of the parameters is below in the file.

parametres = {defaultDirName ['leda.png'] 4 true false... % 4
'realisticGrad' [0.38318 0.92991 0 0] false 'smaller' 30 0 ...
'sum' 'none'...
'static' 'scheme2' false {0.5 1.2 200 1} false 1};


[nameDir,nameFile,...
maskNumber,inverseValuesOfKnownPixels,unknownPixelsWhite,...
liftType, paramGradLift,personalizeParamGradLift,...
optionCleverLift, thetaNumber,liftAngle,projectionType,...
normalizeAfterProjection,pdeType,scheme,weighted,params,...
weightedLikeAHE,automaticSaveImageEachHowManySteps] = deal(parametres{:});
personalizeParamGradLift=1;

[alpha,T,n,eps]=deal(params{:}); dt=T/n;
betaN=(thetaNumber/(2*pi))^2 * alpha; 
b=1; a=betaN;


blurringStdDev=0;
[image0, good, imageInReconstr]=...
loadImageAndMask(nameDir, nameFile, maskNumber, ...
inverseValuesOfKnownPixels, unknownPixelsWhite, blurringStdDev);
[Mx,My]=size(image0);
M=sqrt(Mx*My);
psnr(image0, imageInReconstr)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Skip this if you already computed the exponential matrices.
% The a, ba and dt parameters will be the same for all the subsequent
% diffusions.
% If you want to change them, you need to also recompute the matrices.

computeAllExponentialMatrices=1;

if computeAllExponentialMatrices
    defineExpMat( Mx,My,thetaNumber,scheme,a,b,dt );
else
    defineExpMat2( Mx,My,thetaNumber,scheme,a,b,dt );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare options for the PDE
close;
dontShow=0;
personalizeParamGradLift=1;
options = prepareOptionsForPde(nameDir,nameFile,...
    maskNumber,inverseValuesOfKnownPixels,unknownPixelsWhite,...
    liftType, paramGradLift,personalizeParamGradLift,...
    optionCleverLift, thetaNumber,liftAngle,projectionType,...
    normalizeAfterProjection,pdeType,scheme,weighted,params,...
    weightedLikeAHE,automaticSaveImageEachHowManySteps,dontShow);
optionPde = options.pde;
optionProjection =options.projection;
optionLift=options.lift;

%%%%%%%%%%%%%%%%%%%%%%
% Here you can check the code in the script 
% visualizations.m to vizualize the data
%%%%%%%%%%%%%%%%%%%%%%


% Compute the PDE (image3d is defined there)
[ image3dProjectedIn2D, result ] =...
computePdeStaticOrDynamic2(imageInReconstr, good, options);


defaultMin=[1 0 0 0 0];
defaultMax=[size(image3d,3) 1 1 1 1];
defaultVal=[1 0 0 0 0];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description of the parameters :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% liftType
% 'oneAngle' 'simpleMean'
% 'simpleEqual' 'cleverLift'
% 'absoluteGrad' 'absoluteGradAllGray'
% 'realisticGrad' 'realisticFourier'
% 'realisticGrad2'
%
% paramGradLift
% [coeffThreshGrad, coeffThreshAnisotropy,
% sigma_tenseur, sigma_gradient]
% 
% personalizeParamGradLift
% true/false
% 
% optionCleverLift
% 'equal' 'smaller'
% 
% thetaNumber
% 30
% 
% liftAngle
% pi/4, pi/2, ...
% 
% --------------------
% projectionType ----> in practice 'max' and 'sum' are the most efficient
% 'max' 'sum' 'mean' 'minPlusMax' 
% 'maxFromMean' 'norme2' 'normeP'
% 'normePFromTheMean' 'normeInfinieFromTheMean'
% 'localExtremas' ---> very slow
% 'projectForRealisticGrad2'
%
% normalizeAfterProjection
% 'none' 'max' 'maxAndMin' 'nearestVect' 'nearestVect2'
% 
% ------------------------
% pdeType
% 'simple' 'static' 'dynamic' 'dynamic2'
% 
% scheme
% 'schemeArticle' --> scheme of the article
% 'scheme2' --> scheme with cross derivative with 1 and -1 (4 terms, 2 1 and 2 (-1)
% 'scheme3' --> scheme with 7 terms
% 
% weighted
% true/false ---> not implemented for the moment, should be kept to false.
% 
% params
% {alpha T} % pdeType=simple
% {alpha T n eps}
% {a0 a1 b0 b1 sigma n eps} % weighted=true
% 
% weightedLikeAHE
% true/false
% 
% 
% ----------------------
% ----------------------
% 
% nameDir
% '../../Images/'
% 
% nameFile   'leda.png'
% 'essai' 'eye' 'god' 'leda' 'lisa' ...
% 'monica' 'raisins' 'seins' 'smile'...
% 'trompetist' 'venus'
% 
% maskNumber
% 0 1 2 3 4 5
% 0 : all pixels are known
% 1 : 3 pixels wide black lines, 67% of pixels unknown
% 2 : 6 pixels wide black lines, 67% of pixels unknown
% 3 : 85% pixels unknown
% 4 : 3 pixels wide black lines, 37% of pixels unknown
% 5 : cross lines + horizontal line
% 
% inverseValuesOfKnownPixels
% true/false
% 
% unknownPixelsWhite
% true/false
% 
% ---------------------
% automaticSaveImageEachHowManySteps
% 1, 2, ..., n/8, ..., n
% 
% dontShow
% true/false


