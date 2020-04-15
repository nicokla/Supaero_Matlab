%%%%%%%%%%%%%%
%% Question 1
% Generer la matrice A grace au programme Generateur donne dans l'enonce

n=100; % nb de composants
%p=100; % nb de tests possibles, choisi =n dans ce BE, cf Generateur.m
p=0.04; % proba d'avoir un test en dehors de la diagonale
A=Generateur(n,0.04);
dlmwrite('A_1',A);
n_t=10; % nb de tests choisis parmi les tests possibles
A_1=dlmread('A_1'); % matrice utilisee pour les tests

%%%%%%%%%%%%%%
%% Question 2
% Exprimer l'energie U, la mesure de cette  energie U (x) pour un etat x
% donnï¿½, puis le voisin V(x) de cet ï¿½tat.

% en s'inspirant de la fonction Metropolis.m donnee dans l'enonce :
% 
% L'etat est represente par X (ainsi que X_1 et X_0 mais qui sont une
% information redondante par rapport ï¿½ X)
% X= le vecteur binaire oï¿½ la jï¿½me valeur vaut 1 ssi le test nï¿½j est choisi
% X represente l'ensemble des tests choisis
% X_1 reprï¿½sente l'ensemble des etats choisis mais d'une maniere differente
% que X : au lieu d'etre un vecteur binaire, c'est un vecteur de nombres
% entiers, chaque nombre entier etant un numï¿½ro de test ayant ete choisi.
% X_0 contient au contraire les numeros de tests n'ayant pas ete choisis.
% 
% U = (le nb de composants non testes avec le choix donnï¿½ de
% tests)
% 
% U = 100-sum(min(A*X,1));
% 
% le voisin de X est X dont un des tests a ete remplacï¿½ par un autre tirï¿½
% au hasard parmi ceux non choisis pour l'instant.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Ã¹
%% Questions 3 
% Implementer cet algorithme et demontrant l' ecriture du test if
% N>Nin+T*log(rand).

% L'algorithme de metropolis est deja implemente dans l'enonce du BE

% N>Nin+T*log(rand)
% ssi
% exp((N-Nin)/T)>rand
% hors if(rand < p) nous donne justement l'entree dans le if avec une proba
% p.

% intuitivement on voit bien que plus T est grand plus on a de chance de
% changer d'etat, ie plus la condition 
%    if N>Nin+T*log(rand)
% a de chance d'etre vraie, car rand est inferieur a 1 donc T*log(rand) va
% etre negatif.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Questions 4
% Pour une condition initiale donnee, observer les niveaux d'energie d'une
% trajectoire au cours du temps ï¿½ differentes temperatures (T = 0, T = 0.1, T = 0.5... ).
% A quoi correspond cette dynamique pour T = 0 ? Renouveler l'experiences avec plusieurs
% conditions initiales.

% pour T=0, on a un algorithme qui switch seulement si le nouvel ensemble
% de test est strictement meilleur que l'actuel. C'est un algorithme
% glouton (on amï¿½liore toujours strictement).

nb_etapes=300;
perfo = zeros(nb_etapes,1);
T=0.7;
[X, X_1, X_0, N]=Init_alea(A,n_t);
for i=1:nb_etapes
    perfo(i)=N;
    [X, X_1, X_0, N] = Metropolis(n, n_t, A, T,X, X_1, X_0, N);
end
plot(perfo);
perfo(end)
title(['Température ' num2str(T)]);
saveas(gcf, ['Température ' num2str(T) '.jpg'],'jpg');

%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 5 
% Approcher ainsi la forme du graphe de la vitesse de convergence en fonc-
% tion de la temperature. Etudier en fonction de la temperature la forme des distributions
% stationnaires de l'energie pour l'algorithme de Metropolis

% On utilise la fonction Gibbs.m donne dans l'enonce
N_hist=1:100;
t_iter=200;
n_iter=100;
T=1.5;
gibbs = Gibbs(n,p,n_t,A,T,N_hist,t_iter,n_iter);
plot(gibbs)
title(['Distribution de Gibbs. Température = ' num2str(T)]);
saveas(gcf, ['Distribution de Gibbs. Température = ' num2str(T) '.jpg'],'jpg');

