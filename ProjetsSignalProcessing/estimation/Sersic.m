function Im = Sersic(position,theta,Lig,Col)
% Im = Sersic(l_0,c_0,theta,Lig,Col)
%
% Calcul de l'image d'un modèle de Sersic sur une grille (définie par les
% matrices Lig et Col) de paramètres :
%  - l_0 : position en ligne
%  - c_0 : position en colonne
%  - theta = [sigma_l; sigma_c; angle; n] avec
%    sigma_l : écart-type en ligne
%    sigma_c : écart-type en colonnne 
%    angle : angle en radian   
%    n : indice de Sersic

% H. Carfantan, IRAP, novembre 2014

l_0 = position(1);
c_0 = position(2);
n = theta(4);
Im = exp(-  (  (((Col-c_0)*cos(theta(3))-(Lig-l_0)*sin(theta(3)))/theta(2)).^2 ...
             + (((Col-c_0)*sin(theta(3))+(Lig-l_0)*cos(theta(3)))/theta(1)).^2).^(1/(2*n)) );

