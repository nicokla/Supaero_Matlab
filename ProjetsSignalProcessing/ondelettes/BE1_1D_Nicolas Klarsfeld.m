%getd = @(p)path(path,p);
%getd('toolbox_signal/');
%getd('toolbox_general/');
addpath(genpath('C:\Users\Nicolas K\Desktop\supaero sauvegarde\0) fini\Ondelettes-BE1_Nicolas_Klarsfeld\IM_BE5_ondelettes1\toolbox_signal'));
addpath(genpath('C:\Users\Nicolas K\Desktop\supaero sauvegarde\0) fini\Ondelettes-BE1_Nicolas_Klarsfeld\IM_BE5_ondelettes1\toolbox_general'));

%%%%%%%%%%%%%%%%%%%%
% copy past from html
p = 4;
[h,g] = compute_wavelet_filter('Daubechies',p);
%g = [0 h(length(h):-1:2)] .* (-1).^(1:length(h))

disp(strcat(['h filter = [' num2str(h) ']']));
disp(strcat(['g filter = [' num2str(g) ']']));

n = 256;
f = rand(n,1);

a = subsampling( cconv(f,h) );
d = subsampling( cconv(f,g) );

f1 =  cconv(upsampling(a),reverse(h)) + cconv(upsampling(d),reverse(g));

disp(strcat((['Error |f-f1|/|f| = ' num2str(norm(f-f1)/norm(f))])));

%%%%%%%%%%%%%%%%%%%%%
% copy past from html

name = 'piece-regular';
n = 512;
f = rescale( load_signal(name, n) );

% fw = f;
% j = log2(n)-1;
% 
% A = fw(1:2^(j+1));
% Coarse = subsampling(cconv(A,h));
% Detail = subsampling(cconv(A,g));
% 
% A = [Coarse; Detail];

% clf;
% subplot(2,1,1);
% plot(f); axis('tight'); title('Signal');
% subplot(2,1,2);
% plot(A); axis('tight'); title('Transformed');
% 
% s = 400; t = 40;
% clf;
% subplot(2,1,1);
% plot(f,'.-'); axis([s-t s+t 0 1]); title('Signal (zoom)');
% subplot(2,1,2);
% plot(Coarse,'.-'); axis([(s-t)/2 (s+t)/2 min(A) max(A)]); title('Averages (zoom)');


%%%%%%%%%%%%%%%%%%%
% Exercice 1
% Implement a full wavelet transform that extract iteratively wavelet
% coefficients, by repeating these steps. Take care of choosing the correct
% number of steps.

% fw = f;
% j = log2(n)-1;
% A = fw(1:2^(j+1));
% Coarse = zeros(size(A,1), 4);
% Detail = zeros(size(A,1), 4);
% Coarse(:,1) = A;
% taille = length(A);
% for i=2:4
%     Coarse(1:taille/2,i) = subsampling(cconv(Coarse(1:taille,i-1),h));
%     Detail(1:taille/2,i) = subsampling(cconv(Coarse(1:taille,i-1),g));
%     taille = taille/2;
% end

fw = f;
j = log2(n)-1;
A = fw(1:2^(j+1));

taille = length(A);
steps=3;
for i=1:steps % while taille>0
    fw(taille/2+1:taille) =  subsampling(cconv(A(1:taille),g));
    fw(1:taille/2) = subsampling(cconv(A(1:taille),h));
    A(1:taille/2)=fw(1:taille/2);
    taille = taille/2;
end

taille = length(A);
subplot(steps+2,1,1);
plot(f); axis('tight'); title('Signal'); %,'.-');% axis([s-t s+t 0 1]); title('Signal (zoom)');
for(i=1:steps)
    subplot(steps+2,1,i+1);
    plot(fw(taille/2+1:taille));
    axis('tight');
    title(strcat('Signal filtré haute fréquence niveau',{' '}, num2str(i)));
    taille=taille/2;
end
subplot(steps+2,1,steps+2); 
plot(fw(1:taille)); 
axis('tight');
title(strcat('Signal filtré basse fréquence niveau',{' '}, num2str(steps)));