%%%%%%%%%%%%%%%
%% Question 6
% Determiner les distribution de Gibbs pour differentes temperatures 
%T_list = [30, 10, 3, 1, 0.7, 0.3, 0.1, 0.03, 0.01, 0];
T_list = logspace(2,-3,50);
N_hist=1:100;
t_iter=200;
n_iter=100;
proba=zeros(length(T_list),length(N_hist));%Gibbs(n,p,n_t,A,T,N_hist,t_iter,n_iter);
ecart_types=zeros(1,length(T_list));
moyennes=zeros(1,length(T_list));
for i=1:length(T_list)
    T=T_list(i);
    proba(i,:)=Gibbs(n,p,n_t,A,T,N_hist,t_iter,n_iter);
    moyennes(i)=sum(proba(i,:).*(1:100));
    ecart_types(i)=sqrt( sum( proba(i,:).*((1:100)-moyennes(i)).*((1:100)-moyennes(i)) ) );
end
for i = 1:length(T_list)
    y=normpdf(1:100,moyennes(i),ecart_types(i));
    plot(1:100,proba(i,:),'+-',1:100,y,'');
    title(['T=', num2str(T_list(i)),...
        ', mean=',num2str(moyennes(i)), ...
        ', std=',num2str(ecart_types(i))]);
    pause
end
%plot(T_list,moyennes); figure; plot(T_list,ecart_types)
semilogx(T_list,moyennes);% title('Moyennes');
%saveas(gcf,'moyennes.jpg','jpg');
hold on; semilogx(T_list,ecart_types);% title('Ecart-types');
%saveas(gcf,'ecarts-types.jpg','jpg');
plotyy(T_list,moyennes,T_list,ecart_types,'semilogx');
saveas(gcf,'ecarts-types et moyennes.jpg','jpg');
%%%%%%%%%%%%%%
%% Question 7
% En etudiant les loi de Gibbs ï¿½ differentes temperatures, determiner les
% valeurs initiales et finales necessaire au recuit.

% 2 et 0.01 par exemple


%%%%%%%%%%%%%%%
%% Question 8
% Etudier les convergences en loi pour plusieurs lois ï¿½ differentes temperatures.
% ie etudier les variations de t_iter (?).

N_hist=1:100;
n_iter=100;
T_all=[5 1 0.6 0.3 0.2 0.1 0.05 0.01];
t_iter_essayes = [10 30 70 110 160 200];
proba1=zeros(length(t_iter_essayes),length(N_hist));
for T=T_all
    proba2=Gibbs(n,p,n_t,A,T,N_hist,200,n_iter);
    moyenne=sum(proba2.*(1:100));
    ecart_type=sqrt( sum( proba2.*(((1:100)-moyenne).^2) ) );
    proba_reelle=normpdf(1:100,moyenne,ecart_type);

    distances = zeros(size(t_iter_essayes));
    close all;
    hold on;
    for i = 1:length(t_iter_essayes)
        proba1(i,:)=Gibbs(n,p,n_t,A,T,N_hist,t_iter_essayes(i),n_iter);
        plot(proba1(i,:));
        distances(i)=sqrt(sum((proba1(i,:)-proba_reelle).^2));
    end
    plot(proba_reelle,'r');
    title(['T=', num2str(T)]);
    
    figure(2),plot(t_iter_essayes,distances);
    a=axis;
    axis([a(1) a(2) 0 a(4)]);
    pause
end

%%%%%%%%%%%%%%%
%% Question 9
% Rechercher la vitesse de convergence sur plusieurs plateaux (par exemple
% entre T = 1 et T = 0.95^10 = 0.6) et estimer la longueur d'un plateau.

%


%%%%%%%%%%%%%%%
%% Question 10
% Expliciter la maniere dont ces parametres sont determines.



%%%%%%%%%%%%%%%
%% Question 11
% Mettre en oeuvre le recuit simulï¿½ avec un algorithme ï¿½ dï¿½croissance
% gï¿½omï¿½trique (avec alpha = 0.95) de la tempï¿½rature et plateaux pour obtenir la solution du
% problï¿½me

