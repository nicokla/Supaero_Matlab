

nameFolder = '../../../Input/ImagesInput_GepshteinAndKeller';
nameFile='rice.bmp';
 [ image3d, imageGris, good, bad, Mx, My ] = ...
    getImageAndMask( nameFolder, nameFile, 200, [0 1 0]);

paramsToGetDescriptor.sigma_tenseur=0.8;
paramsToGetDescriptor.sigma_gradient=0;
paramsToGetDescriptor.R = 3; % 1 2
paramsToGetDescriptor.n = 8 * paramsToGetDescriptor.R;
paramsToGetDescriptor.sigma=1.2;
paramsToGetDescriptor.nbBinsToDiscretizeVar=5;

paramsToNormalizeTheCorrelationMatrix.alpha=0;
paramsToNormalizeTheCorrelationMatrix.markovOrSym=1;
kForKnn=30;

functionToGetDescriptor=@functionToGetDescriptor_LbpRotInv;
    % @functionToGetDescriptor_LbpRotInv
    % @functionToGetDescriptor_LbpRotInvAndVar
    % @functionToGetDescriptor_LbpUniform
    % @functionToGetDescriptor_Wexler
    % @functionToGetDescriptor_Windowing

functionToGetDistances=@functionToGetDistances_Shannon;
    % @functionToGetDistances_Euclidian
    % @functionToGetDistances_Euclidian_patch
    % @functionToGetDistances_Hellinger
    % @functionToGetDistances_Shannon

numberOfEigenvectorsToKeep=10;
t=1;

params={nameFolder,nameFile,paramsToGetDescriptor,...
functionToGetDescriptor,functionToGetDistances,...
kForKnn,paramsToNormalizeTheCorrelationMatrix,...
numberOfEigenvectorsToKeep,t};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

[eigenvalues,diffusionMapsCoordinates_images]=...
imageDiffusionMaps(image3d,good,paramsToGetDescriptor,...
functionToGetDescriptor,functionToGetDistances,...
kForKnn,paramsToNormalizeTheCorrelationMatrix,...
numberOfEigenvectorsToKeep,t);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

seeOldExperiment(eigenvalues,diffusionMapsCoordinates_images)

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

save rightEigenVectors_images_2.mat...
    params...
    diffusionMapsCoordinates_images ...
    eigenvalues;

save IDM_Wexler_1.mat leftEigenVectors_images...
    rightEigenVectors_images eigenvalues;








