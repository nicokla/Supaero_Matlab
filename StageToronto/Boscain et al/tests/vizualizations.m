%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This code is to vizualize the data (exponential matrices, image3d, angles,
% anisotropy )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global image3d;

%% Exponential matrices :
% depending on if you defined all the exponential matrices or only 1/8th
% you should comment code in sliderForExporation2 :
% Use matricesExponentielles in the first case, getExpMat in the 2nd case.
sliderForExploration2();

maxVal=zeros(Mx,My);
for i=1:Mx
    for j=1:My
        if(computeAllExponentialMatrices)
            maxVal(i,j)=max(max(...
                matricesExponentielles(:,:,round(i), round(j))));
        else
            maxVal(i,j)=max(max(getExpMat(round(i), round(j))));
        end
    end
end
imagesc(maxVal);

%%%%%%%%%%%%%%%%%%%%%%%%%
%% Image3d

image3d=lift( imageInReconstr, optionLift );
sliderForExploration();

image3dProjectedIn2D=projectBack( image3d, optionProjection );
figure, imagesc(image3dProjectedIn2D), colormap(gray), axis off; drawnow;

%7:11
%24+((-2):2)
image3dProjectedIn2D=projectBack( image3d(:,:,[28:30, 1:2]), optionProjection );
figure, imagesc(image3dProjectedIn2D), colormap(gray), axis off; drawnow;

indice=22;
fourierOfFloor=fftshift(abs(fft2(image3d(:,:,indice))));
sc(fourierOfFloor,'gray');
sc(image3d(:,:,indice));

image1=image3dProjectedIn2D; semiSize=1; thickness=2; color=[1 0 0];
otherArgs=[];
func=@(image3d,x,y) plot((0:6:(180-6)),reshape(image3d(x,y,:),[thetaNumber 1]));
analyseClic2D( image1, semiSize, thickness, color, func, image3d);

copyVec=@(v)v([(1:end) (1:end)]);
func2=@(image3d,x,y) plot((0:6:(360-6)),...
    copyVec(reshape(image3d(x,y,:),[thetaNumber 1])));
analyseClic2D( image1, semiSize, thickness, color, func2, image3d);

%%%%%%%%%%%%%%%%%%%%%%
%% Angles discretises

defaultMin=[0 0 0   0 0];
defaultMax=[2 2 0.2 2 1];
defaultVal=[0.9299 0.3832 0 0 0];%paramGradLift 0
pause(1); % necessaire avant funcslider sinon bug pour une raison inconnue
a=funcslider(@calculThings, 'plotDiscreteAngles(z1,z2)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Anisotropy
defaultMin=[0 0 0 0 0];
defaultMax=[10 10 1 1 1];
defaultVal=[2 2 0 0 0];
pause(1); % necessaire avant funcslider sinon bug pour une raison inconnue
funcslider2(@getAnisotropy, 'imagesc(z1);colorbar;');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Gradient
defaultMin=[0 0 0 0 0];
defaultMax=[2 2 1 1 1];
defaultVal=[0.9299 0.3832 0 0 0];
pause(1); % necessaire avant funcslider sinon bug pour une raison inconnue
funcslider2(@getGradient, 'imagesc(z1);colorbar;');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Angles, anisotropy, gradient (plot all of them at the same time)
defaultMin=[0 0 0 0 0];
defaultMax=[2 2 0.2 1 1];
defaultVal=[0.32 1.1 0 0 0];
pause(1); % necessaire avant funcslider sinon bug pour une raison inconnue
a=funcslider(@calculThings2, 'plotDiscreteAngles2(z1,z2,z3,z4)');

%%%%%%%%%%%%%%%%%%%%%%
%% Angles reels au lieu de discretises

defaultMin=[0 0 0   0 0];
defaultMax=[2 2 0.2 2 1];
defaultVal=[0.9299 0.3832 0 0 0];%paramGradLift 0
pause(1); % necessaire avant funcslider sinon bug pour une raison inconnue
a=funcslider(@calculThings3, 'plotContinuousAngles(z1,z2)');

%%%%%%%%%%%%%%%%%%%%%%%%ù
%% Ellipses
defaultMin=[0 0 1   0 0];
defaultMax=[2 2 20 2 1];
defaultVal=[0.9299 0.3832 8 0 0];%paramGradLift 0
pause(1); % necessaire avant funcslider sinon bug pour une raison inconnue
a=funcslider(@calculThings4, 'plotAnglesEllipses(z1,z2)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fonction qui calcule les angles (utilisée dans les précédents displays)

order=2;
displayThings=false;
sigma_gradient=0;
sigma_tenseur=0.6168;
[ S, lambda1, lambda2, e1, e2,...
normeOfGrad, anisotropy, anisotropyLog,...
anglesExacts, anglesApprox] = ...
getAngles(image0, good, sigma_tenseur,...
sigma_gradient, thetaNumber, order, displayThings);
canBeLifted = (normeOfGrad >= 0.0863) & (anisotropy >= 0.1869);
plotDiscreteAngles(anglesApprox, canBeLifted);
imshow(isnan(anglesExacts));
imshow(isnan(anglesExacts));
% imshow(e1(:,:,2)==0);


