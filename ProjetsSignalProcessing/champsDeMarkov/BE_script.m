% BE Champs de Markov

%% Loading and showing data (et construction de la texture a partir des
% zones

% Vrai classification
load classification_OK
figure, imagesc(y2);
colormap(autumn);
% on observe 3 pixels isoles

% Vrai image faite avec les parametres moyennes/variances suivants :
%[ 36.0 400.0 ; 72.0 400.0 ; 108.0 400.0 ; 144.0 400.0 ; 180.0 400.0 ; 216.0 400.0 ];
% Une variance de 400 signifiant un ecart type de 20, c'est donc
% la luminosité moyenne (+ ou -) 20 à 68% de proba, et (+ ou -) 40 à 95% de proba.
x = imread('image.bmp'); x=double(x);
figure, imagesc(x); colormap(gray);
figure; histo1=histc(x(:),0:255); bar(0:255,histo1); axis([-1 256 0 max(histo1)*1.1]);
% on voit bien le pic à 72 et celui à 180 mais pas aussi bien les autres
% cela est dû au fait que les classes 2 et 5 sont les plus étendues en
% nombre de pixels
% on remarque qu'il y a pas mal de pixels à 0 ou 255, cela est dû au fait
% qu'on a obtenu des valeurs négatives ou supérieures à 255 qu'on a
% seuillé, les forçant à 0 ou 255.

% prenons un echantillon de pixels de la derniere classe pour regarder sa
% moyenne et sa variance
g=x(1:10,1:10);
moy_g=mean(g(:)); % 215 environ
std_g=std(g(:)); % standard deviation de 18 environ
figure; histo2=histc(g(:),0:255); bar(0:255,histo2); axis([-1 256 0 max(histo2)*1.1]);
% 215 est proche de 216, et 18 est proche de 20, donc c'est coherent

% Reconstruisons nous-même une telle image avec randn
moyennes = 36:36:36*6;
std_pix = 20;
x2=zeros(size(y2));
for i = 1:size(y2,1)
    for j = 1:size(y2,2)
        classe = y2(i,j);
        intensite = moyennes(classe)+std_pix*randn;
        intensite = max(intensite, 0);
        intensite = min(intensite, 255);
        x2(i,j)=intensite;
    end
end
figure, imagesc(x2); colormap(gray);
figure; histo1=histc(x2(:),0:255); bar(0:255,histo1); axis([-1 256 0 max(histo1)*1.1]);
% on observe bien une image et un histogramme semblables à l'image "image.bmp"


%% 1) Segmentation en classes predefinies

% segmentation(T_0,q_max,alpha,beta);
% T_0 est la temperature de depart
% q_max est le nb d'iterations du recuit
% alpha est le facteur de decroissance de la temperature
% beta determine l'importance des voisins

% 4-connexe
segmentation(1.0, 150, 0.99, 1.0) ;
segmentation(2.0, 250, 0.99, 5.0) ;
segmentation(1.0, 150, 0.9, 2.0) ; % Pixels correctement classes : 96.06 %
segmentation(1.0, 250, 0.995, 2.0) ; % Pixels correctement classes : 99.80 %

% 8-connexe
segmentation_8(1.0, 150, 0.99, 0.5) ; % Pixels correctement classes : 99.27 %
segmentation_8(2.0, 250, 0.99, 2.5) ;
segmentation_8(1.0, 150, 0.9, 1.0) ;
segmentation_8(1.0, 250, 0.995, 1) ; % Pixels correctement classes : 99.75 %

% Gibbs
segmentation_Gibbs(1.0, 40, 0.99, 0.5) ;
segmentation_Gibbs(2.0, 40, 0.99, 2.5) ;
segmentation_Gibbs(1.0, 40, 0.9, 1.0) ;
segmentation_Gibbs(1.0, 40, 0.995, 1.5) ;% Pixels correctement classes : 99.72 %


%% 2) Segmentation par classification supervisee

segmentation_supervisee(1.0, 250, 0.995, 2.0) ; 


%% 3) Debruitage

debruitage_1(1.0, 250, 0.995, 2.0,x);
% Pixels correctement classes : 99.84 %
% Limitation : le nombre d'intensités possibles pour chaque pixels diminue
% (il passe de 256 au nombre de classes).

