
%% base
image = imread('champs.png');
imshow(image);
image_gray = double(rgb2gray(image))/255;
fourier = fftshift(fft2(image_gray));
imagesc(log(abs(fourier)));

%% milieu
taille=40;
masque = ones(size(fourier));
milieu = floor(size(masque,1)/2);
masque(milieu-taille:milieu+taille,milieu-taille:milieu+taille)=0; 
fourier = fourier.*masque;
imagesc(abs(fourier))

%% diagonale
vect = [452 407] - [62 106];
vect = vect/norm(vect);
vect = reverse(vect);
taille2=3;
masque2=zeros(size(fourier));
for i=1:size(masque2,1)
    for j=1:size(masque2,2)
        a=i-257;
        b=j-257;
        l = [a b] * vect';
        d = norm([a b] - (l * vect));
        if(d <= taille2)
           masque2(i,j)=1;
        end
    end
end
imshow(masque2);
imagesc(abs(fourier).*masque2);
fourier = fourier.*masque2;
imshow(abs(ifft2(ifftshift(fourier))));

%% pics
pic=zeros(4,2);
pic(1,:)=[106 61];
pic(2,:)=[ 181 159]; 
pic(3,:)=[ 334 355 ];
pic(4,:)=[ 408  452];
reverse(pic);
masque3=zeros(size(fourier));
largeur=8;
for i=1:4
    masque3(pic(i,1)-largeur:pic(i,1)+largeur,pic(i,2)-largeur:pic(i,2)+largeur)=1;
end
imshow(masque3);
fourier = fourier.*masque3;
imagesc(abs(fourier));

%% reconstruction
image_reconstruite = abs(ifft2(ifftshift(fourier)));
imagesc(image_reconstruite);
figure, imshow(image_reconstruite/max(max(image_reconstruite)));
%mat1=ifft2(ifftshift(fourier));

%% selection champ (bruitage-seuillage)
a =  sqrt(hann(5) * hann(5)');
b=sum(sum(a));
a=a/b;
image_reconstruite_bruitee = imfilter(image_reconstruite,a,'conv');%conv2();
figure,imagesc(image_reconstruite_bruitee );
imhist(image_reconstruite_bruitee);
champ = image_reconstruite_bruitee>0.02;
image_champ = image_gray .* champ;
imshow(image_champ);



