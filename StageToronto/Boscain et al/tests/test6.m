%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comparison of the static restoration with the Heat equation,
% the TV Inpainting, and a propagation inpainting 
% (step 1 of AHE, article 2 of Boscain et al.)
%%%%%%%%%%%%%%%%%%%%%%%%%%

defaultDirName=...
    '../../Input/ImagesInput_BoscainEtAl/';



%%
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


%% Loading the image and the mask
blurringStdDev=0;
[image0, good, imageInReconstr]=...
loadImageAndMask(nameDir, nameFile, maskNumber, ...
inverseValuesOfKnownPixels, unknownPixelsWhite, blurringStdDev);
[Mx,My]=size(image0);
M=sqrt(Mx*My);
psnr(image0, imageInReconstr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Heat equation

tic
imageAfterIHE = heatEquation_ninePointStencil(imageInReconstr, good);
toc % 32 seconds

imshow2(imageAfterIHE);
title('Heat equation inpainting')
psnr(image0, imageAfterIHE) % 23.28


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TV inpainting

tol=0;
maxiter=180;
lambda=1e4;
imageAfterTVInpainting = ...
    tvinpaint(imageInReconstr,lambda,...
    ~good,'Gaussian', tol, maxiter ,@tvregsimpleplot);
psnr(image0, imageAfterTVInpainting) % 22.63
imshow2(imageAfterTVInpainting);
title('TV inpainting')

figure
hold on;
xx=1:6;
yy1=[0.9668,0.7117,0.5717,0.4823,0.41975,0.37325];
yy2=yy1(2:end)-yy1(1:(end-1));
plot(1./yy2);
plot(-4*xx.^(3/4))
% k=pi/2;
n=0.27;
k=(0.37325-0.9668)*(6^n)/(1-(6^n));
xx2=1:10;
plot(xx,(0.9668-k) + k./(xx.^n));
% -0.58 + 1.5475 / xx^0.25;
% plot(xx2,(0.9668-k) + k./(xx2.^n));
toto=ylim;
ylim([0,toto(2)]);
xlim([1,6]);
f=@(a,b,th,th0,anisotropy)a+(b-a)*(cos(th-th0)^(2*anisotropy));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inpainting with a propagation of the values

nbstepsMax=1000;
image = inpaintingPropagate( imageInReconstr, good, nbstepsMax );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inpainting with the static restoration

dontShow=1;
personalizeParamGradLift=1;
options = prepareOptionsForPde(nameDir,nameFile,...
    maskNumber,inverseValuesOfKnownPixels,unknownPixelsWhite,...
    liftType, paramGradLift,personalizeParamGradLift,...
    optionCleverLift, thetaNumber,liftAngle,projectionType,...
    normalizeAfterProjection,pdeType,scheme,weighted,params,...
    weightedLikeAHE,automaticSaveImageEachHowManySteps,dontShow);

[ image3dProjectedIn2D, result, image3d] =...
computePdeStaticOrDynamic2(imageInReconstr, good, options);
