%%%%%%%%%%%%%%%%%%%%%
% copy past from html

disp(strcat(['Energy of the signal       = ' num2str(norm(f).^2,3)]));
disp(strcat(['Energy of the coefficients = ' num2str(norm(fw).^2,3)]));

clf;
plot_wavelet(fw);
axis([1 n -2 2]);

% f1 = fw;
% j = log2(length(A)) - steps;

% Coarse = f1(1:2^j);
% Detail = f1(2^j+1:2^(j+1));
% 
% Coarse = cconv(upsampling(Coarse,1),reverse(h),1);
% Detail = cconv(upsampling(Detail,1),reverse(g),1);
% 
% f1(1:2^(j+1)) = Coarse + Detail;

%%%%%%%%%%%%%%%%%%%%
% Exercice 2
% Write the inverse wavelet transform that computes f1 from the coefficients fw.

f1 = fw;
j = log2(length(A)) - steps;

subplot(4,1,4);
plot(f1(1:length(A)/(2^steps)));
axis('tight');
for j=(log2(length(A)) - steps):log2(length(A))-1 % while taille>0
    Coarse = f1(1:2^j);
    Detail = f1(2^j+1:2^(j+1));
    Coarse =  cconv(upsampling(Coarse,1),reverse(h),1);
    Detail = cconv(upsampling(Detail,1),reverse(g),1);
    f1(1:2^(j+1)) = Coarse + Detail;
    
%     subplot(4,1,log2(length(A))-j);
%     plot(f1(1:2^(j+1)));
%     axis('tight');
end

disp(strcat((['Error |f-f1|/|f| = ' num2str(norm(f-f1)/norm(f))])));

%%%%%%%%%%%%%%%%%%%%%

% on fait un nb de steps max pour avoir la transformee en ondelette
% en entier dans fw

fw = f;
j = log2(n)-1;
A = fw(1:2^(j+1));
taille = length(A);
j = log2(n);
while j>0%for i=0:log2(n)-1%while taille>=length(g) % for i=1:steps
    j=j-1;
    
    fw(taille/2+1:taille) =  subsampling(cconv(A(1:taille),g));
    fw(1:taille/2) = subsampling(cconv(A(1:taille),h));
    A(1:taille/2)=fw(1:taille/2);
    taille = taille/2;
    steps=steps+1;
end
plot(fw)


%%%%%%%%%%%%%%%%%%%%%
% copy past from html

T = .5;

%Coefficients fw(i) smaller in magnitude than T are set to zero.
fwT = fw .* (abs(fw)>T);

%Display the coefficients before and after thresholding.
clf;
subplot(2,1,1);
plot_wavelet(fw); axis([1 n -2 2]); title('Original coefficients');
subplot(2,1,2);
plot_wavelet(fwT); axis([1 n -2 2]); title('Thresholded coefficients');


%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 3
% Find the threshold T so that the number of remaining coefficients in fwT
% are a fixed number m. Use this threshold to compute fwT and then display 
% the corresponding approximation f1 of f. 
% Try for an increasing number m of coefficients.

L=sort(abs(fw(:)));

proportion_kept=1/8; % test with several values
T=L(length(fw(:))*(1-proportion_kept));
fwT = fw .* (abs(fw)>T);
f1 = fwT;% f1=fw;
for j=0:log2(n)-1 % while taille>0
    Coarse = f1(1:2^j);
    Detail = f1(2^j+1:2^(j+1));
    Coarse =  cconv(upsampling(Coarse,1),reverse(h),1);
    Detail = cconv(upsampling(Detail,1),reverse(g),1);
    f1(1:2^(j+1)) = Coarse + Detail;
end
plot(f1)

%%%%%%%%%%%%%%%%%%%%%%
% Exercice 4 (optionnal)
% Try with Different kind of wavelets, with an increasing number of vanishing moments.


%%%%%%%%%%%%%%%%%%%%%
% Exercice 5 (optionnal)
% Compute wavelets at several positions and scales.


%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 6 (optionnal)
% Display Daubechies wavelets with an
% increasing number of vanishing moments.



