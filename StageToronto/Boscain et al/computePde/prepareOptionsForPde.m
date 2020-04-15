function options = ...
    prepareOptionsForPde(nameDir,nameFile,...
maskNumber,inverseValuesOfKnownPixels,unknownPixelsWhite,...
liftType, paramGradLift,personalizeParamGradLift,...
optionCleverLift, thetaNumber,liftAngle,projectionType,...
normalizeAfterProjection,pdeType,scheme,weighted,params,...
weightedLikeAHE,automaticSaveImageEachHowManySteps,dontShow)

global good imageInReconstr;
global defaultMin defaultMax defaultVal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

options.imageAndMask={nameDir,nameFile,...
    maskNumber,inverseValuesOfKnownPixels,...
    unknownPixelsWhite};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepare lift

optionLift.thetaNumber=thetaNumber;
optionLift.type=liftType;

if(strcmp(optionLift.type , 'cleverLift') ||...
strcmp(optionLift.type , 'absoluteGrad') ||...
strcmp(optionLift.type , 'absoluteGradAllGray') ||...
strcmp(optionLift.type , 'realisticGrad') ||...
strcmp(optionLift.type , 'realisticGrad2'))
    defaultMin=[0   0  0   0     0];
    defaultMax=[2   2  0.2 2     1];
    defaultVal=[paramGradLift 0];
    
    if(personalizeParamGradLift)
%         close all;
        pause(1); % necessaire avant funcslider sinon bug pour une raison inconnue
        a=funcslider(@calculThings, 'plotDiscreteAngles(z1,z2)');
    else
        a={defaultVal(1), defaultVal(2), defaultVal(3), defaultVal(4)};
    end
    
    [sigma_gradient, sigma_tenseur, ...
      coeffThreshGrad,coeffThreshAnisotropy]=...
        deal(a{:});
    optionLift.paramGradLift=...
        [sigma_gradient, sigma_tenseur, ...
         coeffThreshGrad,coeffThreshAnisotropy ];
    
    order=2;
    displayThings=false;
    [ ~, lambda1, lambda2, ~, ~,...
        normeOfGrad, anisotropy, ~,...
        anglesExacts, anglesApprox] = ...
      getAngles(imageInReconstr, good, sigma_tenseur,...
      sigma_gradient, thetaNumber, order, displayThings);
    
    optionLift.normeOfGrad=normeOfGrad;
    optionLift.lambda1=lambda1;
    optionLift.lambda2=lambda2;
    optionLift.anglesExacts=anglesExacts;
    optionLift.anglesApprox=anglesApprox;
    optionLift.canBeLifted=(normeOfGrad>=coeffThreshGrad) &...
        (anisotropy >= coeffThreshAnisotropy) & good & (anglesApprox>0);
    optionLift.optionCleverLift=optionCleverLift;
    
else
    fprintf(['For this type of lift, no need to choose the '...
            'smoothing kernel radius.\n\n']);

    if(strcmp(optionLift.type,'oneAngle'))
        optionLift.angle=liftAngle; % 3*pi/4;
    end
end

optionLift.typeProjection=projectionType;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepare projection

optionProjection.type=projectionType;
optionProjection.normalizeAfterProjection=normalizeAfterProjection;
if(strcmp(optionProjection.type,'normeP') ||...
    strcmp(optionProjection.type,'normePFromTheMean'))
    optionProjection.p=2;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepare PDE

optionPde.scheme=scheme;
optionPde.type=pdeType;
optionPde.weighted=weighted;
optionPde.params=params;
optionPde.weightedLikeAHE=weightedLikeAHE;
optionPde.automaticSaveImageEachHowManySteps=automaticSaveImageEachHowManySteps;
optionPde.dontShow=dontShow;

close all;
pause(1) % else le close all ne marche pas. Or use drawnow ?

options.lift = optionLift;
options.projection=optionProjection;
options.pde=optionPde;



