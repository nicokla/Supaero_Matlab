%% Ecrit_pix_app_fichier__________________________________________________%
%                                                                         %
% Fonction qui ecrit les coordonnéees des pixels d'apprentissage dans un  %
% fichier text (avec extension.app) sous la forme suivante                %
%       pixels sains:                                                     %
%       coordx    coordy                                                  %
%       ---       ---                                                     %
%                                                                         %
%       pixels patho:                                                     %
%       coordx    coordy                                                  %
%       ---       ---                                                     %
%                                                                         %
% Parametre d'entree:                                                     %
%   - sain: tableau contenant les ccordonnees des pixels sains            %
%   - patho: tableau contenant les coordonnees des pixels patho           %
%                                                                         %
% Sp 26/01/10                                                             %
%_________________________________________________________________________%

function Ecrit_pix_app_fichier(FileName,sain,patho)

nom_fichier=[FileName(1:end-4) '.app'];
fid=fopen(nom_fichier,'w');

% ecrit les pixels sains
fprintf(fid,'pixels sains:\n');
for i=1:size(sain,1);
    fprintf(fid, '%d\t%d\n',sain(i,1),sain(i,2));
end

fprintf(fid,'\n');
% ecrit les pixels patho
fprintf(fid,'pixels pathos:\n');
for i=1:size(patho,1);
    fprintf(fid, '%d\t%d\n',patho(i,1),patho(i,2));
end
fclose(fid);
