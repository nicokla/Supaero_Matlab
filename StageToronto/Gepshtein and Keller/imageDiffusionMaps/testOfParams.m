function [diffusionMapsCoordinates_images,...
eigenvalues]=...
testOfParams( params )

[nameFolder,nameFile,sizeImage,sigma_tenseur,...
sigma_gradient,R,n,sigma,nbBinsToDiscretizeVar,...
functionToGetDescriptor,functionToGetDistances,...
kForKnn,alpha,markovOrSym,...
numberOfEigenvectorsToKeep,t,nameFolderOutputRoot,...
nameFileOfExperiment_suffix]...
=deal(params{:});

paramsToGetDescriptor.sigma_tenseur=sigma_tenseur;
paramsToGetDescriptor.sigma_gradient=sigma_gradient;
paramsToGetDescriptor.R = R;
paramsToGetDescriptor.n = n;
paramsToGetDescriptor.sigma=sigma;
paramsToGetDescriptor.nbBinsToDiscretizeVar=nbBinsToDiscretizeVar;
paramsToNormalizeTheCorrelationMatrix.alpha=alpha;
paramsToNormalizeTheCorrelationMatrix.markovOrSym=markovOrSym;

[ image3d, imageGris, good, bad, Mx, My ] = ...
    getImageAndMask( nameFolder, nameFile, sizeImage, [0 1 0]);


%%%%%%%%%%%%%%%%
%%

[eigenvalues,diffusionMapsCoordinates_images]=...
imageDiffusionMaps(image3d,good,paramsToGetDescriptor,...
functionToGetDescriptor,functionToGetDistances,...
kForKnn,paramsToNormalizeTheCorrelationMatrix,...
numberOfEigenvectorsToKeep,t);

%%%%%%%%%%%%%%%%
%%

% seeOldExperiment(eigenvalues,diffusionMapsCoordinates_images)

%%%%%%%%%%%%%%%
%%
dateStr=datestr(now,'yyyy-mm-dd_HH_MM_SS');

current=pwd;
cd(nameFolderOutputRoot);
save([dateStr '_' nameFileOfExperiment_suffix '.mat'],...
    'params',...
    'diffusionMapsCoordinates_images',...
    'eigenvalues');
cd(current);







