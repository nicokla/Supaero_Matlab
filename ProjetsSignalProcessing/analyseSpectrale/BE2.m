%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Analyse spectrale et parcimonie                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all, clc

load data % A_th, f_th, phi_th, t, y
N = length(t);

% I) Presentation du BE
% II) Analyse spectrale par TF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% II.1) Cas de l'echantillonage régulier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% II.1.1) Shannon --> F_max = F_e/2 = 1/(2*T_e)

%% II.1.2) Sinusoide pure multiple de la frequence min
t = linspace(t(1), t(end), N);
T_e= (t(end) - t(1)) / (N-1);
F_e = 1/T_e;

[F_e, t, freq, freqPositif, ~] = paramFourier( T_e, N );
k_0 = 20;% k_0 < N/2=257
%f_0 = k_0*F_e/N; % II.1.2) Sinusoide pure multiple de la frequence min
f_0 = (k_0+1/2)*F_e/N; %II.1.3) Sinusoide pure non multiple de la frequence min
A=2;
phi = -pi/3;
s = A*cos(2*pi*f_0*t + phi);
[Sabs, Sangle, SabsInteresting, SangleInteresting] = fftPerso( s,T_e );
plotFftPerso( t,s,freqPositif,SabsInteresting,SangleInteresting );
%plotFftPerso( t,s,freq,Sabs,Sangle);
[indices, freqSelect, intensitesSelect, anglesSelect] =...
    plotFftPerso_2( t,s,freqPositif,SabsInteresting,SangleInteresting, 0.9 );
% erreur relative sur l'intensite --> 2/1.28=1.56 et 
% la phase est impossible a retrouver


%% II.1.4) Zero padding
N=514;
[F_e, t, freq, freqPositif, ~] = paramFourier( T_e, N );
k_0 = 20;% k_0 < N/2=257
f_0 = (k_0+1/2)*F_e/N; %II.1.3) Sinusoide pure non multiple de la frequence min
A=2;
phi = -pi/3;
s = A*cos(2*pi*f_0*t + phi);
N_new=10000;
s = [s zeros(1,N_new-N)];
[F_e, t, freq, freqPositif, ~] = paramFourier( T_e, N_new );
[Sabs, Sangle, SabsInteresting, SangleInteresting] = fftPerso( s,T_e,514 );

plotFftPerso( t,s,freqPositif,SabsInteresting,SangleInteresting );
[x, i] = max(SabsInteresting);
SangleInteresting(i) % environ phi --> on recupere bien la phase
% plus precisement -1.0740, et la phase reelle vaut -1.0472, soit environ
% 3% d'erreur relative.
SabsInteresting(i) % 1.9995, soit environ 2 --> on recupere bien l'intensite

%plotFftPerso( t,s,freq,Sabs,Sangle);
[indices, freqSelect, intensitesSelect, anglesSelect] =...
    plotFftPerso_2( t,s,freqPositif,SabsInteresting*514/10000,SangleInteresting, 0.9 );



%% II.1.5) Deux sinusoides

N=514;
[F_e, t, freq, freqPositif, ~] = paramFourier( T_e, N );

k_0 = 20;% k_0 < N/2=257
f_0 = (k_0+1/2)*F_e/N; %II.1.3) Sinusoide pure non multiple de la frequence min
A=2;
phi = -pi/3;

%B=A;
B=A*0.1;
f_1=f_0+2*F_e/N;
%f_1=f_0+2*F_e/N;
f_1=f_0+10*F_e/N;

% Cas où les sinusoides ont la mm intensité :
% delta_f >= 2*F_e/N pour les differencier parfaitement, sinon les lobes principaux
% s'intersectent.

% Cas où une des sinusoides est beaucoup moins intense :
% Il faut que delta_f soit très grand, car les lobes secondaires de la
% sinusoide principale sont suffisant pour absorber le lobe principal de la
% petite sinusoide.

s = A*cos(2*pi*f_0*t + phi)+ B*cos(2*pi*f_1*t);
N_new=10000;
s = [s zeros(1,N_new-N)];
[F_e, t, freq, freqPositif, ~] = paramFourier( T_e, N_new );

[Sabs, Sangle, SabsInteresting, SangleInteresting] = fftPerso( s,T_e,N );
plotFftPerso( t,s,freqPositif,SabsInteresting,SangleInteresting );

[Sabs, Sangle, SabsInteresting, SangleInteresting] = fftPerso( s,T_e );
[indices, freqSelect, intensitesSelect, anglesSelect] =...
    plotFftPerso_2( t,s,freqPositif,SabsInteresting,SangleInteresting, 0.9 );


