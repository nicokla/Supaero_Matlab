% function loadAndSeeOldExperiment( input_args )

nameFolderOutputRoot = '../../../Output/GepshteinAndKeller';
current=pwd;
cd(nameFolderOutputRoot);
ls

nameFileOfExperiment=...
    '2015-12-14_16_10_57_Rice-200-LbpRotInvAndVar-1-8-5-1.2-Euclidian.mat';
load(nameFileOfExperiment); %[nameFileToLoad '.mat']

[nameFolder,nameFile,sizeImage,sigma_tenseur,...
sigma_gradient,R,n,sigma,nbBinsToDiscretizeVar,...
functionToGetDescriptor,functionToGetDistances,...
kForKnn,alpha,markovOrSym,...
numberOfEigenvectorsToKeep,t,nameFolderOutputRoot,...
nameFileOfExperiment_suffix]...
=deal(params{:});

seeOldExperiment(eigenvalues,diffusionMapsCoordinates_images);

for i=2:4
    imagesc2(diffusionMapsCoordinates_images(:,:,i),7,0);figure;
end
close

cd(current);




