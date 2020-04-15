%% Nettoyage des variables et figures
clear all;
close all;

%% Image

% Zebre
name_file='zebre.gif';
image=imread(name_file);
image=double(image)/255;
[nl,nc] = size(image);

% Mer
% name_file='mer.gif';
% image=imread(name_file);
% image=double(image)/255;
% [nl,nc] = size(image);
% imshow(image);


%% Variance
se=strel('disk', 12);
voisinage = se.getnhood();
variance=stdfilt(image, voisinage);
%imagesc(variance);
variance_int=uint8(variance*255);
imwrite(variance_int,'zebre_variance.gif');


%% Choix des pixels
%delete('*.gif.app');
SVMManualTrain;


%% Conversion du fichier resultant en vecteurs
n=2;
clear image_totale ;
image_totale(:,:,1)= image;
image_totale(:,:,2)= variance;
[ val_pix_app_champs, val_pix_app_ville ] = ...
    converti('zebre.gif.app',image_totale,n);
N_champs=size(val_pix_app_champs,1);
N_ville=size(val_pix_app_ville,1);
xapp=[val_pix_app_champs;val_pix_app_ville];
yapp = [-ones(N_champs,1); ones(N_ville,1)];


%% Calcul du svm
C=1; %margin
% Utiliser optimset ou svmsmoset (les deux fonctionnent)
option  = fitcsvm('MaxIter',50000, 'TolKKT', 1e-3, 'KKTViolationLevel', 0);

% Noyau gaussien  
sigma=1;
%aaa=svmtrain(xapp,yapp, 'Kernel_Function', 'rbf' ,...
 %   'RBF_Sigma', sigma, 'Method', 'QP', 'BoxConstraint', C,...
  %  'Showplot', true, 'QuadProg_Opts', option);

aaa=fitcsvm(xapp,yapp, 'KernelFunction', 'RBF', 'KernelScale','auto');

% Noyau polynomial
% deg=3;
% aaa=svmtrain(xapp,yapp, 'Kernel_Function', 'polynomial' ,...
%     'Polyorder', deg, 'Method', 'QP', 'BoxConstraint', C,...
%     'Showplot', true, 'QuadProg_Opts', option);

xlabel('Luminosite');
ylabel('Variance');

%%%%%
%% Calcul de la fonction
image_totale = reshape(image_totale, nl*nc,n);
image_totale2=image_totale;

sv = aaa.SupportVectors;
alphaHat = aaa.Alpha;
bias = aaa.Bias;
kfun = aaa.KernelParameters.Function % aaa.KernelFunction;
kfunargs = aaa.KernelParameters.Scale % aaa.KernelFunctionArgs;
for c = 1:size(image_totale, 2)
    image_totale2(:,c) = aaa.ScaleData.scaleFactor(c) * ...
        (image_totale(:,c) +  aaa.ScaleData.shift(c));
end
f = (feval(kfun,sv,image_totale2,kfunargs{:})'*alphaHat(:)) + bias;
f=reshape(f,nl,nc);
figure,imagesc(f);

% représentation dans l'espace de décision
% cf svmclassify.m ligne 115 ---> svmdecision.m
if (n==1) % 1 paramètre utilisé : niveau de gris
    x_val=0:0.01:1;
    g=aaa.ScaleData.scaleFactor*(x_val'+aaa.ScaleData.shift);
    g=(feval(kfun,sv,g,kfunargs{:})'*alphaHat(:)) + bias;
    plot(x_val,g); hold on;
    plot(x_val, 0);
else
if n==2 % 2 paramètres utilisés : niveau de gris et variance
    a1 = linspace(min(image(:)),max(image(:)));
    a2 = linspace(min(variance(:)),max(variance(:)));
    [xtesta1,xtesta2]=meshgrid(a1,a2);
    [na,nb] = size(xtesta1);
    xtest1=reshape(xtesta1,1,na*nb);
    xtest2=reshape(xtesta2,1,na*nb);
    xtest=[xtest1;xtest2]';
    for c = 1:size(xtest, 2)
        ypred(:,c) = aaa.ScaleData.scaleFactor(c) * ...
            (xtest(:,c) +  aaa.ScaleData.shift(c));
    end
    ypred=(feval(kfun,sv,ypred,kfunargs{:})'*alphaHat(:)) + bias;
    ypredmat=reshape(ypred,na,nb);
    %ind1=find(ypred>0);
    %indm1=find(ypred<0);
    figure
    contourf(xtesta1,xtesta2,ypredmat,50);shading flat;
    hold on
    [cs,h]=contour(xtesta1,xtesta2,ypredmat,[0 0 0],'k');
end
end



%% Classification avec la SVM

bbb=svmclassify(aaa,image_totale);%,'ShowPlot',true);
bbb=reshape(bbb,nl,nc);
%bbb=f>0; % equivalent aux deux lignes precedentes
bbb=(bbb==1);
figure, imagesc(bbb);  

figure, imshow(image.*double(bbb));
image_totale = reshape(image_totale, nl, nc, n);


%% Post traitement

% on reconnecte les morceaux detaches du zebre
bbb2=imclose(bbb,strel('disk',3));
imagesc(bbb2)

% on enleve les composantes connexes parasites
[L,num]=bwlabel(bbb2,8);
imagesc(L); % on choisit le numero du zebre
a2=L==3;
imagesc(a2);

% on enleve les trous
a3=1-a2;
[L2,num2]=bwlabel(a3);
imagesc(L2);
a4=L2==1; % on choisit le numero du fond
a5=1-a4;
imagesc(a5);

% on lisse les contours
se=strel('disk',4);
a6=imclose(a5,se);
imshow(a6);
imshow(a6.*image);




