function [D3,D6,D7]=getTimeParams(good, T, n)
% Sert pour le mode dynamic2
% On utilise la toolbox de fast marching de Gabriel Peyré
% Pour calculer la distance des pixels inconnus à la frontiere.

% [T,n,dt,D3,D6,D7]=getTimeParams(good, b, M)
% [T,n,dt,D3]
% D3 : distance à la frontiere en nombre de pixels
% D6 : temps a partir duquel le pixel doit etre frozen
% D7 : meme information en nombre de step (a partir de la step n°D7(i,j)
% on gèle le pixel (i,j).

frontiere=frontiereIn(good, ones(3));
list = getList(frontiere);
W=ones(size(good));
[Mx,My]=size(good);
start_points=list';
% nb_iter_max=3;
% [D,S] = perform_front_propagation_2d(...
%     W,start_points,end_points,nb_iter_max,H);
[D,S,Q] = perform_fast_marching(W, start_points, []);
 

D(D>5e8)=0;
% imagesc(D)
D2=D;
D2=D2.*(1-good);
% imagesc(D2)

%% D3 is the distance, with as the unit, the number of pixels.
D3=D2*min(Mx,My);
% imagesc(D3);



% coeffDt=1/3;
% dt=1/(b*M/2)*coeffDt;
% n=200;
% T=n*dt;

D6=D3/max(D3(:))*T;
D7=D3/max(D3(:))*n;

% imagesc(D7);
end