T_init=2;
T_final=0.01;
l_plateau=150;
rapport=0.6;

nb_plateaux=ceil(log(T_init/T_final)/log(1/rapport));
nb_etapes=l_plateau*nb_plateaux;
perfo = zeros(nb_etapes,1);

n_t=10;
T=T_init;
[X, X_1, X_0, N]=Init_alea(A,n_t);
% i=0;
% while T>=T_final
for i=0:nb_plateaux-1
    for j=1:l_plateau
        perfo(i*l_plateau+j)=N;
        [X, X_1, X_0, N] = Metropolis(n, n_t, A, T,X, X_1, X_0, N);
    end
    % i=i+1;
    T=rapport*T;
end
plot(perfo);
perfo(end)
% pour 10 tests on test 66 machines pour la matrice A_1


T_init=2;
T_final=0.01;
l_plateau=300;
rapport=0.9;
nb_plateaux=ceil(log(T_init/T_final)/log(1/rapport));
nb_etapes=l_plateau*nb_plateaux;
perfo = zeros(nb_etapes,1);

n_t=24;
Xopt=zeros(size(X));
perfoActuelle=0;

while perfoActuelle<100
    for aa=1:100
        T=T_init;
        [X, X_1, X_0, N]=Init_alea(A,n_t);
        % i=0;
        % while T>=T_final
        for i=0:nb_plateaux-1
            for j=1:l_plateau
                perfo(i*l_plateau+j)=N;
                [X, X_1, X_0, N] = Metropolis(n, n_t, A, T,X, X_1, X_0, N);
            end
            % i=i+1;
            T=rapport*T;
        end
        plot(perfo);title(num2str(n_t));
        if(perfo(end)>perfoActuelle)
            Xopt=X;
            perfoActuelle=perfo(end)
        end
        perfoActuelle
        pause
    end
    %n_t=n_t+1;
end

% on trouve finalement 24 pour la matrice A_1
% avec 23 on ne peut arriver qu'ï¿½ 99 machines testees.
A_1=dlmread('A_1');
Xopt_1=dlmread('Xopt_1');
sum(Xopt_1)
sum(min(A_1*Xopt_1,1))


%%%%%%%%%%%%%%%
%% Question 12
% Mettre en oeuvre un algorithme de recuit simule afin de detecter et
% compter des cellules.

% Chargement de l'image, conversion en niveau de gris et seuillage
cells_color=imread('cells_2.jpg');
cells=rgb2gray(cells_color);
cells_double=double(cells)/255;
figure, imshow(cells);
level = graythresh(cells);
cells_bw=cells_double<level; % *0.85
cells_bw_double=double(cells_bw);
imshow(cells_bw_double);
%se1 = strel('disk', 3);
%cells_bw_filtrees = imclose(cells_bw,se1);
%imshow(cells_bw_filtrees);
% imwrite(cells_bw_filtrees,'cells_bw4.jpg','jpg'); % enlever manuellement l'imperfection

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Metropolis et recuit simulé

%% preparations à ne faire qu'une fois

coeff_autour = 1.2; % max de ce coeff=sqrt(2). C'est le diametre du contour
coeff_importance = 1/(coeff_autour - 1);
%coeff_importance=coeff_importance*0.6; % on attenue un peu l'importance

masques_interieur=cell(1,rmax-rmin+1);
masques_autour=cell(1,rmax-rmin+1);
for r=rmin:rmax+1
    SE = strel ('disk', r); % 2*r-1
    rond_logical = SE.getnhood();
    rond=double(rond_logical);
    r2=round(coeff_autour*r);
    SE2 = strel ('disk', r2);
    rond_logical2 = SE2.getnhood();
    rond2=double(rond_logical2);
    rond3=zeros(size(rond2));
    rond3(r2,r2)=1;
    rond3= imfilter(rond3,rond,'conv');
    rond2(rond3==1) = 0; 
    masques_autour{r-rmin+1} = rond2;
    masques_interieur{r-rmin+1}=rond3;
