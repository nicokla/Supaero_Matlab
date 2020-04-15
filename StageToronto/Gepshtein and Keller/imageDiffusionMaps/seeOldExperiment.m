function seeOldExperiment(eigenvalues,diffusionMapsCoordinates_images)

eigenvalues

close all
% imagesc2(diffusionMapsCoordinates_images(:,:,2), 7, false);
figure(1); bar(eigenvalues); ylim([0 1]);
for i=2:size(diffusionMapsCoordinates_images,3)
    figure(2);
    imagesc2(diffusionMapsCoordinates_images(:,:,i), 7, false);
    title(['Eigenvector n°' num2str(i) ...
           ', eigenvalue : ' num2str(eigenvalues(i))]);
    pause(2);
end



