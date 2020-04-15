%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Diffusion hypoelliptique simple
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


defaultDirName=...
    '../../Input/ImagesInput_BoscainEtAl/';

global matricesExponentielles;
global good imageInReconstr thetaNumber;
global image0;
global defaultMin defaultMax defaultVal;

global computeAllExponentialMatrices;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Some parameters of the article
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1.3.1) Fig. 2.1, left
parametres = {defaultDirName ['eye.png'] 0 true false...
'absoluteGrad' [0.33645 0.34579 0 0] false 'equal' 30 0 ...
'max' 'none'...
'simple' 'schemeArticle' false {0.5 0.2} false 1};


%% 1.3.1) Fig. 2.1, right
parametres = {defaultDirName ['eye.png'] 5 true false...
'absoluteGrad' [0.33645 0.34579 0 0] false 'equal' 30 0 ...%absoluteGrad
'max' 'nearestVect2'...
'simple' 'schemeArticle' false {0.5 1} false 1};



%% 1.3.1) Fig 2.2, left
parametres = {defaultDirName ['eye.png'] 5 true false...
'simpleMean' [0.33645 0.34579 0 0] false 'equal' 30 0 ...
'max' 'nearestVect2'...
'simple' 'schemeArticle' false {0.5 0.7} false 1};


%% 1.3.1) Fig 2.2, middle
parametres = {defaultDirName ['eye.png'] 5 true false...
'oneAngle' [0.33645 0.34579 0 0] false 'equal' 30 0.75*pi ...
'max' 'nearestVect2'...
'simple' 'schemeArticle' false {0.5 0.8} false 1};


%% 1.3.1) Fig 2.2, right
parametres = {defaultDirName ['eye.png'] 5 true false...
'oneAngle' [0.33645 0.34579 0 0] false 'equal' 30 0.25*pi ...
'max' 'nearestVect2'...
'simple' 'schemeArticle' false {0.5 0.6} false 1};


%% 1.3.1) Fig 2.3, left
parametres = {defaultDirName ['eye.png'] 0 true false...
'absoluteGradAllGray' [0.33645 0.34579 0  0] false 'equal' 30 0 ...
'max' 'nearestVect2'...
'simple' 'schemeArticle' false {0.5 0.3} false 1};


%% 1.3.1) Fig 2.3, right
parametres = {defaultDirName ['eye.png'] 5 true false...
'absoluteGradAllGray' [0.33645 0.34579 0 0] false 'equal' 30 0 ...
'max' 'nearestVect2'...
'simple' 'schemeArticle' false {0.5 1} false 1};




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Here it's for the tests with the normal diffusion (not inpainting)


%% Place for any test

parametres = {defaultDirName ['eye.png'] 0 true false...
'realisticGrad2' [0.33645 0.34579 0 0] false 'equal' 30 0 ...
'projectForRealisticGrad2' 'none'...
'simple' 'scheme2' false {0.5 0.2} false 1};


%% 1) Test sur une image de traits : 4 possibilites


%% 2) Test with the image with stripes white or dark
% essais 6 7 10 11, (alpha, T) = (0.002, 12)
% liftType et prjectionType valent :
% realisticGrad2 projectForRealisticGrad2 : 6
% realisticGrad sum : 6
% absoluteGrad max : 6
% simpleEqual max : 6 7
% simpleEqual projectForRealisticGrad2 : 6
% simpleEqual localExtremas : 
% absoluteGrad localExtremas
% absoluteGrad sum
% simpleEqual min
parametres = {defaultDirName ['essai8.png'] 0 true false...
'simpleEqual' [0.33645 0.12 0.06 0] false 'equal' 30 0 ...
'max' 'none'...
'simple' 'scheme2' false {0.03 12} false 1};


%% 3) Varying alpha, T, lift/projection, for a circle
% essais 4 et 5
parametres = {defaultDirName ['essai5.png'] 0 true false...
'absoluteGrad' [0.33645 0.12 0.06 0] false 'equal' 30 0 ...
'sum' 'none'...
'simple' 'scheme2' false {0.2 10} false 1};


%% 4) Test of all gray, max and min
% essais 2 et 3




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End of the definitions of the parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nameDir,nameFile,...
maskNumber,inverseValuesOfKnownPixels,unknownPixelsWhite,...
liftType, paramGradLift,personalizeParamGradLift,...
optionCleverLift, thetaNumber,liftAngle,projectionType,...
normalizeAfterProjection,pdeType,scheme,weighted,params,...
weightedLikeAHE,automaticSaveImageEachHowManySteps] = deal(parametres{:});
personalizeParamGradLift=1;

[alpha,T]=deal(params{:});
betaN=(thetaNumber/(2*pi))^2 * alpha; 
b=1; a=betaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
%% Load the image and the mask
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Si une image avec un masque non indiqué dans l'image
% mais par maskNumber (en gros pour les exemples de l'article)
blurringStdDev=0;
unknownPixelsWhite=0;
[image0, good, imageInReconstr]=...
loadImageAndMask(nameDir, nameFile, maskNumber, ...
inverseValuesOfKnownPixels, unknownPixelsWhite, blurringStdDev);

[Mx,My]=size(image0);
M=sqrt(Mx*My);
psnr(image0, imageInReconstr)

%%
% Si une image avec un masque indiquée en vert dans l'image :
% (en gros pour les exemples persos, comme essai5.png, essai8.png, ...)
[image, imageGris, good, bad, Mx, My]=...
    getImageAndMask_simple(nameDir,nameFile);
image0=imageGris;
imageInReconstr=imageGris.*double(good);
subplot(1,2,1), imshow(image0);
subplot(1,2,2), imshow(good);

% imageInReconstr(~logical(good))=1;
% imshow(imageInReconstr);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Skip this if you already computed the exponential matrices.
% The a, ba and dt parameters will be the same for all the subsequent
% diffusions.
% If you want to change them, you need to also recompute the matrices.

computeAllExponentialMatrices=0;

if computeAllExponentialMatrices
    defineExpMat( Mx,My,thetaNumber,scheme,a,b,T );
else
    defineExpMat2( Mx,My,thetaNumber,scheme,a,b,T );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do the PDE

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

% Compute the PDE
 [ image3d, h ] =... %image3dProjectedIn2D
    computePdeSimple2(imageInReconstr, good, options);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% [nameDir,nameFile,...
% maskNumber,inverseValuesOfKnownPixels,unknownPixelsWhite,...
% liftType, paramGradLift,personalizeParamGradLift,...
% optionCleverLift, thetaNumber,liftAngle,projectionType,...
% normalizeAfterProjection,pdeType,scheme,weighted,params,...
% weightedLikeAHE,automaticSaveImageEachHowManySteps] = deal(parametres{:});

% personalizeParamGradLift=1; dontShow=0;
% options = prepareOptionsForPde(nameDir,nameFile,...
%     maskNumber,inverseValuesOfKnownPixels,unknownPixelsWhite,...
%     liftType, paramGradLift,personalizeParamGradLift,...
%     optionCleverLift, thetaNumber,liftAngle,projectionType,...
%     normalizeAfterProjection,pdeType,scheme,weighted,params,...
%     weightedLikeAHE,automaticSaveImageEachHowManySteps,dontShow);

%% liftType
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
% nameFile   ['leda' '_1.png']
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








