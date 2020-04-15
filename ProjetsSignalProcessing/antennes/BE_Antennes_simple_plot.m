%%
% Localisation par réseau d'antennes : methodes parametriques
% Root-Music, Min-Norm et MODE

clear
clc
close all

%%
% Main parameters of the comparison test
ecart_deg=5;
snr_signals=10;
K=300;

%Number of elements in the array
N = 20;
%Inter-element spacing (in wavelength)
d = 0.5;
pos = d * (0:N-1)'; %sensors positions

%White noise
sigma2 = 1;	%white noise power

%%
%Signals
thetas_degree=[-30 ; 10 ; 15];
%thetas_degree=[-ecart_deg/2 ; ecart_deg/2];
P = length(thetas_degree);
thetas = thetas_degree/180*pi;	%angles of arrival	
SNR = [10 ; 10 ; 10 ];              %signal to noise ratio
%SNR=snr_signals*ones(P,1);
Ps = sigma2 * 10.^(SNR/10);         %signal power
As = exp(1i*2*pi*pos*sin(thetas'));	%signal steering matrix N|P

%Covariance matrix
% Rth = As*diag(Ps)*As' + sigma2*eye(N);	% covariance matrix
%Generation of snapshots
Y = As*diag(sqrt(Ps/2))*(randn(P,K)+1i*randn(P,K)) + sqrt(sigma2/2)*(randn(N,K)+1i*randn(N,K));
%Sample covariance matrix    
Rsmi = (Y*Y')/K;

%SVD of covariance matrix
% [Uth,Sth,Vth]=svd(Rth);

%Eigenvalue decomposition
% [U,S,V]=svd(R);
[U,L] = eig(Rsmi);
[val,ind] = sort(real(diag(L)),'descend');
U = U(:,ind(1:N)); S=diag(val);

%%
P_assumed = P+3;    %assumed number of signals
%Signal and noise subspace
Es = U(:,1:P_assumed);
En = U(:,P_assumed+1:N);

% figure
% plot((1:N),10*log10(diag(Sth)),'b+',(1:N),10*log10(diag(S)),'ro');
% title('Eigenvalues of the covariance matrix','FontSize',14);
% ylabel('dB','FontSize',12);
% legend('theory','smi');

%%
%%%%%%%%%%
% Methodes par densite d'energie (non testées ici, mises pour information)
nfft = 2048;
tab_doa = asin(1/d*(-nfft/2:nfft/2-1)/nfft)*180/pi;

P_capon = capon( Rsmi, nfft, N );
P_music = spectralMusic( En, nfft, N );
P_cbf = cbf_localisation( N, K, Y, nfft );
P_spectral_minNorm = spectralMinNorm( En, d, N, P_assumed, nfft );
P_spectral_mode = spectralMode( Es, P_assumed, N, d, nfft );
figure
plot(tab_doa,10*log10(P_cbf),'b',...
    tab_doa,10*log10(P_capon),'g',...
    tab_doa,10*log10(P_music),'r',...
    tab_doa,10*log10(P_spectral_minNorm),'black',...
    tab_doa,10*log10(P_spectral_mode),'c','LineWidth',2);
title('Direction of arrival estimation','FontSize',14);
xlabel('Angle of arrival (degrees)','FontSize',12);
ylabel('Spatial spectrum (dB)','FontSize',12);
legend('CBF','CAPON','MUSIC','Min-Norm','MODE');

% plot en polar
%polar(tab_doa*pi/180,10*log10(P_music)+13,'b');
%polar(tab_doa*pi/180,P_music,'b');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Methodes par position de racines d'un polynome

% Root-MUSIC
[doa_rootMusic,anglesRootMusic,normesRootMusic, angles_all, normes_all ] = rootMusic( En, d, N, P_assumed );
%polar(angles_all*pi/180,normes_all,'b+');
% Root-Min norm
[doa_minNorm, anglesMinNorm, normesMinNorm] = minNorm( En , d, N, P_assumed );
% Root-Mode
[doa_mode, anglesMode, normesMode] = mode( Es, P_assumed, N, d );
% Root-Capon
[ doaCapon, anglesCapon, normesCapon ] = rootCapon( Rsmi, d, N, P_assumed );
 
% Comparaison des directions of arrival pour chaque méthode
doa_all = [doa_rootMusic doa_minNorm doa_mode];
erreurs_all = ( thetas_degree * [1 1 1] ) - doa_all;
erreurs_all_quad=erreurs_all.*erreurs_all;
doa_errors=sqrt(sum(erreurs_all_quad,1));
doa_all
doa_errors

% Comparaison des positions des autres racines pour Min-norm et root-Music
%polar(anglesMinNorm*pi/180,normesMinNorm, 'xb' ,'LineWidth',1.5);
figure
scatter(anglesMinNorm,normesMinNorm, 'xb' ,'LineWidth',1.5);
hold on;
scatter(anglesRootMusic, normesRootMusic, 'xr',  'LineWidth',1.5);
scatter(anglesMode, normesMode, 'xg',  'LineWidth',1.5);
scatter(anglesCapon, normesCapon, 'xg',  'LineWidth',1.5);
legend('Min-norm', 'Root-Music', 'MODE','Capon');


%%%%%%%%%%%%%
%% regardons music et root-music sur un meme plot
figure
% plotyy(tab_doa,10*log10(P_music),'r','LineWidth',2,...
% anglesRootMusic, normesRootMusic, 'xr','plot','stem', 'LineWidth',1.5);
plotyy(tab_doa,10*log10(P_music),...
anglesRootMusic, normesRootMusic,'plot','scatter');

%%%%%%%%%%%%%
%% augmentons le nombre de sources pour regarder si mode s'améliore par
% rapport à min-norm et music

thetas_degree=[-50:10:50]';
snr_signals=20;
P = length(thetas_degree);
thetas = thetas_degree/180*pi;	%angles of arrival	
SNR=snr_signals*ones(P,1);
Ps = sigma2 * 10.^(SNR/10);         %signal power
As = exp(1i*2*pi*pos*sin(thetas'));	%signal steering matrix N|P
Y = As*diag(sqrt(Ps/2))*(randn(P,K)+1i*randn(P,K)) + sqrt(sigma2/2)*(randn(N,K)+1i*randn(N,K));
Rsmi = (Y*Y')/K;
[U,L] = eig(Rsmi);
[val,ind] = sort(real(diag(L)),'descend');
U = U(:,ind(1:N)); S=diag(val);
P_assumed = P;
Es = U(:,1:P_assumed);
En = U(:,P_assumed+1:N);



