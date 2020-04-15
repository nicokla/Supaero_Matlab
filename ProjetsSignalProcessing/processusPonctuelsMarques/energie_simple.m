function result = energie_simple( R, I, abscisse_centre_disque, ordonnee_centre_disque  )
[nb_lignes,nb_colonnes] = size(I);
R_au_carre=R^2;
cpt_pixels = 0;
somme_nvg = 0;
for j = max(1,floor(abscisse_centre_disque-R)):min(nb_colonnes,ceil(abscisse_centre_disque+R))
    for i = max(1,floor(ordonnee_centre_disque-R)):min(nb_lignes,ceil(ordonnee_centre_disque+R))
        abscisse_relative = j-abscisse_centre_disque;
        ordonnee_relative = i-ordonnee_centre_disque;
        if (abscisse_relative^2 + ordonnee_relative^2) <= R_au_carre
            cpt_pixels = cpt_pixels+1;
            somme_nvg = somme_nvg+I(i,j);
        end
    end
end
result = somme_nvg/cpt_pixels;
end

