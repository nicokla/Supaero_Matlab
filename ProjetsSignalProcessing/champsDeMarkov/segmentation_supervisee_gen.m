function k = segmentation_supervisee_gen(T_0,q_max,alpha,beta, x, nb_classes)

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
% x = imread('image.bmp');
% x = double(x);
[nb_lignes,nb_colonnes] = size(x);
figure('Name','Image d''origine','Position',[0,0,550,500]);
imagesc(x);
axis('image');
%nb_nvg = 256;
%colormap(gray(nb_nvg));
hold on;

% Apprentissage des parametres des classes de pixels :
% A DECOMMENTER
% nb_classes = 6;
couleurs = hsv(nb_classes);
moyennes_variances = estimation_parametres(x,nb_classes,couleurs);

% Permutation des classes pour pouvoir calculer le pourcentage de bonnes classifications :
% A DECOMMENTER
[valeurs,indices] = sort(moyennes_variances(:,1),'ascend');
moyennes_variances = moyennes_variances(indices,:);
couleurs = couleurs(indices,:);

% Initialisation aleatoire des classes :
% A DECOMMENTER
k = zeros(nb_lignes,nb_colonnes);
z = zeros(nb_lignes,nb_colonnes,3);
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		k(i,j) = ceil(rand*nb_classes);
		z(i,j,:) = couleurs(k(i,j),:);
	end
end
figure('Name','Image segmentee','Position',[550,0,550,500]);
imagesc(z);
axis('image');
hold on;
pause(temps_affichage);

% Boucle du recuit simule :
% A COMPLETER/DECOMMENTER
T = T_0;
for q = 1:q_max
	for i = 1:nb_lignes
		for j = 1:nb_colonnes
			classe_courante = k(i,j);
			classe_nouvelle = ceil(rand*nb_classes);
			while classe_nouvelle==classe_courante
				classe_nouvelle = ceil(rand*nb_classes);
			end

			% Energie correspondant a la vraisemblance (attache aux donnees) :
            % Attention : la variance est egale au carre de l'ecart-type sigma !
			energie_courante = ...
              0.5*log(moyennes_variances(classe_courante,2))+...
              (x(i,j)-moyennes_variances(classe_courante,1))^2/(2*moyennes_variances(classe_courante,2));
			energie_nouvelle = ...
              0.5*log(moyennes_variances(classe_nouvelle,2))+...
              (x(i,j)-moyennes_variances(classe_nouvelle,1))^2/(2*moyennes_variances(classe_nouvelle,2));

			% Energie correspondant a l'a priori (modele de Potts 4-connexe) :
			if i>1
				energie_courante = energie_courante+beta*(classe_courante ~= k(i-1,j));
				energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i-1,j));
			end
			if j>1
				energie_courante = energie_courante+beta*(classe_courante ~= k(i,j-1));
				energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i,j-1));
			end
			if i<nb_lignes
				energie_courante = energie_courante+beta*(classe_courante ~= k(i+1,j));
				energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i+1,j));
			end
			if j<nb_colonnes
				energie_courante = energie_courante+beta*(classe_courante ~= k(i,j+1));
				energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i,j+1));
			end
            if i>1 && j>1
                energie_courante = energie_courante+beta*(classe_courante ~= k(i-1,j-1));
                energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i-1,j-1));
            end
            if i<nb_lignes && j>1
                energie_courante = energie_courante+beta*(classe_courante ~= k(i+1,j-1));
                energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i+1,j-1));
            end
            if i>1 && j<nb_colonnes
                energie_courante = energie_courante+beta*(classe_courante ~= k(i-1,j+1));
                energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i-1,j+1));
            end
            if i<nb_lignes && j<nb_colonnes
                energie_courante = energie_courante+beta*(classe_courante ~= k(i+1,j+1));
                energie_nouvelle = energie_nouvelle+beta*(classe_nouvelle ~= k(i+1,j+1));
            end
            
			% Dynamique de Metropolis :
            if energie_nouvelle<energie_courante
				k(i,j) = classe_nouvelle;
            elseif rand <= exp(-(energie_nouvelle-energie_courante)/T)
                k(i,j) = classe_nouvelle;
            end
            z(i,j,:) = couleurs(k(i,j),:);
		end
	end
	if rem(q,intervalle_entre_affichages)==0
		imagesc(z);
		pause(temps_affichage);
		title(['Pas ' num2str(q) ' / ' num2str(q_max)]);
	end
	T = alpha*T;
end

% Calcul du pourcentage de pixels correctement classes :
% A DECOMMENTER
% load classification_OK
% pixels_correctement_classes = find(k==y2);
% disp(['Pixels correctement classes : ' num2str(100*length(pixels_correctement_classes(:))/(nb_lignes*nb_colonnes),'%.2f') ' %'])
