
%% Techniques variationnelles
clear all;
load gatlin2;
%load clown;
% load gatlin;
% load mandrill;
Xn=(double(X)-min(X(:)))/(max(X(:))-min(X(:)));
Xn_b=Xn+0.1*randn(size(Xn,1),size(Xn,2));
subplot(1,2,1), imagesc(Xn), colormap gray, axis off;
subplot(1,2,2), imagesc(Xn_b), colormap gray, axis off;
% set(gca, 'DataAspectRatio', [4 4 1])

%% TP1 : Detection de contours par Hildrett-Marr
% Visualisation du laplacien, de la valeur absolue du gradient, et de la
% courbure
l=laplacien(Xn);
imagesc(l), axis off %, colormap gray, ;
%figure, imagesc(l>0.15 | l<(0-0.15))%, colormap gray;

[aa,bb]=gradient(Xn);
cc=sqrt(aa.^2+bb.^2);
imagesc(cc), colormap gray;
imhist(cc);
imagesc(cc>0.08), colormap gray;

hh=curvature(Xn);
imagesc(hh), colormap gray;

% Utilisation de la formule de la page 20 du document de J.F.Aujol (par.
% 3.2.1)
hh2=curvature_3(Xn);
imagesc(hh2), colormap gray;

% Hildrett-Marr 
contours=zeros(size(Xn,1)-2,size(Xn,2)-2,4);
steps=[4 10 30 50]
delta=[0.03 0.02 0.01 0.005]
figure
for i=1:4
    contours(:,:,i)=hildrett(Xn, steps(i), delta(i));
%     figure(1);
     subplot(2,2,i), imagesc(contours(:,:,i)), colormap gray, axis off;
     %pause;
end

% Hildrett-Marr pour le clown
% contours = hildrett( Xn, 6, 0.03);%, 0.01, 0.05 );


% Comparison with edge function
%delta=[0.03 0.02 0.01 0.005];
sigmas=sqrt(2*steps*0.1);
for i=1:4
    BW1 = edge(Xn,'log',[], sigmas(i)); % log
    subplot(2,2,i), imagesc(BW1), colormap gray, axis off;
    %imshow(BW1);
    %pause;
end
% sobel prewitt log roberts zerocross canny



%% TP2 : Equation de la chaleur, gaussienne et Perona-Malik
gain=zeros(1,16);
for i=1:16
    u=Heat_Equation( Xn_b, i, 0.1 );
    gain(i)=snr(Xn,u)-snr(Xn,Xn_b); %7.248
end
plot(1:16, gain);
[C,I]=max(gain);
u=Heat_Equation( Xn_b, I, 0.1 );
colormap(gray); imagesc(u);axis off


gain=zeros(1,16);
sigmas = sqrt(2*(0.1:0.1:1.6));
for i=1:length(sigmas)
    usigma=Convolution_Gaussian( Xn_b,sigmas(i));
    gain(i)=snr(Xn,usigma)-snr(Xn,Xn_b);
end
plot(sigmas, gain);
[C,I]=max(gain);
u=Heat_Equation( Xn_b, I, 0.1 );
imagesc(usigma), colormap gray; axis off


[u2,snrList] = Perona_Malik( Xn, Xn_b, 200, 0.05, 0.1, 'notRacine'); % alpha doit etre pris petit
plot(1:200, snrList);
[C,I]=max(snrList);
[u2,~] = Perona_Malik( Xn, Xn_b, I, 0.05, 0.1, 'notRacine');
figure, imagesc(u2), colormap gray, axis off;
snr(Xn,u2)-snr(Xn,Xn_b) %4.34

%u3 = Perona_Malik( Xn_b, 60, 0.05, 0.1, 'pasRacine'); % alpha doit etre pris petit
u3 = Perona_Malik( Xn_b, 20, 0.1, 0.1, 'pasRacine'); % alpha doit etre pris petit
%u3 = Perona_Malik( Xn_b, 10, 0.2, 0.1, 'pasRacine'); % alpha doit etre pris petit
figure, imagesc(u3), colormap gray;
snr(Xn,u3)-snr(Xn,Xn_b) %4.09


%% La suite est basée sur les fichiers matlab disponibles à :
% http://www.numerical-tours.com/matlab/
% https://github.com/gpeyre/numerical-tours/tree/master/matlab/m_files

% To download the whole numerical tour without using git, download the zip
% archive at :
% http://www.numerical-tours.com/installation_matlab/
% Or go to :
% https://github.com/gpeyre/numerical-tours
% and click on the right on "Download zip".

