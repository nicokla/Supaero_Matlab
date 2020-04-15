function nameDirSavePictures=...
saveParameters(options, imageInReconstr, image3d, nameDirSavePictures0)

optionPde = options.pde;
optionProjection =options.projection;
optionLift=options.lift;

%nameDirSavePictures0 = '../essais/';
% nameDirSavePictures0 = '../../Output/BoscainEtAl/';
nameDirSavePictures=...
    [nameDirSavePictures0 datestr(now,'yyyy-mm-dd_HH_MM_SS') '/'];
mkdir(nameDirSavePictures0);
mkdir(nameDirSavePictures);

%%%%%%%%%%%%%%%%%%%%%%%%
save([nameDirSavePictures 'options.mat'], 'options');

%%%%%%%%%%%%%%%%%%%%%%%%
name= datestr(now,'yyyy-mm-dd_HH_MM_SS_FFF');
name2=[name sprintf('_step%04d.png', 0)];
h=projectBack( image3d, optionProjection );

imwrite(h/max(h(:)),[nameDirSavePictures name2]);
imwrite(imageInReconstr,[nameDirSavePictures 'imageInReconstr.png']);

% if(strcmp(optionLift.type , 'cleverLift') ||...
% strcmp(optionLift.type , 'absoluteGrad') ||...
% strcmp(optionLift.type , 'absoluteGradAllGray') ||...
% strcmp(optionLift.type , 'realisticGrad'))
if(isfield(optionLift,'anglesApprox') &&...
   isfield(optionLift,'canBeLifted'))
    handle=figure;
%     handle=figure('visible','off')
    plotDiscreteAngles(optionLift.anglesApprox, optionLift.canBeLifted);
    axis equal tight off;
    saveas(handle,[nameDirSavePictures 'liftAngles.png'],'png');
%     pause(2);
%     close;
end


%%%%%%%%%%%%%%%%%%%%%%%%
fileID = fopen([nameDirSavePictures 'parameters.txt'],'w');

fprintf(fileID,['\noptionProjection.type\n\t' optionProjection.type]);
fprintf(fileID,['\noptionProjection.normalizeAfterProjection\n\t'...
 optionProjection.normalizeAfterProjection]);
fprintf(fileID,['\noptionLift.type' '\n\t' optionLift.type]);
if(isfield(optionLift,'paramGradLift'))
    fprintf(fileID,['\ncoeffThreshGrad, coeffThreshAnisotropy, ' ...
    'sigma_tenseur, sigma_gradient\n\t']);
    for i=1:4 %length(optionLift.paramGradLift)
        fprintf(fileID,[num2str(optionLift.paramGradLift(i)) ' ']);
    end
end
fprintf(fileID,['\noptionPde.type\n\t' optionPde.type]);
fprintf(fileID,['\noptionPde.scheme\n\t' optionPde.scheme]);
fprintf(fileID,['\noptionPde.weighted\n\t' num2str(optionPde.weighted)]);
if(strcmp(optionPde.type,'simple'))
    fprintf(fileID,'\nalpha T\n\t');
elseif(~optionPde.weighted)
    fprintf(fileID,'\nalpha T n eps\n\t');
else
    fprintf(fileID,'\na0 a1 b0 b1 sigma n eps\n\t');
end
for i=1:length(optionPde.params)
    fprintf(fileID,[num2str(optionPde.params{i}) '  ']);
end


fclose(fileID);
%%%%%%%%%%%%%%%%%%%%%%%%


