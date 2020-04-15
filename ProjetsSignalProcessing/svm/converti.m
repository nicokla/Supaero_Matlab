function [ val_pix_app_champs, val_pix_app_ville ] = converti(TrainingFileName, image_totale,n)
[ville,champs]=Lit_pix_app_fichier(TrainingFileName);
val_pix_app_champs=ind_pix2val_pix( image_totale, n, champs);
val_pix_app_ville=ind_pix2val_pix( image_totale, n, ville);
end

