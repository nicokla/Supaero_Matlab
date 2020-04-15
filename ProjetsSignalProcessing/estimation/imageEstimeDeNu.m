function [ image_estime, p ] = imageEstimeDeNu( nu)
global L C image d;

% recuperation des parametres
center = nu(1:2);
sigma = nu(3:6);

% calcul de la galaxie
lig = 1:L; col = 1:C;
[Col,Lig] = meshgrid(col,lig);
Gal = Sersic(center,sigma,Lig,Col);

aaa=ones(L*C,1);
bbb=reshape(Gal,L*C,1);
H=[aaa bbb];
H_pinv = pinv(H);
param_opt = H_pinv * d;
s= param_opt(1);
I0 = param_opt(2);
p=[s I0 nu];

image_estime = s + I0 * Gal;
end

