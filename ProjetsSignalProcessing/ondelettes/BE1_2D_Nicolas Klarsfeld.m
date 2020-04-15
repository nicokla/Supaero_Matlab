addpath(genpath('C:\Users\Nicolas K\Desktop\Ondelettes-BE1_Nicolas_Klarsfeld\IM_BE5_ondelettes1\toolbox_signal'));
addpath(genpath('C:\Users\Nicolas K\Desktop\Ondelettes-BE1_Nicolas_Klarsfeld\IM_BE5_ondelettes1\toolbox_general'));

%%%%%%%%%%%%%
% Copy past from html

%Set the support size. To begin, we select the D4 filter.
p = 4;

%Create the low pass filter h and the high pass g. We add a zero to ensure that it has a odd length. Note that the central value of h corresponds to the 0 position.
[h,g] = compute_wavelet_filter('Daubechies',p);

%Note that the high pass filter g is computed directly from the low pass filter as.
%g = [0 h(length(h):-1:2)] .* (-1).^(1:length(h))

%Display.
disp(['h filter = [' num2str(h) ']']);
disp(['g filter = [' num2str(g) ']']);

% Create a dummy signal.
n = 256;
f = rand(n,1);

% Low/High pass filtering followed by sub-sampling.
a = subsampling( cconv(f,h) );
d = subsampling( cconv(f,g) );

% Up-sampling followed by filtering.
f1 =  cconv(upsampling(a),reverse(h)) + cconv(upsampling(d),reverse(g));

% Check that we really recover the same signal.
disp(strcat((['Error |f-f1|/|f| = ' num2str(norm(f-f1)/norm(f))])));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First we load an image.
n = 256;
M = rescale( load_image('lena',n) );

% Initialize the transformed coefficients as the image itself and set the
% initial scale as the maximum one. MW will be iteratively transformated and will contains the coefficients.
MW = M;
j = log2(n)-1;

% Select the sub-part of the image to transform.
A = MW(1:2^(j+1),1:2^(j+1));

% Apply high and low filtering+subsampling in the vertical direction (1st ooordinate), to get coarse and details.
Coarse = subsampling(cconv(A,h,1),1);
Detail = subsampling(cconv(A,g,1),1);

% Note: subsamplling(A,1) is equivalent to A(1:2:end,:) and subsamplling(A,2) is equivalent to A(:,1:2:end).
% Concatenate them in the vertical direction to get the result.
A = cat3(1, Coarse, Detail );

% Display the result of the vertical transform.
clf;
imageplot(M,'Original imge',1,2,1);
imageplot(A,'Vertical transform',1,2,2);

% Apply high and low filtering+subsampling in the horizontal direction (2nd
% ooordinate), to get coarse and details.
Coarse = subsampling(cconv(A,h,2),2);
Detail = subsampling(cconv(A,g,2),2);

% Concatenate them in the horizontal direction to get the result.
A = cat3(2, Coarse, Detail );

% Assign the transformed data.
MW(1:2^(j+1),1:2^(j+1)) = A;

% Display the result of the horizontal transform.
clf;
imageplot(M,'Original image',1,2,1);
subplot(1,2,2);
plot_wavelet(MW,log2(n)-1); title('Transformed')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 1
% Implement a full wavelet transform that extract iteratively wavelet
% coefficients, by repeating these steps. Take care of choosing the 
% correct number of steps.

MW = M;
j = log2(n);
while j>0
    j=j-1;
    
    A = MW(1:2^(j+1),1:2^(j+1));
    Coarse = subsampling(cconv(A,h,1),1);
    Detail = subsampling(cconv(A,g,1),1);
    A = cat3(1, Coarse, Detail );

    Coarse = subsampling(cconv(A,h,2),2);
    Detail = subsampling(cconv(A,g,2),2);
    A = cat3(2, Coarse, Detail );
    MW(1:2^(j+1),1:2^(j+1)) = A;    
end
% clf;
% imageplot(M,'Original image',1,2,1);
% subplot(1,2,2);
% plot_wavelet(MW,1); title('Transformed')