%% II.1.6)
% 3 vecteurs lignes de parametres : phi_th, f_th, A_th
[F_e, t, freq, freqPositif, ~] = paramFourier( T_e, N );
s=zeros(1,N);
for i = 1:5
    s = s + A_th(i)*cos(2*pi*f_th(i)*t + phi_th(i));
end
[Sabs, Sangle, SabsInteresting, SangleInteresting] = fftPerso( s,T_e );
plotFftPerso( t,s,freqPositif,SabsInteresting,SangleInteresting );
subplot(3,1,2); xlim([28 38]);

% Zero padding
s = [s zeros(1,N_new-N)];
[F_e, t, freq, freqPositif, ~] = paramFourier( T_e, N_new );
[Sabs, Sangle, SabsInteresting, SangleInteresting] = fftPerso( s,T_e,N );
plotFftPerso( t,s,freqPositif,SabsInteresting,SangleInteresting );
subplot(3,1,2); xlim([28 38]);

[Sabs, Sangle, SabsInteresting, SangleInteresting] = fftPerso( s,T_e );
[indices, freqSelect, intensitesSelect, anglesSelect] =...
    plotFftPerso_2( t,s,freqPositif,SabsInteresting,SangleInteresting, 0.9 );








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% II.2) Cas de l'echantillonage irrégulier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all, clc
load data % A_th, f_th, phi_th, t, y
N = length(t);

% visualisation des donnees
figure(1);plot(t,y, '+'); %on voit bien les 5 nuits d'observation (unite de temps = jour)


%% II.2.1)
delta_t_min = min(t(2:end)-t(1:end-1)); % ecart de temps le plus faible
f_max = 1/(2*delta_t_min);% freq d'echantillonnage la plus elevee

% On fixe un pas de frequence pour notre echantillonnage entre 0 et fmax.
% On le prend suffisamment petit.
delta_f = f_max/10000;
freq=(0:delta_f:f_max)';
W=exp(2*j*pi*t*freq');


%% II.2.2) Application a une sinusoide de frequence f_0
f_0 = 50; % freq sinusoide
phi = 0.2;
s = sin(2*pi*f_0*t);

% FFT de s
fs = abs(W'*s)/N;

figure(1);plot(freq, fs); % representation frequentielle de fs
figure(2); plot(t, s); % representation temporelle
% Difficilement, bien que la frequence de la sinusoide apparait comme plus
% haute


%% II.2.3) Les 5 sinusoides du signal
x_wn = zeros(size(t),1);
for i = 1:size(t)
    x_wn(i) = sum(A_th.*cos(2*pi*f_th.*t(i) + phi_th)); % creation des donnees simulees non bruitees
end

Psignal = mean(x_wn.^2);
SNR=10;
Pnoise = Psignal/SNR;

