

%% Parametres

ampli_th=ones(1,10);
frequence_th=[250 750 1250 1750 2250 2750 3250 3750 4250 4750];
tps_creneaux=0.020;
fe=15000;

%% Pre-process

nbcreneaux=length(ampli_th);
nb_pt=fe*tps_creneaux;
tk=(0:nb_pt-1)/fe;
t=(0:nbcreneaux*nb_pt-1)/fe;


%% Construction signal

s=[];

for k=0:nbcreneaux-1
    sk=ampli_th(k+1)*sin(2*pi*frequence_th(k+1)*tk);
    s=[s sk];
end

%% Representation du signal

sf=[];

for k=0:nbcreneaux-1
    sff=frequence_th(k+1) * ones(1,nb_pt) ;
    sf=[sf sff];
end

figure;
plot(t,s,t,sf/max(frequence_th),'ro');

nfft=length(s);
f=(-fe/2:fe/nfft:fe/2-fe/nfft);
TFs=abs(fftshift(fft(s,nfft)));
figure,plot(f,TFs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TF_signal = fft(s);
enleverDoublages = zeros(1,nfft);
enleverDoublages(1:nfft/2)=1;
TF_sans_doublage = 2 * enleverDoublages .* TF_signal ;
signal_analytique = ifft(TF_sans_doublage);

phase_instantanee = unwrap(angle(signal_analytique));
freq_instantanee = deriv(phase_instantanee,t);

plot(t,freq_instantanee);%,t,2*pi*sf,'ro');
% on multiplie par 2*pi 
% car sf est construit avec frequence_th qui est une pulsation et pas une
% fréquence

%%%%%%%%%%%%%%%%%%%%%
% [S,F,T,P] = spectrogram(x,window,noverlap,F,fs, 'yaxis')
window=100;
spectrogram(s,window,floor(window/2),256, fe,'yaxis');
window=20;
spectrogram(s,window,floor(window/2),256, fe,'yaxis');
S_abs=abs(S);
imagesc(S_abs);

%%%%%%%%%%%%%%%%%%%%%%%

paroleFile=load('Parole.mat');
parole=paroleFile.Phrase;
T=(length(parole)-1)/8000;
plot(-4000:1/T:4000,abs(fftshift(fft(parole))));
%sound(parole,8000);
fs=8000;
window=256;
a=2^(ceil(log2(window)));
spectrogram(parole,window,floor(window/2),a, fs,'yaxis');

%%%%%%%%%%%%%%%%%%%%%%%%

voyellesFile = load('Voyelles.mat');
voyelles=voyellesFile.Voyelles;
%sound(voyelles,8000);
fs=8000;
window=400;
interlap=0.9;
a=max(256,2^(ceil(log2(window))));
spectrogram(voyelles,window,floor(interlap*window),a, fs,'yaxis');


%%%%%%%%%%%%%%%%%%%%%%%%%

lettreEliseFile = load('LettreElise.mat');
lettreElise=lettreEliseFile.LettreElise;
%sound(lettreElise,8000);
% lettreElise_spec=spectrogram(lettreElise,400);%,100,1); // 8000/20=400, 20Hz.
% imagesc(log(abs(lettreElise_spec)));
% 
% lettreElise_abs_log=log(abs(lettreElise_spec));
% note=max(lettreElise_abs_log,[],1);
% plot(note);

fs=8000;
window=400;
interlap=0.9;
a=max(256,2^(ceil(log2(window))));
spectrogram(lettreElise,window,floor(interlap*window),a, fs,'yaxis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s=lettreElise;
nfft=length(s);
t=(0:nfft-1)/8000;
TF_signal = fft(s);
enleverDoublages = zeros(1,nfft);
enleverDoublages(1:nfft/2)=1;
TF_sans_doublage = 2 * enleverDoublages .* TF_signal ;
signal_analytique = ifft(TF_sans_doublage);

phase_instantanee = unwrap(angle(signal_analytique));
freq_instantanee = deriv(phase_instantanee,t)/2/pi;
%plot(t,freq_instantanee);
freq_inst_moy =conv(ones(1,400),freq_instantanee);
hold on; plot(freq_inst_moy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=0:1/8000:3;
f1=400;
f2=200;
s=0.4*sin(2*pi*t*f1) + sin(2*pi*t*f2);
nfft=length(s);
TF_signal = fft(s);
%plot(-4000:1/3:4000,fftshift(abs(TF_signal)));
enleverDoublages = zeros(1,nfft);
enleverDoublages(1:nfft/2)=1;
TF_sans_doublage = 2 * enleverDoublages .* TF_signal ;
%plot(-4000:1/3:4000,fftshift(abs(TF_sans_doublage)));
signal_analytique = ifft(TF_sans_doublage);
phase_instantanee = unwrap(angle(signal_analytique));
%plot(t,phase_instantanee);
freq_instantanee = deriv(phase_instantanee,t)/2/pi;
plot(t,freq_instantanee);
% 
% freq_inst_moy =conv(ones(1,100),freq_instantanee);
% plot(freq_inst_moy);

