%%%%%%%
% copy paste du html

% getd = @(p)path(path,p); % scilab users must *not* execute this
% getd('toolbox_signal/');
% getd('toolbox_general/');
addpath(genpath('C:\Users\Nicolas K\Desktop\Ondelettes-BE2_Nicolas_Klarsfeld\IM_BE6_ondelettes2\toolbox_signal'));
addpath(genpath('C:\Users\Nicolas K\Desktop\Ondelettes-BE2_Nicolas_Klarsfeld\IM_BE6_ondelettes2\toolbox_general'));

M0 = im2double(rgb2gray(imread('lenna.bmp')));
M0 = downsample(M0,2);
M0 = M0';
M0 = downsample(M0,2);
M0=M0';

%name ='boat'; %'lenna.bmp';%'boat';
n = 256;
%M0 = rescale( load_image(name,n) );

sigma = .08; % noise level
M = M0 + sigma*randn(size(M0));

clf;
imageplot(M0, 'Original', 1,2,1);
imageplot(clamp(M), 'Noisy', 1,2,2);


% threshold value
T = 1;
v = -linspace(-3,3,2000);
% hard thresholding of the t values
v_hard = v.*(abs(v)>T);
% soft thresholding of the t values
v_soft = max(1-T./abs(v), 0).*v;

clf;
hold('on');
h = plot(v, v_hard);
if using_matlab()
    set(h, 'LineWidth', 2);
end
h = plot(v, v_soft, 'r--');
if using_matlab()
    set(h, 'LineWidth', 2);
end
axis('equal'); axis('tight');
legend('Hard thresholding', 'Soft thresholding');
hold('off');


options.ti = 0;
Jmin = 4;

MW = perform_wavelet_transf(M,Jmin,+1,options);

T = 3*sigma;

MWT = MW .* (abs(MW)>T);

clf;
subplot(1,2,1);
plot_wavelet(MW,Jmin);
title('Noisy coefficients');
set_axis(0);
subplot(1,2,2);
plot_wavelet(MWT,Jmin);
title('Thresholded coefficients');
set_axis(0);

Mhard = perform_wavelet_transf(MWT,Jmin,-1,options);

clf;
imageplot(clamp(M), strcat(['Noisy, SNR=' num2str(snr(M0,M),3)]), 1,2,1);
imageplot(clamp(Mhard), strcat(['Hard denoising, SNR=' num2str(snr(M0,Mhard),3)]), 1,2,2);

T = 3/2*sigma;

MWT = perform_thresholding(MW,T,'soft');

MWT(1:2^Jmin,1:2^Jmin) = MW(1:2^Jmin,1:2^Jmin);

Msoft = perform_wavelet_transf(MWT,Jmin,-1,options);

clf;
imageplot(clamp(Mhard), strcat(['Hard denoising, SNR=' num2str(snr(M0,Mhard),3)]), 1,2,1);
imageplot(clamp(Msoft), strcat(['Soft denoising, SNR=' num2str(snr(M0,Msoft),3)]), 1,2,2);


%%%%%%%%%%%%%%%%%%%%%%
% Exercice 1
% Determine the best threshold T for 
% both hard and soft thresholding. 
% Test several T values in [.8*sigma, 4.5*sigma]. 
% Do not forget to keep the low frequency wavelet coefficients. 
% What can you conclude from these results ? Test with another image. 

options.ti = 0;
Jmin = 4;
Tall = linspace(0.8*sigma, 4.5*sigma, 50);
erreur_temp=zeros(size(Tall));

MW = perform_wavelet_transf(M,Jmin,+1,options);
for index = 1:length(Tall)
    MWT = MW .* (abs(MW)>Tall(index));
    Mhard = perform_wavelet_transf(MWT,Jmin,-1,options);
    erreur_temp(index)=snr(M0,Mhard);