noise = sqrt(Pnoise)*randn(size(t));
x = x_wn + noise; % donnees simulees bruitees
fx = abs(W'*x)/N; % FFT de x

% Representation freq et temporelle
figure(1);plot(freq, fx); % representation frequentielle de fs
xlim([28 38]);
title('Representation frequentielle de nos 5 signaux');

figure(2); plot(t, x); % representation temporelle
title('Representation temporelle des 5 signaux');


%% II.2.4) Fenetre spectrale
delta_f = f_max/5000;
freq=(-f_max:delta_f:f_max)';
W=exp(2*j*pi*t*freq');

Win = W'*ones(N,1);
figure(1); plot(freq,abs(Win)/N);
xlim([-7 7]);
% --> chaque frequence pure, au lieu d'etre representee comme un Dirac,
% va être representee comme une suite de bosses centree à cette frequence
% (à cause de la discretisation --> equivalent au cas du sinus cardinal
% pour l'echantillonage regulier)
% Les 2 plus gros lobes secondaires sont très gros, 0.7 fois le lobe principal
% Ils sont distants de 1 jour du lobe principal (logique car les mesures
% sont tous les jours ce qui induit une répétitivité artificielle).
% On retrouve ces faux pics dans la transformée de fourier

exemple = [ones(N,1) ; zeros(10000,1)];
N_new=length(exemple);
plot(abs(fftshift(fft( exemple )/N)));
xlim([5000 5500]);
% On voit que le premier pic d'un sinus cardinal est à 0.22, bien moins
% gênant que 0.7 pour l'échantillonage irregulier considéré
% Par contre les lobes secondaires plus éloignés sont plus gros dans le cas
% d'un echantillonage regulier

delta_f = f_max/10000;
freq=(0:delta_f:f_max)';
W=exp(2*j*pi*t*freq');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% III) Parcimonie par approches gloutonnes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% III.1) Matching pursuit (MP)

x = x_wn + noise; % donnees simulees bruitees
delta_f = f_max/10000;
freq=(0:delta_f:f_max)';
W=exp(2*j*pi*t*freq');

% Initialisation
k = 0;
l_freq = size(W,2);
gamma = [];
freq_extraites = [];
a = zeros(l_freq,1); % amplitudes correspondant aux frequences detectees.
r=x;
condition=1;

% Iterations
tau = chisqq(0.95,N);
T = sum(x.^2)/Pnoise;
fxb = abs(W'*x)/N; % FFT de x
figure(1); plot(freq, fxb); % representation frequentielle de fs
axis_before = axis;
xlim([28 38]);
ylim([axis_before(3) axis_before(4)]);
while(condition)
    pause
    [v, k] = max(fxb); % selection atome k
    gamma = [gamma k];
    coeff1=1/(W(:,k)'*W(:,k))*W(:,k)'*r;
    coeff2=conj(coeff1);
    a(k) = a(k) + coeff1; % MAJ de l'amplitude
    r = r - (coeff1*W(:,k) + coeff2*conj(W(:,k)));
    
    fxb = abs(W'*r)/N; % FFT de r
    freq(k) %v
    
    figure(1); plot(freq, fxb); % representation frequentielle de fs
    xlim([28 38]);
    ylim([axis_before(3) axis_before(4)]);
    title('Representation frequentielle de nos 5 signaux');
    
    T = sum(r.^2)/Pnoise;
    condition = (T>tau);
end

% Representation du signal final
x_new = W*a + conj(W*a);
%[I J v] = find(abs(a));

%f_th = [31.012 32.675 33.283 33.521 35.609];
%A_th = [0.25,0.75,1,0.75,1]

freq_extraites = freq(gamma)'
%    33.3077   33.5962   35.6154   31.6923   32.8462   33.2885  
%    34.0385   31.0385   33.5000   36.5962

abs(2*a(gamma))'
%     1.2473    0.9703    0.7617    0.3946    0.2232    0.2101    
%     0.1876    0.1548    0.1390    0.1202

fxb = abs(W'*x)/N; % FFT de x
figure(1); plot(freq, fxb); % representation frequentielle de fs
hold on;
stem(freq(gamma),abs(2*a(gamma)), 'r'); 
stem(f_th,A_th,'Color',[0 1 0]);
xlim([28 38]);
title('Representation frequentielle de nos 5 signaux');


%% III.2) Orthogonal Matching Pursuit (OMP)

x = x_wn + noise; % donnees simulees bruitees
delta_f = f_max/10000;
freq=(0:delta_f:f_max)';
W=exp(2*j*pi*t*freq');

% Initialisation
k = 0;
l_freq = size(W,2);
r = x;
gamma = [];
a = zeros(l_freq,1); % amplitudes correspondant aux frequences detectees.

% Iterations
tau = chisqq(0.95,N);
T = norm(r(:))^2/Pnoise;
Wt=[];
condition=1;

while(condition)
    [v, k] = max(fxb); % selection atome k
    gamma = [gamma k];    
    %Wt = [Wt, W(:,k)];
    Wt = [Wt, W(:,k), conj(W(:,k))];
    a = inv(Wt'*Wt) * Wt' * x;
    
    r = x - Wt * a;
    
    fxb = abs(W'*r(:,end))/N; % FFT de x
    freq(k) %v
    
    figure(1);plot(freq, fxb); % representation frequentielle de fs
    xlim([28 38]);
    ylim([axis_before(3) axis_before(4)]);
    title('Representation frequentielle de nos 5 signaux');
    pause
    
    %T = norm(r(:,end))^2/Pnoise;
    T = sum(r.^2)/Pnoise;
    condition = (T>tau);
end

x_new = Wt * a;
x_new(1:6)
% [I J v] = find(abs(a));

%f_th = [31.012 32.675 33.283 33.521 35.609];
%A_th = [0.25,0.75,1,0.75,1]

freq_extraites = freq(gamma)'
%    33.0000   33.3077   33.5962   35.6154   31.7115   31.0385   32.8269

abs(2*a(1:2:end))'
%    0.2148    1.0756    0.9690    0.8370    0.3495    0.2141    0.3056

fxb = abs(W'*x)/N; % FFT de x
figure(1); plot(freq, fxb); % representation frequentielle de fs
hold on;
stem(freq(gamma),abs(2*a(1:2:end)), 'r'); 
stem(f_th,A_th,'Color',[0 1 0]);
xlim([28 38]);
title('Representation frequentielle de nos 5 signaux');


%%  III.3) Orthogonal Least Square (OLS)
delta_f = f_max/3000;
x = x_wn + noise; % donnees simulees bruitees
% noise_vrai = y - x_wn;
% Pnoise_vrai = mean(noise_vrai.^2);
% P_x_wn = mean(x_wn.^2);

freq=(-f_max:delta_f:f_max)';
%freq=(0:delta_f:f_max)';
W=exp(2*j*pi*t*freq');

% freq=(0:delta_f:f_max)';
% W=[cos(2*pi*t*freq') sin(2*pi*t*freq')];
% freq = [freq freq];

T= chisqq(0.95,N)*Pnoise; % on multiplie par Pnoise car le critere d'arret 
% dans ols est fait avec T=|r|^2 au lieu de T=|r|^2/Pnoise

[x2, ind]=ols(W,x,Inf,T); %ols(W,y,Inf,T);

%f_th = [31.012 32.675 33.283 33.521 35.609];
%A_th = [0.25,0.75,1,0.75,1]
abs(freq(ind))'
abs(x2(ind))

fxb = abs(W'*x)/N; % FFT de x
figure(1); plot(freq, fxb); % representation frequentielle de fs
hold on;
stem(freq(ind),2*abs(x2(ind)), 'r'); 
stem(f_th,A_th,'Color',[0 1 0]);
xlim([28 38]);
title('Representation frequentielle de nos 5 signaux');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IV) Parcimonie par relaxation convexe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta_f = f_max/514;
x = x_wn + noise; % donnees simulees bruitees

freq=(-f_max:delta_f:f_max)';
%freq=(0:delta_f:f_max)';
W=exp(2*j*pi*t*freq');

% freq=(0:delta_f:f_max)';
% W=[cos(2*pi*t*freq') sin(2*pi*t*freq')];
% freq = [freq freq];

% mex min_L2_L1_0.c

% attention ! commencer par de grandes valeurs 
% de lambda et diminuer progressivement,
% car si lambda est trop petit, ça tourne sans s'arreter
% ou alors ça s'arrete au bout de 30 secondes avec ecrit 
% "min_L2_L1_0 did not converged in 100000 iterations"

lambda = 320;
a1=min_L2_L1_0(x,W,lambda);
indices = find(a1);
freq(indices)


%%%%%%%%%%%%%%%%%%%
% Conclusion
%%%%%%%%%%%%%%%%%%

% --> problème des lobes secondaires très gros, donc frequence factices à +
% ou - 1 (/jour). --> utiliser plusieurs observatoires ?
% ou alors espérer que les fréquences sont plus distantes que dans notre cas.

% Les deux fonctions sensées être les plus efficaces ne marchent pas en
% pratique, et sont difficiles à coder et longues à executer

% La fonction Orthogonal Matching Pursuit (OMP) offre un bon compromis :
% elle est à la fois meilleure que Matching Pursuit, et plus simple à coder
% que les deux autres.

% On trouve avec OMP des valeurs correctes, par exemple pour un SNR de 10 :

%f_th = [31.012 32.675 33.283 33.521 35.609];
%A_th = [0.25,0.75,1,0.75,1]
freq_extraites = freq(gamma)'
%    33.0000   33.3077   33.5962   35.6154   31.7115   31.0385   32.8269
abs(2*a(1:2:end))'
%    0.2148    1.0756    0.9690    0.8370    0.3495    0.2141    0.3056

% On remarque que 33.0000 est en fait un lobe de 31.012

% Les 2, 3 et 4eme detectes sont bons, mais pas très bons en intensité pour
% le 3eme et le 4eme. Ils correspondent respectivement aux pics 3, 4 et 5.

% 31.7115 est un lobe secondaire de 32.675

% 31.0385 est bon (il désigne en fait le pic 1, 31.012). L'intensité est
% correcte mais pas très bonne non plus (erreur relative de 20%)

% Enfin le pic n°2 est détecté, mais avec une intensité totalement fausse


% Conclusion : qualitativement, tous les pics ont été détectés, mais 2 faux
% pics ont également été détectés. Les intensités sont bien trouvées pour
% un pic, moyennement pour 3 pics, et très mal trouvée pour un pic.





