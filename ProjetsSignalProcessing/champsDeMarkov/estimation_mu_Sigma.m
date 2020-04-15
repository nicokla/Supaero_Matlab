function [mu,Sigma] = estimation_mu_Sigma(X)
% Convention utilisee : chaque colonne doit etre un echantillon (pas chaque ligne)
[dimension, nb_donnees] = size(X);
mu = sum(X,2)/nb_donnees;
X_moyen = mu*ones(1,nb_donnees);
X_centre = X-X_moyen;
Sigma = X_centre*X_centre'/nb_donnees;
