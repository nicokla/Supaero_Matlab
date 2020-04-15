%%%%%%%%%%%%%
% 1.1) Kmean - iris (question 1)
load fisheriris;
[ centres, classesSupposees ] = Kmeans( meas, 3, 1 );

a1=round(mean(classesSupposees(1:50)));
a2=round(mean(classesSupposees(51:100)));
a3=round(mean(classesSupposees(101:150)));
C = repmat([a1,a2,a3],50,1);
classesReelles = C(:)';
s = ones(1,150)*30;

[mappedX,mapping] =pca(meas,3);
subplot(1,2,1),scatter3(mappedX(:,1),mappedX(:,2),mappedX(:,3),s,classesReelles, 'fill'), title('Classes reelles');
subplot(1,2,2),scatter3(mappedX(:,1),mappedX(:,2),mappedX(:,3),s,classesSupposees, 'fill'), title('Classes supposees');

sum((classesSupposees-classesReelles) ~= 0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.2) Kmean - donnees tirees aleatoirement (question 1)
a1 = mvnrnd([1;1], [1 0; 0 2] ,50);
a2= mvnrnd([10;1], [1 0; 0 2] ,50);
a3=mvnrnd([6;4], [1 0; 0 1] ,50);
a=[a1;a2;a3];

[ centres2, classesSupposees2 ] = Kmeans( a, 3, 1 );
aa1=round(mean(classesSupposees2(1:50)));
aa2=round(mean(classesSupposees2(51:100)));
aa3=round(mean(classesSupposees2(101:150)));
C2 = repmat([aa1,aa2,aa3],50,1);
classesReelles2 = C2(:)';
s = ones(1,150)*30;
subplot(1,2,1),scatter(a(:,1),a(:,2),s,classesReelles2, 'fill'), title('Classes reelles');
subplot(1,2,2),scatter(a(:,1),a(:,2),s,classesSupposees2, 'fill'), title('Classes supposees');


sum((classesSupposees2-classesReelles2) ~= 0)


%%%%%%%%%%%%%%%%%%%%%%%
% 2.1) : pseudo inverse, polynome (question 2)

clear all, close all, clc ;
%% Parametres
n = 5; % Ordre
x = -2:0.1:2; %
txbr = 0.3 ; % Taux Bruit additif gaussien
br = txbr * randn(1,length(x)) ;
%% Polynome initial :
p = randn(1,n+1)
y = polyval(p,x) ;
yb = y + br ;
%% Polynome reconstitue
xx = [] ;
for (i = 0:n)
    nt = x.^i ;
    xx = [nt ; xx] ;
end
p_rest =(inv(xx*xx')*xx)*yb'; % pinv(xx)*yb'
y_rest = polyval(p_rest,x) ;
%% Affichage
figure, plot(x,y,x,yb,'.',x,y_rest) ;
legend('Polynome initial','Polynome bruite','Polynome restitue') ;


%%%%%%%%%%%%%%%%
% 2.2.1) Pseudo-inverse, cercle (question 3)

% Generation du cercle bruit�
cercleComplexe=exp(1i*(1:50)/50*2*pi);
cercleComplexe2=exp(1i*(1:51)/50*2*pi);
cercleBruiteX=3*real(cercleComplexe)-4.5+0.1*randn(1,50);
cercleBruiteY=3*imag(cercleComplexe)-0.5+0.1*randn(1,50);

% technique 1 : possible ssi on a les angles
y_reel=[cercleBruiteX cercleBruiteY]';
%scatter(cercleBruiteX,cercleBruiteY);
coordX=[ones(50,1); zeros(50,1)];
coordY=[zeros(50,1); ones(50,1)];
cercle=[real(cercleComplexe)';imag(cercleComplexe)'];
m=[coordX coordY cercle];
f=inv(m'*m)*m'*y_reel; %pinv(m)*y_reel;
y_approche=m*f;
scatter(cercleBruiteX,cercleBruiteY);
hold on;
plot([y_approche(1:50)+1i*y_approche(51:100);(y_approche(1)+1i*y_approche(51))]);%scatter(d_environ(1:50),d_environ(51:100));

% technique 2 : possible dans tous les cas
M2 = [(cercleBruiteX.^2 + cercleBruiteY.^2) ; cercleBruiteX ; cercleBruiteY ];
abg = ones(1,50)*pinv(M2);
a=abg(1); b=abg(2); g=abg(3);
y_c=-g/(2*a);
x_c=-b/(2*a);
R=sqrt(1/a+(x_c^2+y_c^2));
scatter(cercleBruiteX,cercleBruiteY);
hold on;
plot(x_c+1i*y_c+R*cercleComplexe2,'r');


%%%%%%%%%%%%%%%%
% 2.2.2) comparaison avec Ransac (question 4)

% Ransac ne trouve pas la solution optimale quadratiquement
% De plus, pour faire ransac il faut coder une politique de changement des
% 3 points qui soit efficace, ce qui n'est pas évident. Si on les teste
% tous cela est 3 parmi n, avec n le nb d'echantillons. Si le nb de paramètre
% etait superieur à 3 (disons m>3), la complexite serait en m parmi n, ce qui
% est très mauvais dès que m devient grand (par exemple m==5 pour une
% conique)




%%%%%%%%%%%%%%%
% 2.3) Analyse par composante principales (ACP=PCA en anglais)

clear all, close all, clc;
%% Donnees initiales :
imInit = imread('Eiffel.jpg');
imInit = double(imInit)/255;
R = imInit(:,:,1);
G = imInit(:,:,2);
B = imInit(:,:,3);
A = [R(:) G(:) B(:)];
% save('PointsInitiaux.txt','A','-ascii'); % le fichier resultant fait 50Mo
figure;
plot3(A(:,1), A(:,2), A(:,3),'o');
title('Donnees originales');

%% Covariance
A_cov = cov(A);
[eigvec,eigval] = eig(A_cov);
[x,y] = meshgrid(0:1:256);
plane = eigvec(1,1)/(-eigvec(3,1)).*x+eigvec(2,1)/(-eigvec(3,1))*y ;
figure;
mesh(x,y,plane);
hold on;
plot3(A(:,1), A(:,2), A(:,3),'o');
title('Donnees originales et plan principal');

%%%%%%%%%%%%%%%%%%%%%
% 2.3.1) Question 5 : pourquoi l'acp vaut-elle le coup ?
variances=diag(eigval);
variances(end)/sum(variances) % 0.9794, c-a-d 97% de la variance
(variances(end)+variances(end-1))/sum(variances)

%%%%%%%%%%%%%%%
% 2.3.2) Question 6 : compresser l'image de 3/2 (ou 3) avec la methode de l'acp.

A2=eigvec'*A'; % coord dans la base qu'il faut, ici eigvec'==inv(eigvec), car c'est une matrice orthonormale
A2(1,:)=0; % on met a zero coord selon la plus petite valeur propre
A_approx = eigvec*A2;
A2(2,:)=0;
A_approx2 = eigvec*A2;
im_approx = zeros(size(imInit));
im_approx2=im_approx;
for i=1:3
    im_approx(:,:,i)= reshape(A_approx(i,:),size(imInit,1),size(imInit,2));
    im_approx2(:,:,i)= reshape(A_approx2(i,:),size(imInit,1),size(imInit,2));
end
figure
subplot(1,3,1), imshow(imInit);
subplot(1,3,2), imshow(im_approx)
subplot(1,3,3), imshow(im_approx2)

