function perfo = perf(x, y, r, image, masques_interieur, ...
    masques_autour, rmin, coeff_autour, coeff_importance)

r2=round(coeff_autour*r);
interieur =  masques_interieur{r-rmin+1} .* image(x-r2+1:x+r2-1 , y-r2+1:y+r2-1);
autour = masques_autour{r-rmin+1} .* image(x-r2+1:x+r2-1 , y-r2+1:y+r2-1);

nb_un_int=sum(interieur(:));
taille_int=sum(masques_interieur{r-rmin+1}(:));
nb_zero_int=taille_int-nb_un_int;

nb_un_autour=sum(autour(:));
taille_autour=sum(masques_autour{r-rmin+1}(:));
nb_zero_autour=taille_autour-nb_un_autour;

% avantage les gros rayons mais interdit fortement les recoupements
%perfo1 = nb_un_int - nb_un_autour*coeff_importance;
%perfo1 = nb_un_int - nb_un_autour*coeff_importance;

% essaye de coller au rayon, avantage un peu les petits rayons
perfo2 = nb_un_int/taille_int * nb_zero_autour/taille_autour;

% pb = si les deux termes sont negatifs le produit est positif
%perfo3 = (nb_un_int-nb_zero_int) + coeff_importance*(nb_zero_autour-nb_un_autour)
perfo3 = (nb_un_int-nb_zero_int) + (nb_zero_autour-nb_un_autour);

perfo = perfo2*perfo3;

end

