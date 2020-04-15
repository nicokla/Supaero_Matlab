%% cond_pix_app___________________________________________________________%
%                                                                         %
% a partir des pixels d'apprentissages de trois tailles differentes, cree %
% des vecteurs d'apprentissage pour le SVM et PP                          %
%                                                                         %
% Parametres d'entrée:                                                    %
%       - carre1 a carre3: coord du centre des zone d'app taille 1 a 3    %
%       - se1 a se3: facteur sous echantillonnage pour les trois tailles  %
%       - t1 a t3:taille descarrés d'apprentissage                        %
%                                                                         %
% Parametres de sortie:                                                   %
%       - pix_app: coordonnees de tous les pixels d'apprentissage         %
%                                                                         %
%_________________________________________________________________________%

function pix_app=cond_pix_app(carre1,carre2,carre3,t1,t2,t3,se1,se2,se3)

%recupere les coordonnees des pixels d'un carré a partir du centre du carre
if isempty(carre1)
    coord_carre1=[];
else
    coord_carre1=[];
    for i=1:size(carre1,1);
        coord_carre1=[coord_carre1;centre2pixapp(carre1(i,:),t1,se1)];
    end
end

if isempty(carre2)
    coord_carre2=[];
else
    coord_carre2=[];
    for i=1:size(carre2,1);
        coord_carre2=[coord_carre2;centre2pixapp(carre2(i,:),t2,se2)];
    end
end

if isempty(carre3)
    coord_carre3=[];
else
    coord_carre3=[];
    for i=1:size(carre3,1);
        coord_carre3=[coord_carre3;centre2pixapp(carre3(i,:),t3,se3)];
    end
end

% concatene les pixels d'apprentissage
pix_app=[coord_carre1;coord_carre2;coord_carre3];

% taille_carre1=size(coord_carre1)
% taille_carre2=size(coord_carre2)
% taille_carre3=size(coord_carre3)