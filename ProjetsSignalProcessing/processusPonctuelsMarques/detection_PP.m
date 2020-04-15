%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TP7 d'apprentissage artificiel : detection de flamants roses %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Le TP7 se deroule en deux etapes :
% 1) Detection de flamants roses sans a priori.
% 2) Detection de flamants roses avec a priori.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Etape 1 : detection de flamants roses sans a priori %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

global theta;
global rose;

nb_points_cercle = 30;
increment_angulaire = 2*pi/nb_points_cercle;
theta = 0:increment_angulaire:2*pi;
rose = [253 108 158]/255;

% beta=1.5;
% S=150;
% gamma=30;
% T_0=0.01;
% lambda_0=100;
% alpha=.995;
% facteur=2;
% R = 12;

beta=1.5;
S=140;
gamma=20;
T_0=0.3;
lambda_0=500;
alpha=.992;
k=0.85;
facteur=4*k^2;
R = 10;


% Lecture et affichage de l'image :
I = imread('colonie.png');
I = double(I);
I = I(1:500,1:500);
[nb_lignes,nb_colonnes] = size(I);
figure('Name','Image d''origine','Position',[0,0,550,500]);
affiche_all(I, [], [], R);
disp('Tapez retour-chariot pour lancer la detection');
pause;

% Parametres divers :
%N = 50;									% Nombre de disques d'une configuration
R_au_carre = R*R;
q_max = 10000;
nb_points_sur_la_courbe = 500;
intervalle_entre_points_sur_la_courbe = floor(q_max/nb_points_sur_la_courbe);
energie_max = 12000;
temps_affichage = 0.00001;

x = [];
y = [];
x_old = x;
y_old = y;
energies_1 = [];
energies_2 = [];
energie_1=0;
energie_2=0;
energie_totale=0;
energies_a_afficher = [];
abscisses_a_afficher = [];
%affiche_all( I,x,y );
%pause(temps_affichage);

T=T_0;
lambda=lambda_0;
arret=0;
nombreEnPlus=0;
q=1;
while (~arret)
    % Sauvegarde de l'ancienne configuration
    x_old = x;
    y_old = y;
    
    % Naissances
    nombreEnPlus = poissrnd(lambda);
    x = [rand(1,nombreEnPlus)*nb_colonnes...
         x ];
    y = [rand(1,nombreEnPlus)*nb_lignes...
         y ];
    
    % Calcul des attaches aux donnees
    for i=nombreEnPlus:-1:1
        energies_1 = [sigmoid1(energie_simple(...
            R, I, x(i), y(i)), gamma, S) energies_1];
    end

    % Calcul de la penalisation pour les nouveaux points
    n_new = length(x);
    energies_2 = [zeros(nombreEnPlus, n_new) ; ...
                  zeros(n_new-nombreEnPlus,nombreEnPlus) energies_2];
    for i = 1:nombreEnPlus
        for j=i+1:n_new
            energies_2(i,j) = ( (x(i)-x(j))^2 + (y(i)-y(j))^2 ) < facteur*R_au_carre ;
            energies_2(j,i) = energies_2(i,j);
        end
    end
    
    [energies_1, ordre] = sort(energies_1,'descend');
    x=x(ordre);
    y=y(ordre);
    energies_2 = energies_2(ordre,ordre);

    % Morts
    i=1;
    while i <= length(energies_1)
        p = proba( lambda, energies_1, energies_2, T, i );
        if(rand<p)
            intervalle = [(1:i-1), (i+1:length(x))];
            x=x(intervalle);
            y=y(intervalle);
            energies_1 = energies_1(intervalle);
            energies_2 = energies_2(intervalle,intervalle);
        else
            i=i+1;
        end
    end
    
    % Affichage
    affiche_all( I,x,y,R );
    pause(temps_affichage);

	% Ecritures pour tracer la courbe d'energie :
    energie_1 = sum(energies_1);
    energie_2 = sum(energies_2(:))/2;
    energie_totale = energie_1+beta*energie_2;
	
    abscisses_a_afficher = [abscisses_a_afficher q];
	energies_a_afficher = [energies_a_afficher energie_totale];
    
    % Condition d'arret
    arret = isequal(x_old,x);

    % Update de T et lambda
    if(~arret)
        T = T*alpha;
        lambda = lambda*alpha;
        q=q+1;
    end
end

% Trace de l'evolution de l'energie :
figure('Name','Evolution de l''energie');
plot(abscisses_a_afficher,energies_a_afficher,'r.');
hx = xlabel('$q$','FontSize',20);
set(hx,'Interpreter','Latex');
hy = ylabel('Energie','FontSize',20);

% Nombre de flamants roses
length(x)

