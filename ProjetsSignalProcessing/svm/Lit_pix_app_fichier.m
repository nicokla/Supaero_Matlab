%% Lit_pix_app_fichier__________________________________________________%
%                                                                         %
% Fonction qui lit les coordonnéees des pixels d'apprentissage dans un    %
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

function [sain,patho]=Lit_pix_app_fichier(FileName)

% calcul la taille des vecteurs d'apprentissage
fid=fopen(FileName,'r');
if fid==-1
    error('Veillez realiser un apprentissage et ranger')
else
    k=0;
    stop=0;
    while ~stop
        k=k+1;
        tline = fgetl(fid);

        pos_sains=strfind(tline,'pixels sains:');
        if ~isempty(pos_sains)
            pos_sain=k;
        end

        pos_pathos=strfind(tline,'pixels pathos:');
        if ~isempty(pos_pathos)
            pos_patho=k;
        end

        if feof(fid)
            nombre_ligne=k;
            stop=1;
        end
    end

    fclose(fid);


    % copie les valeurs des pixels d'apprentissage
    fid=fopen(FileName,'r');
    k=0;  
    sain=zeros(pos_patho-2-pos_sain,2);
    patho=zeros(nombre_ligne-pos_patho,2);
    while ~feof(fid) 
        k=k+1;
        tline = fgetl(fid);

        if k==pos_sain
            for i=pos_sain+1:pos_patho-2
                k=k+1;
                tline = fgetl(fid);
                sain(i-(pos_sain+1)+1,:)=str2num(tline(1:end));
            end
        end

        if k==pos_patho
            for i=pos_patho+1:nombre_ligne
                k=k+1;
                tline = fgetl(fid);
                patho(i-(pos_patho+1)+1,:)=str2num(tline(1:end));
            end
        end
    end     
    fclose(fid);
end
