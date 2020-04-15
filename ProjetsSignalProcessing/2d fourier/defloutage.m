%%%%%%%%%%%%%%%%%%%%%%
%% Introduction

N=512;
B=20;
I = zeros(N,N);
for c=1:N
    if(rem(floor(c/B),2))
        I(:,c)=1;
    end
end
%J=imrotate(I,45);
subplot(1,2,1), imshow(I);
subplot(1,2,2), imshow(abs(fftshift(fft2(I))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r=7;
s=19;
j=N/2;
j=N/2;
I = zeros(N,N);
I(N/2-floor(r/2):N/2+floor(r/2),N/2-floor(s/2):N/2+floor(s/2))=1;
subplot(1,2,1), imshow(I);
subplot(1,2,2), imshow(abs(fftshift(fft2(I))));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=100;
T=3;
X=-3*N/2:3*N/2;

f1=sinc(2*X/N*(T+0.5));
f2=zeros(size(X));
for(i=1:length(X))
    f2(i)=quasiSinc(T,X(i),N);
end

hold on;
plot(X,f1);
plot(X,f2);
plot([X(1) X(end)], [0 0], 'k-');



%%%%%%%%%%%%%%%%%%%%%%
%% Debut defloutage
lenna=imread('lenna.bmp');
%lenna=imread('toulouse.bmp');
%lenna=imread('marcheur.jpg');

lennaGray=rgb2gray(lenna);
%lennaGray=lenna;

M=size(lennaGray,1);
N=size(lennaGray,2);

%%%%%%%%%%%%%%%%%%%%%%%

T=3;
porte=ones(2*T+1,2*T+1)/((2*T+1)^2);

% lennaGrayFloue = imfilter(lennaGray,porte,'conv');
lennaGrayFloue = conv2(lennaGray,porte);
lennaGrayFloue = lennaGrayFloue/max(max(lennaGrayFloue));

subplot(1,2,1), imshow(lennaGray);
subplot(1,2,2), imshow(lennaGrayFloue);

%%%%%%%%%%%%%%%%%%%%%%%

lennaGrayFourierShift = fftshift(fft2(lennaGray));
lennaGrayFloueFourierShift = fftshift(fft2(lennaGrayFloue));
lennaGrayFloueFourier=fft2(lennaGrayFloue);
lennaGrayFourier=fft2(lennaGray);

subplot(1,2,1),imagesc(log(abs(lennaGrayFourierShift)+0.000000001));
subplot(1,2,2), imagesc(log(abs(lennaGrayFloueFourierShift)+0.000000001));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m1 = mean(abs(lennaGrayFloueFourier),1); % attention m1 est de taille 1*size(t,2)
figure, plot(fftshift(log(m1)));

m2 = mean(abs(lennaGrayFloueFourier),2); % attention m2 est de taille size(t,1)*1
figure, plot(fftshift(log(m2)));

i=1;
while(m1(i)>0.01 && i<length(m1))
    i=i+1;
end
i2_suppose=i;
T2_suppose=uint8(((size(lennaGrayFloueFourier,2)/(i2_suppose-1))-1)/2);

i=1;
while(m2(i)>0.01 && i<=length(m2))
    i=i+1;
end
i1_suppose=i;
T1_suppose=uint8(((size(lennaGrayFloueFourier,1)/(i1_suppose-1))-1)/2);

%T1_suppose=T;
%T2_suppose=T;

X1=0:M+2*T-1;
f1=zeros(1,M+2*T);
for i = 1:M+2*T
    f1(i)=quasiSinc(double(T1_suppose),X1(i),M+2*T);
end

X2=0:N+2*T-1;
f2=zeros(1,N+2*T);
for i = 1:N+2*T
    f2(i)=quasiSinc(double(T2_suppose),X2(i),N+2*T);
end

matSinc=f1'*f2;
imshow(abs(fftshift(matSinc)));

% matFloutage=zeros(size(lennaGrayFloueFourier2));
% % matFloutage(N/2-T:N/2+T,M/2-T:M/2+T)=1;
% matFloutage(1:2*T1_suppose+1,1:2*T2_suppose+1)=1;
% matSinc=fft2(matFloutage);
% imshow(abs(matSinc));

% imshow(lennaGrayFloueFourier2)
% imshow(abs(matSinc))
% 
% imshow(fftshift(abs(matSinc)))
% figure, imshow(fftshift(lennaGrayFloueFourier2))

% lennaGrayFloueDeflouteeFourier=lennaGrayFloueFourier2./matSinc;
% pb : divisions par zero.
% max(max(lennaGrayFloueDeflouteeFourier))
% min(min(abs(matSinc)))
threshold=1E-12;
matSincWithoutZeros=zeros(size(matSinc));
for i=1:size(matSinc,1)
    for j=1:size(matSinc,2)
        if(abs(matSinc(i,j))<threshold)
            %matSinc(i,j)=1;
            if(matSinc(i,j)<0)
                %matSincWithoutZeros(i,j)=(-threshold);
                matSincWithoutZeros(i,j)=1;
            else
                %matSincWithoutZeros(i,j)=threshold;
                matSincWithoutZeros(i,j)=1;
            end
        else
            matSincWithoutZeros(i,j)=matSinc(i,j);
        end
    end
end
lennaGrayFloueDeflouteeFourier=lennaGrayFloueFourier./matSincWithoutZeros;
lennaGrayDefloutee = abs(ifft2(lennaGrayFloueDeflouteeFourier));

subplot(1,3,1),imshow(lennaGray);
subplot(1,3,2), imshow(lennaGrayFloue);
subplot(1,3,3),imshow(lennaGrayDefloutee);

figure, imshow(fft2(lennaGray))
figure, imshow(lennaGrayFloueDeflouteeFourier)
figure, imshow( matSincWithoutZeros)
%figure, imshow(abs(matSinc)<threshold);
%figure, imshow(fftshift(abs(matSinc)<threshold));



