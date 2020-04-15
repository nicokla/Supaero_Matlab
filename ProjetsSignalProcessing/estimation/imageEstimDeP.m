function image_estim = imageEstimDeP( p )
global L C image d;

s_estim=p(1);
I0_estim = p(2);
center_estim = p(3:4);
sigma_estim = p(5:8);

% calcul de la galaxie
lig = 1:L; col = 1:C;
[Col,Lig] = meshgrid(col,lig);
Gal_estim = Sersic(center_estim,sigma_estim,Lig,Col);

image_estim=I0_estim*Gal_estim + s_estim;

end

