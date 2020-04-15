%% ind_pix2val_pix________________________________________________________%
%                                                                         %
% Fonction qui recupere les valeurs des voxels d'interest d'une image a   %
% partir de la position, et les concatenant dans une matrice              %
%                                                                         %
% Parametres d'entree:                                                    %
%       - cube: image hyperspectrale a traiter                            %
%       - Nb:taille des voxels                                            %
%       - pos_pix: matrice "colonne" contenant la position des pixels     %
%                  d'interet                                              %
%                                                                         %
% Parametres de sortie:                                                   %
%       - val_pix: vecteur colonne contenant les valeur des pixel         % 
%                  d'interet                                              %
%_________________________________________________________________________%

function val_pix=ind_pix2val_pix(cube,Nb,ind_pix)

% taille du vecteur colonne contenant les indices
n=size(ind_pix,1);
% allocation de memoire pour val_pix
val_pix=zeros(n,Nb);

% recopie les valeurs des voxels d'interet dans val_pix
if Nb > 1
    for i=1:n
        val_pix(i,:)=cube(ind_pix(i,1),ind_pix(i,2),:);
    end
else
    for i=1:n
        val_pix(i)=cube(ind_pix(i,1),ind_pix(i,2));
    end    
end