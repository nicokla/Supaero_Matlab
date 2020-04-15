
%% 1) Generation d'un melange artificiel de 2 sources artificielles

close all
clear all
clc;

rand('seed',1);
taille=1000;
s1 = rand(1, taille);
s2 = rand(1, taille);

s1=s1-mean(s1);
s2=s2-mean(s2);
s1=sqrt(taille)*s1/norm(s1);%puissance de 1
s2=sqrt(taille)*s2/norm(s2);

correlation=mean(s1.*s2) % corr = E( (s1-E(s1)) * (s2-E(s2)) )

scatter(s1,s2)

A=[1 0.7;0.8 1]
mel= A*[s1; s2];
o1 = mel(1,:);
o2 = mel(2,:);

correlation_obs=taille*mean(o1.*o2)/(norm(o1)*norm(o2));% les observations ne sont pas independante ( correlation_obs>correlation )

scatter(o1,o2)


%% 2) Blanchiment
%A*A'
covMat = mel*mel'/taille;
[H1,D,H2]=svd(covMat);%eig
M=(D^(-1/2))*H2;% Matrice de decorelation
z=M*mel;
scatter(z(1,:),z(2,:))
z1=z(1,:);
z2=z(2,:);
correlation_z=taille*mean(z1.*z2)/(norm(z1)*norm(z2));


%% 3) Estimation des sources

w1=[1; 0];
w1_apres=rand(2,1);
perfo = [];
w_evolution=[];
y=w1_apres'*z;
while(norm(w1-w1_apres) > 1e-6)
    w1=w1_apres;
    w1_apres= sign(kurtosis2(y))*(mean( z.*(ones(2,1)*((w1_apres'*z).^3)) , 2) - 3*w1_apres);
    w1_apres=w1_apres/norm(w1_apres);
    y=w1_apres'*z;
    perfo = [perfo abs(kurtosis2(y))];
    w_evolution=[w_evolution w1_apres];
end
y1=w1'*z;
plot(perfo);
figure, plot(w_evolution);
alpha=atan(-w1(1)/w1(2));
180/pi*alpha
w2=[-w1(2); w1(1)];
y2=-w2'*z;
scatter(y1,y2)

% 4) Rapport signal sur Interférence

rsi1=10*log10(mean(s1.^2,2)/mean((s1+y1).^2,2));
rsi2=10*log10(mean(s2.^2,2)/mean((s2+y2).^2,2));
rsi=(rsi1+rsi2)/2;


%%%%%
% 5) Tests avec d'autres signaux

%% 5.1) Son
o1_son = wavread('audio_mix1.wav');
[o2_son , Fs] = wavread('audio_mix2.wav');
[ y1, y2 ] = FastICA(o1_son, o2_son);
y1=y1/max(abs(y1));
y2=y2/max(abs(y2));
subplot(2,2,1),plot(o1_son), legend('Observation 1');
subplot(2,2,2),plot(o2_son), legend('Observation 2');
subplot(2,2,3), plot(y1), legend('Source reconstituée 1');
subplot(2,2,4), plot(y2), legend('Source reconstituée 2');
%sound(y1); % ... attendre avant d'appeler sound(y2), sinon le micro mélange les deux ...
%sound(y2);


%% 5.2) Images
o1_im = imread('image_mix1.bmp');
o2_im = imread('image_mix2.bmp');
[ y1, y2 ] = FastICA(o1_im, o2_im );

max1=max(y1(:));
min1=min(y1(:));
y1=(y1-min1)/(max1-min1);
y1=1-y1;

max2=max(y2(:));
min2=min(y2(:));
y2=((y2-min2)/(max2-min2));
y2=1-y2;
y2=y2(:,end:-1:1);

subplot(1,4,1),imshow(o1_im), legend('Observation 1');
subplot(1,4,2),imshow(o2_im), legend('Observation 2');
subplot(1,4,3), imshow(y1), legend('Source reconstituée 1');
subplot(1,4,4), imshow(y2), legend('Source reconstituée 2');



