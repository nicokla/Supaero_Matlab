%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('C:\Users\Nicolas K\Desktop\Ondelettes-BE2-debruitage_Nicolas_Klarsfeld\IM_BE6_ondelettes2\toolbox_signal'));
addpath(genpath('C:\Users\Nicolas K\Desktop\Ondelettes-BE2-debruitage_Nicolas_Klarsfeld\IM_BE6_ondelettes2\toolbox_general'));

%%%%%%%%%%%%%%%%%%%%
% copy past from the html file

% First we load the 1D signal.
% size
n = 2048;

% clean signal
name = 'piece-regular';
x0 = load_signal(name, n);
x0 = rescale(x0,.05,.95);

% Then we add some Gaussian noise.
sigma = 0.07;
x = x0 + randn(size(x0))*sigma;

% Display.
clf;
subplot(2,1,1);
plot(x0); axis([1 n 0 1]);
title('Clean signal');
subplot(2,1,2);
plot(x); axis([1 n 0 1]);
title('Noisy signal');

% threshold value
T = 1;
v = -linspace(-3,3,2000);
% hard thresholding of the t values
v_hard = v.*(abs(v)>T);
% soft thresholding of the t values
v_soft = max(1-T./abs(v), 0).*v;
% display
clf;
hold('on');
plot(v, v_hard);
plot(v, v_soft, 'r--');
axis('equal'); axis('tight');
legend('Hard thresholding', 'Soft thresholding');
hold('off');

% First we compute the wavelet coefficients of the noisy signal.
options.ti = 0;
Jmin = 4;
xW = perform_wavelet_transf(x,Jmin,+1,options);

% Then we hard threshold the coefficients below the noise level. In
% practice a threshold of 3*sigma is close to optimal for piecewise regular signals.
T = 3*sigma;
xWT = perform_thresholding(xW,T,'hard');
clf;
subplot(2,1,1);
plot_wavelet(xW,Jmin); axis([1 n -1 1]);
title('Noisy coefficients');
set_axis(0);
subplot(2,1,2);
plot_wavelet(xWT,Jmin); axis([1 n -1 1]);
title('Thresholded coefficients');
set_axis(0);

% One can then reconstruct from these noisy coefficients.
xhard = perform_wavelet_transf(xWT,Jmin,-1,options);

% We can display and measure performance using SNR.
clf;
subplot(2,1,1);
plot(x); axis([1 n 0 1]);
title('Noisy');
subplot(2,1,2);
plot(xhard); axis([1 n 0 1]);
title(strcat(['Hard denoising, SNR=' num2str(snr(x0,xhard))]));


T = 1.5*sigma;
xWT = perform_thresholding(xW,T,'soft');
% re-inject the low frequencies
xWT(1:2^Jmin) = xW(1:2^Jmin);
% re-construct
xsoft = perform_wavelet_transf(xWT,Jmin,-1,options);

% We can display the results.
clf;
subplot(2,1,1);
plot(xhard); axis([1 n 0 1]);
title(strcat(['Hard denoising, SNR=' num2str(snr(x0,xhard))]));
subplot(2,1,2);
plot(xsoft); axis([1 n 0 1]);
title(strcat(['Soft denoising, SNR=' num2str(snr(x0,xsoft))]));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 1
% Determine the best threshold T for both hard and soft thresholding. Test
% several T values in [.8*sigma, 4.5*sigma]. Do not forget to keep the 
% low frequency wavelet coefficients. 
% What can you conclude from these results ? Test with another image.

Tvalues=linspace(.8*sigma,4.5*sigma,50);
snrListSoft=zeros(size(Tvalues));
snrListHard=zeros(size(Tvalues));

for i=1:length(Tvalues)
    T=Tvalues(i);
    
    xWT = perform_thresholding(xW,T,'soft');
    xWT(1:2^Jmin) = xW(1:2^Jmin);
    xsoft = perform_wavelet_transf(xWT,Jmin,-1,options);
    
    xWT = perform_thresholding(xW,T,'hard');
    xhard = perform_wavelet_transf(xWT,Jmin,-1,options);
    
    snrListSoft(i)=snr(x0,xsoft);
    snrListHard(i)=snr(x0,xhard);
