function [image3d, renormalizationMatrix] = liftRealisticGrad2...
    (image, thetaNumber, anglesExacts,... %lambda1, lambda2
    canBeLifted, normeOfGrad, typeProjection)
global good;
blurredImage = blurPerso( image, 7, good );
level=graythresh(normeOfGrad);

[Mx,My]=size(image);
image3d=zeros(Mx,My,thetaNumber);
theta=linspace(0,pi-pi/thetaNumber,thetaNumber);
for i=1:Mx
    for j=1:My
        if(good(i,j))
            if canBeLifted(i,j)
                theta0=anglesExacts(i,j);
                % power can depend of anisotropy like lambda1/lambda2,
                % or of normeOfGrad like sqrt(lambda1+lambda2)
                power=1.5*normeOfGrad(i,j)/level;
                v = blurredImage(i,j)+...
                    (image(i,j)-blurredImage(i,j))*...
                      (abs(cos(theta-theta0)).^power);
                image3d(i,j,:)=reshape(v,[1 1 thetaNumber]);
            else
%                 image3d(i,j,:)=image(i,j)/thetaNumber;
                image3d(i,j,:)=1; % will anyway be renormalised at the end
            end
        end
    end
end
optionProjection.type=typeProjection;
optionProjection.normalizeAfterProjection='none';

image0=projectBack(image3d, optionProjection);

% normally image0, output of projectBack, won't have zeros in it,
% but just in case we arrange this problem :
% normally the abs is not necessary because all is positive but just in case :
image0(abs(image0) < 0.0001)=0.0001; %!!!
renormalizationMatrix=image./image0;
image3d=multiplie2Det3D(renormalizationMatrix, image3d);

% we can add a security here that would
% discard very high values of image3d. Like :
image3d(image3d>30)=30; %!!!


end