for j=4:7
    subplot(3,4,8-j);
    imagesc(MW(1:2^j,2^j+1:2^(j+1)));
    title(['Horizontal, j=' int2str(j)]);
    axis image; axis off;
    
    subplot(3,4,12-j);
    imagesc(MW(2^j+1:2^(j+1),2^j+1:2^(j+1)));
    title(['Diagonal, j=' int2str(j)])
    axis image; axis off;
    
    subplot(3,4,16-j);
    imagesc(MW(2^j+1:2^(j+1),1:2^j));
    title(['Vertical, j=' int2str(j)])
    axis image; axis off;
end
colormap gray(256);


%%%%%%%%%%%%%
% Copy past from html

%Check for orthogonality of the transform (conservation of energy).

disp(strcat(['Energy of the signal       = ' num2str(norm(M(:)).^2)]));
disp(strcat(['Energy of the coefficients = ' num2str(norm(MW(:)).^2)]));

% Display the wavelet coefficients.
clf;
subplot(1,2,1);
imageplot(M); title('Original');
subplot(1,2,2);
plot_wavelet(MW, 1); title('Transformed');

% Initialize the image to recover M1 as the transformed coefficient, and
% select the smallest possible scale.
M1 = MW;
j = 0;

% Select the sub-coefficient to transform.
A = M1(1:2^(j+1),1:2^(j+1));

% Retrieve coarse and detail coefficients in the vertical direction (you
% can begin by the other direction, this has no importance).
Coarse = A(1:2^j,:);
Detail = A(2^j+1:2^(j+1),:);

% Undo the transform by up-sampling and then dual filtering.
Coarse = cconv(upsampling(Coarse,1),reverse(h),1);
Detail = cconv(upsampling(Detail,1),reverse(g),1);

% Recover the coefficient by summing.
A = Coarse + Detail;

% Retrieve coarse and detail coefficients in the vertical direction (you
% can begin by the other direction, this has no importance).
Coarse = A(:,1:2^j);
Detail = A(:,2^j+1:2^(j+1));

% Undo the transform by up-sampling and then dual filtering.
Coarse = cconv(upsampling(Coarse,2),reverse(h),2);
Detail = cconv(upsampling(Detail,2),reverse(g),2);

% Recover the coefficient by summing.
A = Coarse + Detail;

% Assign the result.
M1(1:2^(j+1),1:2^(j+1)) = A;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 2:
% Write the inverse wavelet transform that computes M1 from the
% coefficients MW. Compare M1 with M.
M1 = MW;
for j=0:log2(n)-1
    A = M1(1:2^(j+1),1:2^(j+1));
    Coarse = A(1:2^j,:);
    Detail = A(2^j+1:2^(j+1),:);
    Coarse = cconv(upsampling(Coarse,1),reverse(h),1);
    Detail = cconv(upsampling(Detail,1),reverse(g),1);
    A = Coarse + Detail;
    Coarse = A(:,1:2^j);
    Detail = A(:,2^j+1:2^(j+1));
    Coarse = cconv(upsampling(Coarse,2),reverse(h),2);
    Detail = cconv(upsampling(Detail,2),reverse(g),2);
    A = Coarse + Detail;
    M1(1:2^(j+1),1:2^(j+1)) = A;
    if(j>=3 && j<=6)
        subplot(2,2,7-j),imageplot(A);
        title(['Partial reconstruction, j=' int2str(j)]);
    end
end
% clf;
% subplot(1,2,1);
% imageplot(M); title('Original');
% subplot(1,2,2);
% imageplot(M1); title('Recovered');


%%%%%%%%%%%%%%%%%%%%%%%%%%
% copy paste from the html

% Check that we recover exactly the original image.
disp(strcat((['Error |M-M1|/|M| = ' num2str(norm(M(:)-M1(:))/norm(M(:)))])));

