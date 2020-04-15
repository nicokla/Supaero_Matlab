%%
% Localisation par réseau d'antennes : methodes parametriques
% Root-Music, Min-Norm et MODE
clear
clc
close all

%%
% Number of Monte Carlo simulations
niter = 50;

%Inter-element spacing (in wavelength)
d = 0.5;

%White noise
sigma2 = 1;	%white noise power

% Number of signals for the tests
P=2;

N_list = [10 20 50];
ecart_deg_list=[0.1 0.2 0.3 0.6 1 2 3 6 10]; %logspace(-1,1,10); % de 0.1 à 10 degrés
snr_signals_list=[-20 -10 0 10 20 30];
K_list=[30 40 80 160 320];

dimensions=cell(1,4);
dimensions{1}=N_list;
dimensions{2}=ecart_deg_list;
dimensions{3}=snr_signals_list;
dimensions{4}=K_list;
%% on load les performances calculées
% grâce au bloc d'instructions suivant
% qui a été executé dans une session matlab precedente

load('results 14-12-08-03-11-31.mat');

%% Test de resolution avec un haut snr et beaucoup de snapshots
% !!! --> si le load precedent a marché,
% il est inutile d'executer ce bloc

% 
% doa_errors_history=zeros(3,length(N_list)...
%     ,length(ecart_deg_list),...
%     length(snr_signals_list),...
%     length(K_list));
% 
% ii=0;
% for N=N_list
%     ii=ii+1;
%     pos = d * (0:N-1)'; %sensors positions
%     i=0;
%     for ecart_deg=ecart_deg_list
%         i=i+1;
%         thetas_degree=[-ecart_deg/2 ; ecart_deg/2];
%         thetas = thetas_degree/180*pi;	%angles of arrival
%         As = exp(1i*2*pi*pos*sin(thetas'));	%signal steering matrix N|P
%         j=0;
%         for snr_signals=snr_signals_list
%             j=j+1;
%             SNR=snr_signals*ones(P,1);
%             Ps = sigma2 * 10.^(SNR/10);         %signal power
%             k=0;
%             for K=K_list
%                 k=k+1;
%                 doa_errors_mean=zeros(1,3);
%                 for iter=1:niter
%                     Y = As*diag(sqrt(Ps/2))*(randn(P,K)+1i*randn(P,K)) + sqrt(sigma2/2)*(randn(N,K)+1i*randn(N,K));
%                     Rsmi = (Y*Y')/K;
%                     [U,L] = eig(Rsmi);
%                     [val,ind] = sort(real(diag(L)),'descend');
%                     U = U(:,ind(1:N));
%                     P_assumed = P;
%                     Es = U(:,1:P_assumed);
%                     En = U(:,P_assumed+1:N);
% 
%                     %Root-MUSIC
%                     [doa_rootMusic,anglesRootMusic,normesRootMusic] = rootMusic( En, d, N, P_assumed );
%                     % Min norm
%                     [doa_minNorm, anglesMinNorm, normesMinNorm] = minNorm( En , d, N, P_assumed );
%                     % Mode
%                     [doa_mode, anglesMode, normesMode] = mode( Es, P_assumed, N, d );
% 
%                     % Comparaison des directions of arrival pour chaque méthode
%                     doa_all = [doa_rootMusic doa_minNorm doa_mode];
%                     erreurs_all = ( thetas_degree * [1 1 1] ) - doa_all;
%                     erreurs_all_quad=erreurs_all.*erreurs_all;
%                     doa_errors=(sum(erreurs_all_quad,1)/P);
% 
%                     doa_errors_mean=doa_errors_mean+doa_errors;
%                 end
%                 doa_errors_mean=sqrt(doa_errors_mean/niter);
%                 for aa=1:3
%                     doa_errors_history(aa,ii,i,j,k)=doa_errors_mean(aa);
%                 end
%             end
%         end
%     end
% end
% 
% time=datestr(now,'yy-mm-dd-HH-MM-SS');
% save(['results ' time],'doa_errors_history');



% 3 9 6 5
% 2 8 4 3   (i,2,9,4,3); --> N=20, deg=10, snr=10, K=80
% N_list = [10 20 50];
% ecart_deg_list=[0.1 0.2 0.3 0.6 1 2 3 6 10]; %logspace(-1,1,10); % de 0.1 à 10 degrés
% snr_signals_list=[-20 -10 0 10 20 30];
% K_list=[21 40 80 160 320];

%%
couleurs=['r','g','b'];

%%
figure;
for i=1:3
    v=doa_errors_history(i,2,:,4,3);%(i,2,9,4,3)
    semilogy(dimensions{2},...
    v(:),... % 
    couleurs(i));hold on;
end
legend('Root-MUSIC', 'Min-Norm', 'MODE');


%% Variation de l'erreur de pointage en fonction du nombre d'antennes
figure;
for i=1:3
    v=doa_errors_history(i,:,end,end,end);
    semilogy(N_list,...
    v(:),... % 
    couleurs(i));hold on;
end
legend('Root-MUSIC', 'Min-Norm', 'MODE');
xlabel('Nombre d''antennes');
ylabel('Erreur sur les directions en degrés')
% resultat : l'erreur de pointage diminue avec le nombre d'antennes


%% Ecart de mesure d'angle lorsque deux sources se rapprochent (en erreur relative)
figure;
for i=1:3
    v=doa_errors_history(i,end,:,end,end);
    % semilogx
    loglog(ecart_deg_list,...
    v(:)./ecart_deg_list',... % 
    couleurs(i));hold on;
end
ylim([0 1]);
legend('Root-MUSIC', 'Min-Norm', 'MODE');
xlabel('Angle entre les sources');
ylabel('Erreur sur les directions (en relatif à la resolution testee)')
title('Sources proches','FontSize', 16);
% resultat : l'erreur relative augmente quand on rapproche deux sources


%% Evaluation des methodes en fonction du snr
figure;
for i=1:3
    v=doa_errors_history(i,end,end,:,end);
    semilogy(snr_signals_list,...
    v(:),... 
    couleurs(i));hold on;
end
legend('Root-MUSIC', 'Min-Norm', 'MODE');
xlabel('SNR');
ylabel('Erreur sur les directions en degres');
% resultat : l'erreur de pointage augmente quand le bruit augmente (ie
% quand le snr diminue)


%% Variation de l'erreur en fonction du nombre de snapshots
figure;
for i=1:3
    v=doa_errors_history(i,end,end,end,:);
    semilogy(K_list,...
    v(:),... 
    couleurs(i));hold on;
end
legend('Root-MUSIC', 'Min-Norm', 'MODE');
xlabel('Nombre de snapshots');
ylabel('Erreur sur les directions en degres');
% resultat : l'erreur diminue avec le nombre de snapshots

%%
% conclusion generale : music est meilleure que min-norm qui est meilleure
% que mode (pour deux sources)