end


% on calcule l'echelle pour dessiner les ronds
imagesc(cells_bw_double);
hold on;
h = scatter(10,10);
currentunits = get(gca,'Units');
set(gca, 'Units', 'Points');
axpos = get(gca,'Position');
set(gca, 'Units', currentunits);
facteur = 1/diff(xlim)*axpos(3); % Calculate Marker width in points
clf;close;


%% Preparation

cells_bw=cells_double<level; % *0.85
cells_bw_init=cells_bw;
cells_bw_double = double(cells_bw);
cells_bw_double_init = cells_bw_double;
total=sum(cells_bw_double_init(:));
%imshow(cells_bw)

% parametres du modele de deplacement
rmin=15;
rmax=25;
sigma_deplacement = 8;
sigma_rayon = 4;

% on choisit les parametres du recuit (modele de refroidissement)
T_init=100;
T_final=0.01;
nb_etapes=100;
rapport=(T_final/T_init)^(1/nb_etapes);
perfo = zeros(nb_etapes+1,1);
mat=zeros(size(cells_bw_double));
mat2=mat;
mat3=logical(mat);
%param_cells=[];
param_cells2=[];


%% Lancement

figure(1);clf;
imagesc(cells_bw_double_init);%cells_bw_double);
colormap(gray)
pas_pris_d_affile=0;
while(pas_pris_d_affile < 15)
    best_cell_found=[0 0 0];
    best_perf_found=0;
    [x, y, r]=Init_alea2(size(cells,1), size(cells,2), rmin, rmax,cells_bw, coeff_autour);
    T=T_init;
    k=1;
    perfo(1)=perf(x, y, r, cells_bw_double, masques_interieur, masques_autour, rmin,...
        coeff_autour, coeff_importance);
    while T>=T_final
        [x, y, r, perfo(k+1)] = ...
            Metropolis2(masques_interieur, masques_autour, x, y, r, rmin, rmax, ...
            T, cells_bw_double, perfo(k), sigma_rayon, sigma_deplacement, ...
            coeff_autour, coeff_importance); 

%             if(perfo(k+1)>best_perf_found)
%                 best_perf_found=perfo(k+1);
%                 best_cell_found=[x y r];
%             end
        T=rapport*T;
        k=k+1;
    end
    
    cercle= double(masques{r-rmin+2}==1);
    mat(x,y)=1;
    mat2=imfilter(mat,cercle,'conv');
    mat(x,y)=0;
    selection=mat2.*cells_bw_double;
    if(sum(selection(:))/sum(cercle(:)) > 0.4)
        % ---> ces 2 lignes ont ete deplacees apres le plot
        %cells_bw_double(mat2==1)=0;
        %cells_bw(mat2==1)=0;
        
        %param_cells=[param_cells; best_cell_found];
        param_cells2 = [param_cells2; [x y r]];
        pas_pris_d_affile=0;
    else
        pas_pris_d_affile = pas_pris_d_affile+1;
    end

    if(length(param_cells2)>0)
%         figure(3); clf;
%         plot(perfo);
        
        figure(1);%clf;
        %imagesc(cells_bw_double_init);%cells_bw_double);
        %colormap(gray)
        hold on;
        h2=scatter(param_cells2(end,2),param_cells2(end,1),'LineWidth',2,'MarkerEdgeColor','r');   
        set(h2, 'SizeData', ((2*param_cells2(end,3)+1)*facteur).^2);

%         figure(2);clf;
%         imagesc(cells_bw);%cells_bw_double);
%         colormap(gray);
%         hold on;
%         h=scatter(y,x,'LineWidth',2,'MarkerEdgeColor','r');   
%         set(h, 'SizeData', ((2*r+1)*facteur).^2);     
    end
    
    if(sum(selection(:))/sum(cercle(:)) > 0.4)
        cells_bw_double(mat2==1)=0;
        cells_bw(mat2==1)=0;
    end
    
    %pause;
    
end
nb_cells=size(param_cells2,1); % 183 187
figure;imagesc(cells_bw);colormap(gray);

