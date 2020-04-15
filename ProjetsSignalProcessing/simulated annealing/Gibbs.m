function proba = Gibbs(n,p,n_t,A,T,N_hist,t_iter,n_iter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function proba=Gibbs(n,p,n_t,A,T,N_hist,t_iter,n_iter)
% Objet de la fonction :
% ++++++++++++++++++++++
% Cette fonction retourne un histogramme de frequences de visites
% pour n_iter iterations de la dynamique de Metropolis sur n_iter
% pas de temps apres avoir  ecarte autant de transitoires.
% Les centres de classe sont donnes par n_hist.
% Output :
% ++++++++
% proba vecteur des frequences de l'histogramme des niveaux de la
% fonction cout
%
% Input :
% ++++++
% n entier (100 a 200) taille du probleme
% p probabilite pour un composant d'etre couvert par un test
% n_t nombre de tests admissibles
% A matrice d'affectation genere par Generateur
% T reel positif, temperature
% N_hist vecteur ligne des centres de classes de l'histogramme
% t_iter longueur de simulation d'une chaine de Markov
% n_iter nombre de chaines de Markov lancees pendant l'execution
%
% Fonctions appelees :
% ++++++++++++++++++++
% Init_alea
% Metropolis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NN=zeros(1,t_iter); % trajectoire des performances
n_classes=length(N_hist); % nombre de classes de l'histogramme
proba=zeros(1,n_classes); % fréquence de visite des classes de l'histogramme
moy=1/(n_iter*t_iter); % normalisation des fréquences
for ii=1:n_iter
    %transitoire
    [Xin, Xin_1, Xin_0, NN(1)]=Init_alea(A,n_t); % initialisation de l'etat
    for t=2:t_iter
        [Xout, Xout_1, Xout_0,NN(t)] = ...
        Metropolis(n, n_t, A, T,Xin, Xin_1, Xin_0, NN(t-1));
        Xin=Xout;
        Xin_1=Xout_1;
        Xin_0=Xout_0;
    end
    NN(1)=NN(t_iter);
    % debut de la trajectoire enregistree
    for t=2:t_iter
        [Xout, Xout_1, Xout_0,NN(t)] = ...
        Metropolis(n, n_t, A, T,Xin, Xin_1, Xin_0, NN(t-1));
        Xin=Xout;
        Xin_1=Xout_1;
        Xin_0=Xout_0;
    end
    n_freq=hist(NN,N_hist);
    proba=proba+moy*n_freq;
end
%plot(N_hist,proba,'+-')
%title(['Histogramme de Gibbs a temperature ',num2str(T),' : n=',...
%int2str(n),',nt=',int2str(n_t),', p=',num2str(p)]);

end