end

[C,I]=max(snrListSoft);
Tsoft=Tvalues(I);
snrSoft = snrListSoft(I);
plot(Tvalues/sigma,snrListSoft);

[C,I]=max(snrListHard);
Thard=Tvalues(I);
snrHard = snrListHard(I);
plot(Tvalues/sigma,snrListHard);

%%%%%%%%%%%%%%%%%%%%%%%%%
% copy past from the html file
options.ti = 1;
xW = perform_wavelet_transf(x0,Jmin,+1,options);

% xW(:,:,1) corresponds to the low scale residual. Each xW(:,1,j)
% corresponds to a scale of wavelet coefficient, and has the same size as
% the original signal.
nJ = size(xW,3);
clf;
subplot(5,1, 1);
plot(x0); axis('tight');
title('Signal');
i = 0;
for j=1:3
    i = i+1;
    subplot(5,1,i+1);
    plot(xW(:,1,nJ-i+1)); axis('tight');
    title(strcat(['Scale=' num2str(j)]));
end
subplot(5,1, 5);
plot(xW(:,1,1)); axis('tight');
title('Low scale');


%%%%%%%%%%%%%%%%%
% Translation invariant case (copy paste from html)

% First we compute the translation invariant wavelet transform
options.ti = 1;
xW = perform_wavelet_transf(x,Jmin,+1,options);

% Then we threshold the set of coefficients.
T = 3.5*sigma;
xWT = perform_thresholding(xW,T,'hard');

% We can display some wavelets coefficients
J = size(xW,3)-2;
clf;
subplot(2,1,1);
imageplot(xW(:,:,J));
title('Noisy coefficients');
subplot(2,1,2);
imageplot(xWT(:,:,J));
title('Thresholded coefficients');

% We can now reconstruct.
xti = perform_wavelet_transf(xWT,Jmin,-1,options);

% Display the results.
clf;
subplot(2,1,1);
plot(xhard); axis([1 n 0 1]);
title(strcat(['Hard orthogonal, SNR=' num2str(snr(x0,xhard))]));
subplot(2,1,2);
plot(xti); axis([1 n 0 1]);
title(strcat(['Hard invariant, SNR=' num2str(snr(x0,xti))]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 2
% Determine the best threshold T for both hard and soft thresholding, but
% now in the translation invariant case. Do not forget not to threshold the
% low scale wavelets coefficients. What can you conclude ?

% --> Meme code que pour l'exercice 1, mais xW a changé car on a pris
% option.ti=1, ce qui signifie qu'on est dans le cas invariant par
% translation

Tvalues=linspace(.8*sigma,4.5*sigma,50);
snrListSoft=zeros(size(Tvalues));
snrListHard=zeros(size(Tvalues));

for i=1:length(Tvalues)
    T=Tvalues(i);
    
    xWT = perform_thresholding(xW,T,'soft');
    xWT(1:2^Jmin) = xW(1:2^Jmin);
    xsoft = perform_wavelet_transf(xWT,Jmin,-1,options);
    
    xWT = perform_thresholding(xW,T,'hard');
    xhard = perform_wavelet_transf(xWT,Jmin,-1,options);
    
    snrListSoft(i)=snr(x0,xsoft);
    snrListHard(i)=snr(x0,xhard);
end

[C,I]=max(snrListSoft);
Tsoft=Tvalues(I);
snrSoft = snrListSoft(I);
plot(Tvalues/sigma,snrListSoft);

[C,I]=max(snrListHard);
Thard=Tvalues(I);
snrHard = snrListHard(I);
plot(Tvalues/sigma,snrListHard);

% --> les courbes montent plus haut dans le cas "translation invariant",
% mais leur maximas sont atteints au
% mêmes endroits, ie 1.5 * sigma pour soft et 3*sigma pour hard.