end
plot(Tall/sigma,erreur_temp);
[C,I]=max(erreur_temp);
Thard=Tall(I);
snrHard = erreur_temp(I);
MWT = MW .* (abs(MW)>Thard);
Mhard = perform_wavelet_transf(MWT,Jmin,-1,options);
clf;
imageplot(clamp(M), strcat(['Noisy, SNR=' num2str(snr(M0,M),3)]), 1,2,1);
imageplot(clamp(Mhard), strcat(['Hard denoising, SNR=' num2str(snr(M0,Mhard),3)]), 1,2,2);


MW = perform_wavelet_transf(M,Jmin,+1,options);
for index = 1:length(Tall)
    MWT = perform_thresholding(MW,Tall(index),'soft');
    MWT(1:2^Jmin,1:2^Jmin) = MW(1:2^Jmin,1:2^Jmin);
    Msoft = perform_wavelet_transf(MWT,Jmin,-1,options);
    erreur_temp(index)=snr(M0,Msoft);
end
plot(Tall/sigma,erreur_temp);
[C,I]=max(erreur_temp);
Tsoft=Tall(I);
snrSoft = erreur_temp(I);
MWT = perform_thresholding(MW,Tsoft,'soft');
MWT(1:2^Jmin,1:2^Jmin) = MW(1:2^Jmin,1:2^Jmin);
Msoft = perform_wavelet_transf(MWT,Jmin,-1,options);
clf;
%imageplot(clamp(M), strcat(['Noisy, SNR=' num2str(snr(M0,M),3)]), 1,2,1);
imageplot(clamp(Mhard), strcat(['Hard denoising, SNR=' num2str(snr(M0,Mhard),3)]), 1,2,1);
imageplot(clamp(Msoft), strcat(['Soft denoising, SNR=' num2str(snr(M0,Msoft),3)]), 1,2,2);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copy paste du html

m = 4;

% Initialize the denoised image.
Mti = zeros(n,n);

% Generate a set of shift.
[dY,dX] = meshgrid(0:m-1,0:m-1);

% Here is a typical application of one step of the scheme.
%The index i should run in 1,...,m^2
%i = 10;

% Apply the shift, using circular boundary conditions.
%Ms = circshift(M,[dX(i) dY(i)]);

% Apply here the denoising to Ms.
% After denoising, do the inverse shift.
%Ms = circshift(Ms,-[dX(i) dY(i)]);

% Accumulate the result to obtain at the end the denoised image that averahe the translated results.
%Mti = (i-1)/i*Mti + 1/i*Ms;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 2
% Perform the cycle spinning denoising by iterating on i. 
% --> see exercice 3, consisting of doing exercice 2 several times with a
% for loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 3
% Study the influence of the number m of shift on the denoising quality 

m_max=7;
snr_cycle = zeros(1,m_max);
for m = 1:m_max
    Mti = zeros(n,n);
    [dY,dX] = meshgrid(0:m-1,0:m-1);
    for i=1:m^2
        % Apply the shift, using circular boundary conditions.
        Ms = circshift(M,[dX(i) dY(i)]);

        % Apply here the denoising to Ms.
        MW = perform_wavelet_transf(Ms,Jmin,+1,options);
        MWT = perform_thresholding(MW,Tsoft,'soft');
        MWT(1:2^Jmin,1:2^Jmin) = MW(1:2^Jmin,1:2^Jmin);
        Ms = perform_wavelet_transf(MWT,Jmin,-1,options);

        % After denoising, do the inverse shift.
        Ms = circshift(Ms,-[dX(i) dY(i)]);

        % Accumulate the result to obtain at the end the denoised image that averahe the translated results.
        Mti = (i-1)/i*Mti + 1/i*Ms;
    end
    snr_cycle(m) = snr(M0,Mti);
end
plot(snr_cycle)
imshow(Mti);
M_soft_cycle7 = Mti;
snr_cycle7 = snr_cycle(m_max);

