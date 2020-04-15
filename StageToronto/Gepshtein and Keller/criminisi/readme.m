% we could use rgb2gray(image) mais on se place dans le cas quelconque
% ie, pas forcement un descripteurs de taille 3, mais de taille Mz inconnue
% we can either do (en + du choix de la taille du patch) :
% 1) criminisi en calculant le gradient avec sum(image,3)
% 2) criminisi sur chaque composante indépendamment
% 3) criminisi avec la somme des normes des gradients
% 4,5,6) Coder une amelioration de criminisi
%      (Martinez-Noriega, Roumy, and Blanchard (2012)
%      avec un des 3 choix precedents
% 7) Pareil mais avec des patchs ronds au lieu de carrés.
% 8) Pareil, mais calculer le gradient avec un smoothing (cf Wexler)
% --> Par manque de temps on se limite à 1, 2 et 3 (on hesite entre
%     1 et 3 mais 3 ralonge trop les calculs donc on prend 1).
%     Cependant finalement, ni 1 ni 3 ne font vraiment sens,
%     donc on commence avec 2). Remarque : 2 revint à iterer 1 pour chaque
%     composante. Ici on a codé 1, on va l'appeler pour chaque composante.
%     Risque d'artefacts, on verra.


% Structure des dossiers :
% - essaiCriminisi3 : methodes 1, 2 et 3
% - essaiCriminisi_new : methodes 4, 5, et 6 (to do)
% - diversUsefulForCriminisi : petits programmes utilisés par les autres.
% - old : anciens essais. On la garde parce qu'on avait utilisé un moyen 
%           différent de le coder qui est interessant
%           (mais il y a d'autres bugs donc ça ne marche pas).
