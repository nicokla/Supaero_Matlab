%% centre2pixapp__________________________________________________________%
%                                                                         %
% Fonction qui donne l'ensemble des pixels d'apprentissage a partir des   %
% coordonnées du centre d'un carré de selection et de la taille du carré  %
%                                                                         %
% parametres d'entrée:                                                    %
%           - coord_centre: coordonnées du centre du carré de selection   %
%           - t: taille du carré de selection (impaire)                   %
%           - se: facteur de sous echantillonage                          %
%                                                                         %
% parametres de sortie:                                                   %
%           - coord_pix_carre: coordonnees des pixels d'apprentissage du  %
%             carre de selection                                          %
%_________________________________________________________________________%

function coord_pix_carre=centre2pixapp(coord_centre,t,se)
coord_pix=zeros(t*t,2);
n=round(t/2)-1;
pass=0;
for i=coord_centre(1,1)-n:coord_centre(1,1)+n
    for j=coord_centre(1,2)-n:coord_centre(1,2)+n
        pass=pass+1;
        coord_pix(pass,1)=i;
        coord_pix(pass,2)=j;
    end
end

if se~=1
    coord_pix_carre=zeros(round(t*t/se),2);
    pass=0;
    for i=1:se:t*t
        pass=pass+1;
        coord_pix_carre(pass,1)=coord_pix(i,1);
        coord_pix_carre(pass,2)=coord_pix(i,2);
    end
else
    coord_pix_carre=coord_pix;
end
%     taille=size(coord_pix_carre)
%     se
%     t