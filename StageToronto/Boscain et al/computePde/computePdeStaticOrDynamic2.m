function [ image3dProjectedIn2D, result] =...
 computePdeStaticOrDynamic2(imageInReconstr, good, options)

global image0;
global image3d;
global computeAllExponentialMatrices;

pause(1);
imageDebut=imageInReconstr;
optionPde = options.pde;
optionProjection =options.projection;
optionLift=options.lift;
[image3d, renormalizationMatrix]=lift( imageInReconstr, optionLift );
nameDirSavePictures=...
    saveParameters(options, imageInReconstr, image3d,...
    '../../Output/BoscainEtAl/staticRestoration/');
save([nameDirSavePictures 'image3dBeginning.mat'],'image3d');
% sliderForExploration(); % de image3d
% fprintf('Appuyez sur une touche pour continuer.\n');
% pause;
figure, imagesc(renormalizationMatrix); drawnow;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
thetaNumber=optionLift.thetaNumber;
[Mx,My]=size(imageInReconstr);
M=sqrt(Mx*My);
bad=1-good;
logicalBad=logical(bad);
se=strel('square',3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Verification that image3d contains what it should

% normally h is approximately equal to image at the beginning
% it's the exact same only if the projection is the inverse of the lift
% which is not necessarily the case
% but which can be forced to be the same in an automatic way (TODO).
image3dProjectedIn2D=projectBack( image3d, optionProjection );
figure, imagesc(image3dProjectedIn2D), colormap(gray), axis off; drawnow;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Weighted or not weighted : other definitions for the PDE
% Useful if we use Cranck-Nicholson or if we want to define
% the exponential matrices in this script

if ~optionPde.weighted
    [alpha,T,n,eps]=deal(optionPde.params{:});
    dt=T/n;
    betaN=(optionLift.thetaNumber/(2*pi))^2 * alpha; 
    b=1; 
    a=betaN;
    [D3,D6,D7]=getTimeParams(good, T, n);
end


% The one we will mix with the image :
imageInReconstrGood=imageInReconstr;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define the matrices' exponentials

global matricesExponentielles;

%%%%%%%%%%%%%%%%%%%%%
% Comment this zone if you have already defined the matrices' exponentials
% matricesExponentielles=zeros(30,30,256,256);
% for k=1:Mx
%     for l=1:My
%         matricesExponentielles(:,:,k,l)=...
%           expm(dt*derivOfKl(a,b,k,l));
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
% Optionnal : cut the high frequencies and those who have a near-1
% largest eigenvalue
% A priori don't uncomment this zone
% semiSize=10;
% matricesExponentielles(:,:,129-semiSize:129+semiSize,129-semiSize:129+semiSize)=0;
% matricesExponentielles(:,:,256-semiSize:256,129-semiSize:129+semiSize)=0;
% matricesExponentielles(:,:,1:1+semiSize,129-semiSize:129+semiSize)=0;
% matricesExponentielles(:,:,129-semiSize:129+semiSize,1:1+semiSize)=0;
% matricesExponentielles(:,:,129-semiSize:129+semiSize,256-semiSize:256)=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stop button (stop at the end of the current step of the loop when closed)

% S.fh = figure('units','pix',...
%               'pos',[400 400 120 50],...
%               'menubar','none',...              
%               'name','GUI_11',...
%               'numbertitle','off',...
%               'resize','off');
% S.pb = uicontrol('string','Stop Loop!',...
%                  'callback',{@pb_call},...
%                  'units','pixels',...
%                  'fontsize',11,...
%                  'fontweight','bold',...
%                  'position',[10 10 100 30]);
% drawnow;
% numFig=S.fh.Number;

numFig=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cas où on ne veut pas montrer l'evolution

if optionPde.dontShow
    figH = figure(numFig+1);
    set(figH, 'visible', 'off');
    figH2 = figure(numFig+2);
    set(figH2, 'visible', 'off');
    figH3 = figure(numFig+3);
    set(figH3, 'visible', 'off');
    figH4 = figure(numFig+4);
    set(figH4, 'visible', 'off');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PDE

% figure
listeVariations2D=[];
variation2D=1; % not defined in fact but to enter in the loop
% listeVariations3D=[];
psnrList=[psnr(image0, imageInReconstr)];
dateDebut=now;
goodLogical=logical(good);
goodLogical2=goodLogical;
i=0;
% while i<n
%variation2D >= 3.8e-5 && i<400
% variation2D >= 2e-5 && i<500 
while i<n 
    tic
    image3dProjectedIn2D_old=image3dProjectedIn2D;
%     image3d_old=image3d;
    image3dFourier=fft2(image3d);
%     if(~optionPde.weighted)
        for k=1:Mx
            %disp(['Calculating line number ',num2str(k)]);
            for l=1:My
                v=image3dFourier(k,l,:);
%                 matrice=derivOfKl(a,b,k,l);
%                 w=(id-0.5*dt*matrice)\...
%                 ((id+0.5*dt*matrice)*v(:));
%                 w=getExpMat(k,l)*v(:);
%                 w=matricesExponentielles(:,:,k,l)*v(:);
                if(computeAllExponentialMatrices)
                    w=matricesExponentielles(:,:,k,l)*v(:);
                else
                    w=getExpMat(k,l)*v(:);
                end
                image3dFourier(k,l,:)=reshape(w,[1 1 thetaNumber]);
            end
        end
        % normally abs is not necessary but just in case (to avoid negative
        % values which could cause bugs),
        % we can use abs(real(...)) instead of just real(...).
        image3d=abs(real(ifft2(image3dFourier)));

%     else % if the PDE is weighted :        
%     end % fin du cas weighted
    
    
    image3dProjectedIn2D=projectBack( image3d, optionProjection );
    
    % We mix the image with the true image
    for ii=1:Mx
        for jj=1:My
            if goodLogical(ii,jj)
                % normally abs useless but just in case
%                     k=max(abs(image3d(i,j,:)),[],3);
                k=image3dProjectedIn2D(ii,jj);
%                     if(k > 0.5/(255*thetaNumber)) 
                if(abs(k) > 1e-10) 
                    coeff = (1-eps) + ...
                        eps*imageInReconstr(ii,jj)/k;
                    image3d(ii,jj,:)=image3d(ii,jj,:)*coeff;
                else
                    image3d(ii,jj,:)=...
                    eps*imageInReconstr(ii,jj)*ones(1,1,thetaNumber);
                end
            end
        end
    end
    % We reproject now that image3d has been modified
    image3dProjectedIn2D=projectBack( image3d, optionProjection );

    % We compute the differences 
    variation2D=variationAvantApres(image3dProjectedIn2D_old,image3dProjectedIn2D);
    listeVariations2D=[listeVariations2D variation2D];
%     temp=variationAvantApres(image3d_old,image3d);
%     listeVariations3D=[listeVariations3D temp];
    psnrNow=psnr(image0, normalizeAfterProjectionFun(image3dProjectedIn2D, 'nearestVect2'));
    psnrList=[psnrList psnrNow];
    fprintf('variation2d : %d\npsnr : %d\n',variation2D, psnrNow);
    
%%%%%%%%%%%%%%%%%%%%%%%
% If we are in dynamic mode, imageInReconstrGood and logicalBad should
% evolve
    i=i+1;
    
    if(strcmp(optionPde.type,'dynamic2'))
        tnow = dt*i;
        goodLogical2 = (D6 <= tnow);
%         goodLogical2 = (D7 <= i); % 
        goodLogical = goodLogical | goodLogical2;
        imageInReconstr(goodLogical) = image3dProjectedIn2D(goodLogical);
    elseif strcmp(optionPde.type,'dynamic')
        logicalBad= ~goodLogical;
        frontiere=logicalBad & (~imerode(logicalBad,se));
        for u=1:Mx
            for v=1:My
                if(frontiere(u,v))
                    petiteSomme=0;
                    petitNb=0;
                    for uu=max(1,u-1):min(Mx,u+1)
                        for vv=max(1,v-1):min(My,v+1)
                            if(logicalBad(uu,vv))
                                petitNb=petitNb+1;
                                petiteSomme=petiteSomme+image3dProjectedIn2D(uu,vv);
                            end
                        end
                    end
                    valueToCompareWith=petiteSomme/petitNb;
                    if(valueToCompareWith <= image3dProjectedIn2D(u,v))
                        logicalBad(u,v)=false;
                        imageInReconstr(u,v)=image3dProjectedIn2D(u,v);
                    end
                end
            end
        end
        goodLogical=~logicalBad;
    end
    
    toc
    
    fprintf('Step number %d out of %d finished.\n', i, n);
    
    if ~optionPde.dontShow
        figure(numFig+1), imshow2(image3dProjectedIn2D);
        if strcmp(optionPde.type,'dynamic') || strcmp(optionPde.type,'dynamic2')
            figure(numFig+2); imshow(goodLogical), colormap(gray), axis off; 
        end
        figure(numFig+3), plot(listeVariations2D);%3.8001e-05
        figure(numFig+4), plot(psnrList);
    end
    

    if(mod(i,optionPde.automaticSaveImageEachHowManySteps)==0)
        name= datestr(now,'yyyy-mm-dd_HH_MM_SS_FFF');
        name2=[name sprintf('_step%04d.png', i)];
        sauvegarde = normalizeAfterProjectionFun(image3dProjectedIn2D,'maxAndMin');
        imwrite(sauvegarde,[nameDirSavePictures name2]);
        name3 = [name sprintf('_good_%d.png',i)];
        imwrite(goodLogical, [nameDirSavePictures name3]);
    end

    drawnow;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The loop is finished : we copy the results

dateFin=now;
% datestr(now,'yyyy_mm_dd-HH_MM_SS-FFF')
timeString=datestr(dateFin-dateDebut,'HH_MM_SS_FFF');
fileID = fopen([nameDirSavePictures 'duree.txt'],'w');
fprintf(fileID,timeString);
fclose(fileID);

save([nameDirSavePictures 'listeVariations2D.mat'],'listeVariations2D',...
    '-ascii');
save([nameDirSavePictures 'psnrList.mat'],'psnrList','-ascii');
save([nameDirSavePictures 'image3dEnd.mat'],'image3d');

result=normalizeAfterProjectionFun(1-image3dProjectedIn2D,'maxAndMin');
imwrite(...
    result,...
    [nameDirSavePictures 'FinalResult.png']);
figure, imagesc(result), colormap gray;

imwrite(imageDebut,[nameDirSavePictures 'inputTrue.png']);
% figure, imagesc(1-imageInReconstr), colormap gray;

function [] = pb_call(varargin)
% Callback for pushbutton
delete(S.fh)  % Delete the figure.
end

end