% Interesting documents can also be found at http://gpeyre.github.io/teaching/

% Les fichiers des numerical tours cités ici ont été placés dans
% ../NumericalTours_by_GabrielPeyre


%% TP3 : Mouvement par courbure moyenne et sa version affine
% --> Basé sur pde_2_diffusion_nonlinear.m
% http://nbviewer.ipython.org/github/gpeyre/numerical-tours/blob/master/matlab/pde_2_diffusion_nonlinear.ipynb


%% Examples
% Mean Curvature Motion
[X1,snrList]=meanCurvatureMotion(Xn, Xn_b, 100, 0.1);
plot(0.1:0.1:10,snrList);
[C,I]=max(snrList);
[X1,~]=meanCurvatureMotion(Xn, Xn_b, I, 0.1);
imagesc(X1), colormap gray, axis off;
snr(Xn,X1)-snr(Xn,Xn_b) %4.09


% Affine Morphological Scale-Space
[X2,snrList]=affineCurvatureMotion(Xn, Xn_b, 100, 0.1);
plot(0.1:0.1:10,snrList);
[C,I]=max(snrList);
[X2,~]=affineCurvatureMotion(Xn, Xn_b, I, 0.1);
imagesc(X2), colormap gray, axis off;
snr(Xn,X2)-snr(Xn,Xn_b) %4.09


%% Choose the time length to have the best SNR improvement
tau=0.2;
niter=200;
snr_list=zeros(1,niter);
amplitude = @(u)sqrt(sum(u.^2,3)+1e-12);
f = Xn_b; k = 0;
iterations=1:niter;
for i=iterations
    f = f + tau * amplitude(gradient(f)) .* curvature_3(f);
    snr_list(i)=snr(Xn,f);
end
snr_list=snr_list - snr(Xn,Xn_b);
plot(tau*iterations,snr_list);


snr_list2=zeros(1,niter);
f = Xn_b; k = 0;
for i=iterations
    f = f + tau * amplitude(gradient(f)) .* curvature_3(f);
    snr_list2(i)=snr(Xn,f);
end
snr_list2=snr_list2 - snr(Xn,Xn_b);
plot(tau*iterations,snr_list2);


%% Generalized Mean Curvature Motion

% To do



%% Coherence enhancing
% Il existe sur
% http://www.mathworks.com/matlabcentral/fileexchange/25449-image-edge-enhancing-coherence-filter-toolbox/content/CoherenceFilter.m
% mais nous pouvons le coder.
% --> Basé sur fastmarching_3_anisotropy.m pour la récupération des
% directions, la suite est l'algorithme de weickert1999coherence
% http://nbviewer.ipython.org/github/gpeyre/numerical-tours/blob/master/matlab/fastmarching_3_anisotropy.ipynb

% To do


%% TP4 : Minimisation de la variation totale et de l'attache aux données
% Denoising --> Voir denoisingsimp_4_denoiseregul.m
% http://nbviewer.ipython.org/github/gpeyre/numerical-tours/blob/master/matlab/denoisingsimp_4_denoiseregul.ipynb
% toolbox_signal/perform_tv_denoising.m
% plus simple mais bien : perform_median_filtering.m

% Deconvolution --> Voir inverse_2_deconvolution_variational.m
% http://nbviewer.ipython.org/github/gpeyre/numerical-tours/blob/master/matlab/inverse_2_deconvolution_variational.ipynb

% Partie seuillage en ondelettes (autre sujet mais quand même dans le TP4 )
% --> Voir denoisingwav_2_wavelet_2d.m
% http://nbviewer.ipython.org/github/gpeyre/numerical-tours/blob/master/matlab/denoisingwav_2_wavelet_2d.ipynb

% To do


%% TP5 : Active contours (snakes), level sets and fast marching
% --> Voir segmentation_3_snakes_levelset.m
% http://nbviewer.ipython.org/github/gpeyre/numerical-tours/blob/master/matlab/segmentation_3_snakes_levelset.ipynb

% Technique semblable : fastmarching
% http://nbviewer.ipython.org/github/gpeyre/numerical-tours/blob/master/matlab/fastmarching_8_segmentation.ipynb

% To do

%% TP6 : Mumford-Shah
% --> Voir le code matlab pour Mumford-Shah disponible sur le site http://cns.bu.edu/~lgrady/software.html
% --> Mis dans ../MumfordShah_by_LeoGrady

% To do

