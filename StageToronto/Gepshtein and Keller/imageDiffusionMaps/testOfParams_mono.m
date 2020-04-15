%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


nameFolderInput = '../../../Input/ImagesInput_GepshteinAndKeller';
nameFileInput_1='rice.bmp';
nameFolderOutputRoot = '../../../Output/GepshteinAndKeller';

% @functionToGetDescriptor_LbpRotInv
% @functionToGetDescriptor_LbpRotInvAndVar
% @functionToGetDescriptor_LbpUniform
% @functionToGetDescriptor_Wexler
% @functionToGetDescriptor_Windowing

% @functionToGetDistances_Euclidian
% @functionToGetDistances_Euclidian_patch
% @functionToGetDistances_Hellinger
% @functionToGetDistances_Shannon

% [nameFolder,nameFile,sizeImage,
% sigma_tenseur,sigma_gradient,R,n,sigma,nbBinsToDiscretizeVar,...
% functionToGetDescriptor,...
% functionToGetDistances,...
% kForKnn,alpha,markovOrSym,...
% numberOfEigenvectorsToKeep,t,nameFolderOutputRoot]...
% =deal(params{:});

nameFileOfExperiment_suffix='';
params={nameFolderInput, nameFileInput_1, 800,...
    0.8, 0, 1, 8, 1.2, 5,...
    @functionToGetDescriptor_Wexler,...
    @functionToGetDistances_Euclidian,...
    30, 0, 1, 10, 1, nameFolderOutputRoot,...
    nameFileOfExperiment_suffix};
    
[diffusionMapsCoordinates_images,...
eigenvalues]=...
testOfParams( params );

seeOldExperiment(eigenvalues,diffusionMapsCoordinates_images)