% Les figures sauvegardees n'auront pas les bonnes tailles de cercles du
% scatter donc nous avons commente les lignes suivantes
% f1=figure(1);
% saveas(f1, ['nb_cells_', num2str(nb_cells), '.jpg'], 'jpg' );
% f2=figure(2);
% saveas(f1, 'end.jpg', 'jpg' );


%imagesc(cells_color);
%hold on;
%scatter(moy(:,1),moy(:,2),round(pi* r^2));




%%%%%%%%%%%%%%%%%%%%%%%%
%% Bonus : detection de cellule avec outils de morpho

cells_color=imread('cells_2.jpg');
cells=rgb2gray(cells_color);
cells_double=double(cells)/255;
figure, imshow(cells);
level = graythresh(cells);
cells_bw=cells_double<level; % *0.85
cells_bw_double=double(cells_bw);
imshow(cells_bw_double);


% SE2 = strel('ball',20, 20);
% rond2 = SE2.getheight();
% aaa=rond2==(-Inf);
% rond2(aaa)=0;

% rayon d'une cellule : environ 20 pixels.
SE = strel ('disk', 20);
rond_logical = SE.getnhood();
rond=double(rond_logical);
%rond=rond/sum(rond(:));

% filtre derivatif autour du rond de rayon 20, grosso-modo mexican hat fait
% maison. Filtre plus caricatural que le mexican hat (passage de 1 à -1 d'un coup), 
% mais plus proche aussi des donnees (la frontière entre la cellule et l'exterieur
% se fait d'un coup elle aussi).
taille = sum(rond(:));
rond2 = zeros(size(rond,1)*3,size(rond,2)*3);
rond2(ceil(size(rond2,1)/2),ceil(size(rond2,1)/2))=1;
rond2 = imfilter(rond2,rond,'conv');
%imshow(rond2)
rond3=rond2;
taille2=taille;
rayon=1;
while(taille2<2*taille)
    se = strel ('disk', rayon);
    rond3 = imdilate(rond2,se);
    taille2 = sum(rond3(:));
    rayon=rayon+1;
end
% la partie negative de la derivee (pourtour du cercle) :
rond2(rond2==0 & rond3==1) = -1; 
imagesc(rond2)

image_conv = imfilter(cells_bw_double,rond2,'conv'); % rond2
figure, imagesc(image_conv);
%level2=graythresh(image_conv);
%maxi=max(image_conv(:));
%image_conv=image_conv/maxi;
figure, imshow(image_conv>400);%level2
sol_bruitee=image_conv>400;
se=strel('disk', 2);
sol = imopen(sol_bruitee,se);
figure, imshow(sol);

%SE = strel('disk',20); % 10
%tophatFiltered = imtophat(image_conv,SE);
%imagesc(tophatFiltered);
%imwrite(tophatFiltered,'cells_bw6.jpg','jpg');
saveas( gcf, 'cells_bw8.jpg', 'jpg' );

%level2=graythresh(tophatFiltered);
%solution_bruitee = tophatFiltered>0.06; % level2 * ?
%figure, imagesc(solution_bruitee);

%SE = strel('disk',1); % 2
%sol=imopen(solution_bruitee,SE);
%figure, imagesc(sol);
%imwrite(sol,'cells_bw5.jpg','jpg');

[L, num] = bwlabel(sol);
num % 195
%imagesc(L);
%[L2, num2] = bwlabel(solution_bruitee);
moy=zeros(num,2);
for i=1:num
    [r, c] = find(L==i);
    rc = [c r]; % par ce que x et y s'inversent par rapport à l'image
    moy(i,:)=round(mean(rc));
end
imagesc(cells_color);
hold on;
scatter(moy(:,1),moy(:,2))
saveas( gcf, 'cells_bw9.jpg', 'jpg' );
% On remarque qu'il n'y a pas de false positive, mais il y a des false
% negative (2 cellules non comptées sur 195, soit environ 1%).
% Le problème de cette technique est qu'il faut choisir les bonnes valeurs
% pour seuiller, et pour les rayons des disques des imclose et/ou des imopen.
% De plus on ne connait pas les rayons des cellules. 