imageplot(clamp(M_soft_cycle7), strcat(['Cycle denoising, SNR=' num2str(snr(M0,M_soft_cycle7),3)]), 1,2,1);
imageplot(clamp(Msoft), strcat(['Soft denoising, SNR=' num2str(snr(M0,Msoft),3)]), 1,2,2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copy paste du html

options.ti = 1;
MW = perform_wavelet_transf(M0,Jmin,+1,options);

%MW(:,:,1) corresponds to the low scale residual. 
%Each MW(:,:,3*j+k+1) for k=1:3 (orientation) corresponds to a scale
%of wavelet coefficient, and has the same size as the original image.

clf;
i = 0;
for j=1:2
    for k=1:3
        i = i+1;
        imageplot(MW(:,:,i+1), strcat(['Scale=' num2str(j) ' Orientation=' num2str(k)]), 2,3,i );
    end
end


options.ti = 1;
MW = perform_wavelet_transf(M,Jmin,+1,options);

%Then we threshold the set of coefficients.
T = 3.5*sigma;
MWT = perform_thresholding(MW,T,'hard');

%We can display some wavelets coefficients
J = size(MW,3)-5;
clf;
imageplot(MW(:,:,J), 'Noisy coefficients', 1,2,1);
imageplot(MWT(:,:,J), 'Thresholded coefficients', 1,2,2);

%We can now reconstruct
Mti = perform_wavelet_transf(MWT,Jmin,-1,options);

%Display the denoising result.
clf;
imageplot(clamp(Msoft), strcat(['Soft orthogonal, SNR=' num2str(snr(M0,Msoft),3)]), 1,2,1);
imageplot(clamp(Mti), strcat(['Hard invariant, SNR=' num2str(snr(M0,Mti),3)]), 1,2,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 4
% Determine the best threshold T 
% for both hard and soft thresholding, but now 
% in the translation invariant case. What can you conclude ? 

options.ti = 1;
MW = perform_wavelet_transf(M,Jmin,+1,options);
for index = 1:length(Tall)
    MWT = perform_thresholding(MW,Tall(index),'soft');
    MWT(1:2^Jmin,1:2^Jmin) = MW(1:2^Jmin,1:2^Jmin);
    Msoft_invariant = perform_wavelet_transf(MWT,Jmin,-1,options);
    erreur_temp(index)=snr(M0,Msoft_invariant);
end
plot(Tall/sigma,erreur_temp);
[C,I]=max(erreur_temp);
TsoftInvariant=Tall(I);
snrSoftInvariant = erreur_temp(I);
MWT = perform_thresholding(MW,TsoftInvariant,'soft');
MWT(1:2^Jmin,1:2^Jmin) = MW(1:2^Jmin,1:2^Jmin);
Msoft_invariant = perform_wavelet_transf(MWT,Jmin,-1,options);
clf;
%imageplot(clamp(M), strcat(['Noisy, SNR=' num2str(snr(M0,M),3)]), 1,2,1);
imageplot(clamp(Msoft_invariant), strcat(['Soft invariant denoising, SNR=' num2str(snr(M0,Msoft_invariant),3)]), 1,2,1);
imageplot(clamp(Msoft), strcat(['Soft denoising, SNR=' num2str(snr(M0,Msoft),3)]), 1,2,2);

snr(M0,Msoft_invariant)
snr(M0,M_soft_cycle7)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% best denoising = soft invariant

% imageplot(clamp(M0), 'Image de depart', 1,3,1);
% imageplot(clamp(M), 'Image buitée', 1,3,2);
% imageplot(clamp(Msoft_invariant), strcat(['Soft invariant denoising, SNR=' num2str(snr(M0,Msoft_invariant),3)]), 1,3,3);

subplot(2,2,1)
imshow(clamp(M0));
subplot(2,2,2)
imshow(clamp(M));
subplot(2,2,3)
imshow(clamp(Msoft_invariant));