% debruitage_2(1.0, 250, 0.995, 0.2);
% debruitage_2(30.0, 250, 0.995, 0.5);
debruitage_2(1000.0, 250, 0.995, 1,x);
% Pixels correctement classes : 95.98 %
% On voit des erreurs de classification aux frontieres entre les classes car les 
% moyennes sont intermediaires dans ces zones.
% La méthode nécessite une température plus haute au début que pour la premiere methode,
% une partie de l'explication vient du fait que les energies sont plus
% grandes, et que pour obtenir des probabilites semblables, la temperature
% doit suivre l'ordre de grandeur de l'energie de la meme maniere
% Mais l'avantage est qu'on n'a pas à connaitre de variances de chaque
% classe ici.


% pour une image reelle :
im0 = double(imread('cameraman.tif'));
figure, imagesc(im0);  colormap(gray);
im0_bruitee=double(cameraman_bruite(20));
std1 =sqrt(mean(mean((im0-im0_bruitee).^2)));
snr1 = 10*log(norm(im0,'fro')/norm(im0-im0_bruitee,'fro'));% 19.4487

im0_deb1=debruitage_1(1.0, 250, 0.995, 2.0,im0_bruitee);
snr2 = 10*log(norm(im0,'fro')/norm(im0-im0_deb1,'fro'));% 20.4317
im0_deb2=debruitage_2(1000.0, 250, 0.995, 0.5 ,im0_bruitee);
snr3 = 10*log(norm(im0,'fro')/norm(im0-im0_deb2,'fro')); % 20.0031
imagesc(im0_deb2);  colormap(gray);
% le mieux serait de selectionner les classes, car ici elles sont reparties
% regulierement dans l'intervalle [0 255] mais ça ne correspond pas aux
% zones de l'image, ce n'est pas optimal. Ainsi on perd des détails : par
% exemple la main du photographe disparait.


% avec le choix des classes :
im0_deb1_supervise=debruitage_1_supervise(1.0, 250, 0.995, 2.0,im0_bruitee,10);
snr_deb1_supervise = 10*log(norm(im0,'fro')/norm(im0-im0_deb1_supervise,'fro')); % 22.1698

% avec plus de classes mais sans le choix des classes :
im0_deb2_nbClassesReglable=debruitage_2_nbClassesReglable(1000.0, 250, 0.995, 0.7 ,im0_bruitee,12);
snr = 10*log(norm(im0,'fro')/norm(im0-im0_deb2_nbClassesReglable,'fro')); % 21.56
imagesc(im0_deb2_nbClassesReglable);  colormap(gray);
im0_deb1_nbClassesReglable=debruitage_1_nbClassesReglable(100, 500, 0.995, 20 ,im0_bruitee,10);
snr = 10*log(norm(im0,'fro')/norm(im0-im0_deb1_nbClassesReglable,'fro')); % 21.56


%% 4) Prise en compte de la texture dans la segmentation

village=double(imread('village.gif'));
% village=village/max(max(village));

% villageVar5 = UrbanDetec5(village,9); % pas optimisé, 10 secondes
% villageVar3 = UrbanDetec3(village,9); % un peu optimisé, 4 secondes
% villageVar1 = UrbanDetec(village,9); % très optimisé, 1/2 seconde
%[E1,E2] = UrbanDetec4(village,9); % version pas assez optimisée, trop
%longue

[E1,E2] = UrbanDetec6(village,13); % très optimisé, attente ok.
E1=E1/max(max(E1));
E2=E2/max(max(E2));
imagesc(E1), figure, imagesc(E2);
% imwrite(E1, 'E1_13.png', 'png');
% imwrite(E2, 'E2_13.png', 'png');
% E1=double(imread('E1.png'));
% E2=double(imread('E2.png'));

classif1 = segmentation_supervisee_gen(10, 50, 0.9, 2, E1, 2); 
classif2 = segmentation_supervisee_gen(10, 40, 0.9, 4, E2, 2);

classif=classif2;
subplot(1,2,1), imagesc(village.*double(classif==1)), colormap(gray);
subplot(1,2,2), imagesc(village.*double(classif==2)), colormap(gray);





