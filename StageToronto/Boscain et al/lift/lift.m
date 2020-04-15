function [ image3d, renormalizationMatrix ] = ...
    lift( image, optionLift )
renormalizationMatrix=[];

type=optionLift.type;
thetaNumber=optionLift.thetaNumber;

[Mx,My]=size(image);
image3d=zeros(Mx,My,thetaNumber);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A lift just for test : 
% it brings everything to a single angle
if(strcmp(type,'oneAngle'))
    angle=optionLift.angle; % 3*pi/4;
    i = indexOfAngle( angle, thetaNumber );
    image3d(:,:,i)=image;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(strcmp(type,'simpleMean'))
    image3d=repmat(image,[1,1,thetaNumber])/thetaNumber;
 

elseif(strcmp(type,'simpleEqual'))
    image3d=repmat(image,[1,1,thetaNumber]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(strcmp(type,'realisticFourier'))
    image3d=liftFourier(image,thetaNumber);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(strcmp(type,'realisticGrad'))
lambda1 = optionLift.lambda1;
lambda2 = optionLift.lambda2;
anglesExacts = optionLift.anglesExacts;
canBeLifted = optionLift.canBeLifted;
typeProjection = optionLift.typeProjection;
[image3d, renormalizationMatrix] = liftRealisticGrad...
    (image, thetaNumber, anglesExacts, lambda1, lambda2,...
    canBeLifted, typeProjection);

elseif(strcmp(type,'realisticGrad2'))
% lambda1 = optionLift.lambda1;
% lambda2 = optionLift.lambda2;
anglesExacts = optionLift.anglesExacts;
canBeLifted = optionLift.canBeLifted;
typeProjection = optionLift.typeProjection;
normeOfGrad = optionLift.normeOfGrad;
[image3d, renormalizationMatrix] = liftRealisticGrad2...
    (image, thetaNumber, anglesExacts,...
    canBeLifted, normeOfGrad, typeProjection);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    anglesApprox = optionLift.anglesApprox;
    canBeLifted = optionLift.canBeLifted;

    if(strcmp(type,'absoluteGrad'))
        image3d = liftAbsoluteGrad( image, anglesApprox, thetaNumber );
    elseif(strcmp(type,'absoluteGradAllGray'))
        image3d = liftAbsoluteGradAllGray( image, anglesApprox, thetaNumber );
    elseif(strcmp(type,'cleverLift'))
        optionCleverLift=optionLift.optionCleverLift;
        image3d = cleverLift(image, anglesApprox, ...
            thetaNumber, canBeLifted, optionCleverLift);
    else
        fprintf('Error : lift unknown. 3D matrix set to zero.');
    end
end


