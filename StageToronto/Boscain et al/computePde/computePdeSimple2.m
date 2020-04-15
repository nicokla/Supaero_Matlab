function [ image3d, h ] =...
    computePdeSimple2(imageInReconstr, good, options)
% Here it would be with the exponential matrices having been
% already computed, so it's different from computePdeSimple
% It needs the good dt. To compute it use
% defineExpMat2 in order to use less memory :
%  defineExpMat2( Mx,My,thetaNumber,scheme,a,b,dt )

global matricesExponentielles;
global computeAllExponentialMatrices;

optionPde = options.pde;
optionProjection =options.projection;
optionLift=options.lift;
[image3d, renormalizationMatrix]=lift( imageInReconstr, optionLift );
nameDirSavePictures=...
    saveParameters(options, imageInReconstr, image3d,...
    '../../Output/BoscainEtAl/simpleHypoellipticDiffusion/');

% figure, imagesc(renormalizationMatrix); drawnow; % pause


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
thetaNumber=optionLift.thetaNumber;
[alpha,T]=deal(optionPde.params{:});
betaN=(thetaNumber/(2*pi))^2 * alpha; 
b=1; a=betaN;
[Mx,My]=size(good);
M=sqrt(Mx*My);
thetaNumber=size(image3d,3);


theta=linspace(0,pi-pi/thetaNumber,thetaNumber);
cosTheta=cos(theta);
sinTheta=sin(theta);
sinSin=sinTheta.^2;
cosCos=cosTheta.^2;
cosSin=cosTheta.*sinTheta;
funBase=@(x) 2*pi*(x-1)/M;

mat2=-diag(2*ones(1,thetaNumber))+diag(ones(1,thetaNumber-1),1)+...
    diag(ones(1,thetaNumber-1),-1);
mat2(1,end)=1; mat2(end,1)=1; %mat2=mat2/2;
mat2=sparse(mat2);

if(strcmp(optionPde.scheme,'schemeArticle'))
    diagOfFreqs=@(k,l) sparse(1:thetaNumber,1:thetaNumber,...
     cosTheta*sin(2*pi*(k-1)/Mx) + sinTheta*sin(2*pi*(l-1)/My));
    derivOfKl=@(a,b,k,l)0.5*(a*mat2-b*M*diagOfFreqs(k,l).^2);
elseif(strcmp(optionPde.scheme,'scheme2'))
    diagOfFreqs=@(k,l)sparse(1:thetaNumber,1:thetaNumber,...
        2*cosCos*(cos(funBase(k)) - 1) + ...
        2*sinSin*(cos(funBase(l)) - 1) + ...
        cosSin*(cos(funBase(k)+funBase(l)) - cos(funBase(k)-funBase(l))));
    derivOfKl=@(a,b,k,l)0.5*(a*mat2+b*M*diagOfFreqs(k,l));
elseif(strcmp(optionPde.scheme,'scheme3'))
    diagOfFreqs=@(k,l)sparse(1:thetaNumber,1:thetaNumber,...
    2*cosCos*(cos(funBase(k)) - 1) + ...
    2*sinSin*(cos(funBase(l)) - 1) + ...
    cosSin*(cos(funBase(k))+cos(funBase(l))-cos(funBase(k)-funBase(l))...
    -1));
    derivOfKl=@(a,b,k,l)0.5*(a*mat2+b*M*diagOfFreqs(k,l));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dateDebut=now;
image3dFourier=fft2(image3d);
for k=1:Mx
    for l=1:My
        v=image3dFourier(k,l,:);
%         matrice=derivOfKl(a,b,k,l);
%         w=expm(T*matrice)*v(:);
        if(computeAllExponentialMatrices)
            w=matricesExponentielles(:,:,k,l)*v(:);
        else
            w=getExpMat(k,l)*v(:);
        end
        image3dFourier(k,l,:)=reshape(w,[1 1 thetaNumber]);
    end
end

image3d=real(ifft2(image3dFourier));
h=projectBack( image3d, optionProjection );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dateFin=now;
timeString=datestr(dateFin-dateDebut,'HH_MM_SS_FFF');
fileID = fopen([nameDirSavePictures 'duree.txt'],'w');
fprintf(fileID,timeString);
fclose(fileID);

h=h/max(h(:));

imwrite(h,...%normalizeAfterProjectionFun(1-h,'maxAndMin'),...
    [nameDirSavePictures 'FinalResult.png']);
imwrite(imageInReconstr,[nameDirSavePictures 'inputTrue.png']);


subplot(1,2,1), imagesc(imageInReconstr), colormap gray;
subplot(1,2,2), imagesc(h), colormap gray;

end