eta = 4;
MWlin = zeros(n,n);
MWlin(1:n/eta,1:n/eta) = MW(1:n/eta,1:n/eta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 3: (the solution is exo3.m) Compute and display the linear
% approximation Mlin obtained from the coefficients MWlin by inverse wavelet transform.

M1 = MWlin;
for j=0:log2(n)-1
    A = M1(1:2^(j+1),1:2^(j+1));
    Coarse = A(1:2^j,:);
    Detail = A(2^j+1:2^(j+1),:);
    Coarse = cconv(upsampling(Coarse,1),reverse(h),1);
    Detail = cconv(upsampling(Detail,1),reverse(g),1);
    A = Coarse + Detail;
    Coarse = A(:,1:2^j);
    Detail = A(:,2^j+1:2^(j+1));
    Coarse = cconv(upsampling(Coarse,2),reverse(h),2);
    Detail = cconv(upsampling(Detail,2),reverse(g),2);
    A = Coarse + Detail;
    M1(1:2^(j+1),1:2^(j+1)) = A;
end
clf;
subplot(1,2,1);
imageplot(M); title('Original');
subplot(1,2,2);
imageplot(M1); title(['Linear, SNR=' num2str(snr(M,M1),6)]);

%%%%%%%%%%%%%%%%%%%
% copy paste from html

% First select a threshold value (the largest the threshold, the more
% agressive the approximation).
T = .2;

% Then set to 0 coefficients with magnitude below the threshold.
MWT = MW .* (abs(MW)>T);

% Display thresholded coefficients.
clf;
subplot(1,2,1);
plot_wavelet(MW); axis('tight'); title('Original coefficients');
subplot(1,2,2);
plot_wavelet(MWT); axis('tight'); title('Thresholded coefficients');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 4: (the solution is exo4.m) Find the thresholds T so that the 
% number m of remaining coefficients in MWT are m=n^2/16. 
% Use this threshold to compute MWT and then display the corresponding 
% approximation Mnlin of M. 
% Compare this result with the linear approximation.

% T = .2;

% Then set to 0 coefficients with magnitude below the threshold.
L=sort(abs(MW(:)));
T=L(length(MW(:))*(1-1/16));
MWT = MW .* (abs(MW)>T);

% Display thresholded coefficients.
% clf;
% subplot(1,2,1);
% plot_wavelet(MW); axis('tight'); title('Original coefficients');
% subplot(1,2,2);
% plot_wavelet(MWT); axis('tight'); title('Thresholded coefficients');

M2 = MWT;
for j=0:log2(n)-1
    A = M2(1:2^(j+1),1:2^(j+1));
    Coarse = A(1:2^j,:);
    Detail = A(2^j+1:2^(j+1),:);
    Coarse = cconv(upsampling(Coarse,1),reverse(h),1);
    Detail = cconv(upsampling(Detail,1),reverse(g),1);
    A = Coarse + Detail;
    Coarse = A(:,1:2^j);
    Detail = A(:,2^j+1:2^(j+1));
    Coarse = cconv(upsampling(Coarse,2),reverse(h),2);
    Detail = cconv(upsampling(Detail,2),reverse(g),2);
    A = Coarse + Detail;
    M2(1:2^(j+1),1:2^(j+1)) = A;
end
clf;
subplot(1,2,1);
imageplot(M1); title(['Linear, SNR=' num2str(snr(M,M1),3)]);
subplot(1,2,2);
imageplot(M2); title(['Non-linear, SNR=' num2str(snr(M,M2),3)]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 5 (optionnal)
% Try with Different kind of wavelets,
% with an increasing number of vanishing moments.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 6 (optionnal)
% Implement the foward separable
% transform. Wavelet transformm in 1D each column M(:,i) to obtain
% coefficients MWsep(:,i). Then re-transform each row MWsep(i,:)', and store the result in MW(i,:)'.


%%%%%%%%%%%%%%%%
% Copy paste from the html

% Display the result.
clf;
subplot(1,2,1);
opt.separable = 0;
plot_wavelet(MW,1,opt);
title('Isotropic wavelets');
subplot(1,2,2);
opt.separable = 1;
plot_wavelet(MWsep,1,opt);
title('Separable wavelets');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 7 (optionnal)
% Implement the backward separable
% transform to recover an image M1 from the coefficients MWsep, which backward transform each row and then each columns.


%Check that we recover exactly the original image.
disp(strcat((['Error |M-M1|/|M| = ' num2str(norm(M(:)-M1(:))/norm(M(:)))])));

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 8 (optionnal)
% Perform m=n^2/16-terms best
% approximation with separable wavelet transform. Compare the result with isotropic wavelet approximation.



%%%%%%%%%%%%%%%%%%%%
% Exercice 9: (optionnal)
% Compute wavelets at several scales
% and orientation. Here we show only horizontal wavelets, in 2D.


%%%%%%%%%%%%%%%%%%%%%
% Exercice 10 (optionnal)
% Display Daubechies wavelets with different orientation, for different
% number of VM.




