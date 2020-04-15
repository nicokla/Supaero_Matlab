%                           BE ESTIMATION
%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all; 
clc



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Allures du profil de luminosit� pour diff�rents parametres de forme
x=-10:0.1:10;
figure; hold all;
n_all=[0.5 1 2 4];
%col=hsv(length(n_all));
i=1;
for n=n_all
    plot(x,exp(-((x.^2).^(1/(2*n)))));%,'color',col(i,:));
    i=i+1;
end
legend(num2str(n_all'));




%% Construction de la galaxie

% initialisation de l'image
% Parametres de la galaxie
global L C image d image_sans_bruit p_reel nu_reel;
L=40;
C=40;
l0=20.145646514;% position du centre
c0=19.54;
n=sqrt(5/2);
sigma_l=8;
sigma_c=4;
alpha=-pi/4;
I0=2;
s=2;
p_reel = [ s I0 l0 c0 sigma_l sigma_c alpha n];
nu_reel=p_reel(3:8);

sigma_b = 0.05; % ecart type du bruit
bruit = sigma_b * randn(L,C);
image_sans_bruit=imageEstimDeP( p_reel);
image=image_sans_bruit+bruit;
d = image(:);
imagesc(image);

delta0 = crit_J(p_reel);


%% Initialisations des parametres

% Initialisation de nos parametres contenus dans p
I0_i = max(image(:));
s_i = min(image(:));
l0_i=L/2;
c0_i=C/2;
sigma_l_i=L/4;
sigma_c_i=C/4;
alpha_i=pi/2;
n_i=(1/2 + 5 )/2;% entre 1/2 et 5
p_init=[ s_i I0_i l0_i c0_i sigma_l_i sigma_c_i alpha_i n_i];
nu_i=[l0_i c0_i sigma_l_i sigma_c_i alpha_i n_i];


%% Estimation de l'amplitude et du fond par moindres carres

[ image_estime, p_opt ] = imageEstimeDeNu( nu_reel);
afficheTout(p_opt,image_estime);

% variance et biais
s_estime=p_opt(1);
I0_estime=p_opt(2);
norm([s ; I0]-[s_estime; I0_estime]);

%% Estimation par maximum de vraisemblance

p = p_init;
options = optimset('fminsearch');
options.MaxFunEvals=3000*8;
options.MaxIter=3000*8;
p_opt = fminsearch(@(p) crit_J_avecRealisme(p,1), p_init,options);
image_estim=imageEstimDeP(p_opt);
afficheTout(p_opt,image_estim);



%% Optimisation par rapport a nu seulement

nu = nu_i;
options = optimset('fminsearch');
options.MaxFunEvals=3000*8;
options.MaxIter=3000*8;
nu_opt = fminsearch(@(nu) crit_K_avecRealisme(nu,1), nu_i,options);
[image_estim2, p] = imageEstimeDeNu(nu_opt);
afficheTout(p, image_estim2);

%% Estimation Bayesienne : recuit simul� avec la politique de d�cision de Metropolis

T_init=0.01;
T_final=1e-8;
nbEtapes=1000; % periode de chauffe necessaire ? ou on peut lancer le recuit direct ?
gamma=(T_final/T_init)^(1/nbEtapes);
ecartTypes=p_init/20;
ecartTypes(end)=0.5;

p_reel
p = p_init
%p(end)=1.8;
rsi0=rsi(p_reel)
rsi1=rsi(p_init)

p_essai=p+randn(1,size(ecartTypes,2)).*ecartTypes;
erreur=0;
erreur_essai=0;
T=T_init;
erreurs=zeros(nbEtapes,1);
i=1;
while(T>T_final)
    deplacement = randn(1,size(ecartTypes,2)).*ecartTypes;
    p_essai=p+deplacement;
    erreur=crit_J_avecRealisme( p,1);
    erreur_essai=crit_J_avecRealisme( p_essai,1);
    if (erreur_essai<erreur)
        p=p_essai;
    else
        if (rand < exp(-(erreur_essai-erreur)/T))
            p=p_essai;
        end
    end
    erreurs(i)=erreur;
    i=i+1;
    T=T*gamma;
end

% on affiche le resultat et les vrais parametres
image_estim3=imageEstimDeP(p);
afficheTout(p, image_estim3);

figure, plot(erreurs)



%% Estimation Bayesienne : recuit simul� avec la politique de d�cision de Metropolis

T_init=0.01;
T_final=1e-8;
nbEtapes=1000; 
gamma=(T_final/T_init)^(1/nbEtapes);
ecartTypes=p_init/20;
ecartTypes(end)=0.5;

p_reel
p = p_init
%p(end)=1.8;
rsi0=rsi(p_reel)
rsi1=rsi(p_init)

p_essai=p+randn(1,size(ecartTypes,2)).*ecartTypes;
erreur=0;
erreur_essai=0;
T=T_init;
erreurs=zeros(nbEtapes,1);
i=1;
while(T>T_final)
    deplacement = randn(1,size(ecartTypes,2)).*ecartTypes;
    p_essai=p+deplacement;
    erreur=crit_J_avecRealisme( p,1);
    erreur_essai=crit_J_avecRealisme( p_essai,1);
    if (erreur_essai<erreur)
        p=p_essai;
    else
        if (rand < exp(-(erreur_essai-erreur)/T))
            p=p_essai;
        end
    end
    erreurs(i)=erreur;
    i=i+1;
    T=T*gamma;
end

% on affiche le resultat et les vrais parametres
image_estim3=imageEstimDeP(p);
afficheTout(p, image_estim3);

figure, plot(erreurs)
