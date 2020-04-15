%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TP6 d'apprentissage artificiel : segmentation d'une image par la texture %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Le TP6 se deroule en trois etapes :
% 1) Segmentation en classes predefinies (modele de Potts 4-connexe ou 8-connexe).
% 2) Segmentation par classification supervisee.
% 3) Debruitage (deux methodes).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Etape 1 : segmentation en classes predefinies (modele de Potts 4-connexe) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function segmentation(T_0,q_max,alpha,beta)

% Parametres par defaut de la methode de segmentation :
% A DECOMMENTER
if nargin==0
	T_0 = 1.0;
	q_max = 150;
	alpha = 0.99;
	beta = 1.0;
end
intervalle_entre_affichages = 10;
temps_affichage = 0.5;

% Lecture et affichage de l'image d'origine :
% A DECOMMENTER
x = imread('image.bmp');
x = double(x);
[nb_lignes,nb_colonnes] = size(x);
figure('Name','Image d''origine','Position',[0,0,550,500]);
imagesc(x);
axis('image');
nb_nvg = 256;
colormap(gray(nb_nvg));

% Parametres des classes de pixels :
% A DECOMMENTER
moyennes_variances = [ 36.0 400.0 ; 72.0 400.0 ; 108.0 400.0 ; 144.0 400.0 ; 180.0 400.0 ; 216.0 400.0 ];
nb_classes = size(moyennes_variances,1);

% Initialisation aleatoire des classes :
% A DECOMMENTER
k = zeros(nb_lignes,nb_colonnes);
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		k(i,j) = ceil(rand*nb_classes);
	end
end
figure('Name','Image segmentee','Position',[550,0,550,500]);
imagesc(k);
axis('image');
colormap(autumn);
hold on;
pause(temps_affichage);

probas = zeros(nb_classes,1);

% Boucle du recuit simule :
% A COMPLETER/DECOMMENTER
T = T_0;
for q = 1:q_max
	for i = 1:nb_lignes
		for j = 1:nb_colonnes
			% Energie correspondant a la vraisemblance (attache aux donnees) :
            for classe_nouvelle = 1:nb_classes
              energie_nouvelle = ...
              0.5*log(moyennes_variances(classe_nouvelle,2))+...
              (x(i,j)-moyennes_variances(classe_nouvelle,1))^2/(2*moyennes_variances(classe_nouvelle,2));
                % Energie correspondant a l'a priori (modele de Potts 8-connexe) :
                if i>1
                    energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i-1,j));
                end
                if j>1
                    energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i,j-1));
                end
                if i<nb_lignes
                    energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i+1,j));
                end
                if j<nb_colonnes
                    energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i,j+1));
                end
                if i>1 && j>1
                    energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i-1,j-1));
                end
                if i<nb_lignes && j>1
                    energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i+1,j-1));
                end
                if i>1 && j<nb_colonnes
                    energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i-1,j+1));
                end
                if i<nb_lignes && j<nb_colonnes
                    energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i+1,j+1));
                end
                probas(classe_nouvelle)=exp(-energie_nouvelle/T);
            end
            probas=probas/sum(probas);
			bbb=rand;
            s=0;
            aaa=1;
            while s<bbb
                s=s+probas(aaa);
                if(s<bbb)
                    aaa=aaa+1;
                end
            end
            k(i,j)=aaa;
		end
	end
	if rem(q,intervalle_entre_affichages)==0
		imagesc(k);
		pause(temps_affichage);
		title(['Pas ' num2str(q) '/' num2str(q_max)]);
	end
	T = alpha*T;
end

% Calcul du pourcentage de pixels correctement classes :
% A DECOMMENTER
load classification_OK
pixels_correctement_classes = find(k==y2);
disp(['Pixels correctement classes : ' num2str(100*length(pixels_correctement_classes(:))/(nb_lignes*nb_colonnes),'%.2f') ' %'])
