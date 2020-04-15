
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dégradé

% m=zeros(256);%,'int8');
% for(i=0:255)
%     m(:,i+1)=i/255;
% end
% m(:,128-20:128+20)=0.5;
% figure, imshow(m);


i = uint8(0);
m=zeros(256,'uint8');
for i=0:255
    m(:,i+1)=i;
end
m(:,128-30:128+30)=127;
figure, imshow(m);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RGB

% champs=imread('champs.bmp');
% figure, imshow(champs);

% champsGray = rgb2gray(champs);
% figure, imshow(champsGray);

image=imread('cargo.jpg');
image=imread('Teinte.jpg');
image=imread('oeil.jpg');
image=imread('CoulAdd.jpg');
subplot(2,2,1);
imshow(image);
subplot(2,2,2);
imshow(image(:,:,1));
subplot(2,2,3);
imshow(image(:,:,2));
subplot(2,2,4);
imshow(image(:,:,3));
% Cargo : le ciel est bleu donc la 3eme image a un ciel plus blanc (pixels plus proche de
% 255)
% teinte : logique
% oeil : rayon jaune (-> vert et rouge), fond rouge.
% rayons de lumiere colorée : additif comme les pixels





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HSV

m=zeros(200,300,3,'uint8');
m(:,1:100,1)=255;
m(:,101:200,:)=255;
m(:,201:300,3)=255;
m_hsv = rgb2hsv(m);
france_gris=rgb2gray(m);
subplot(2,2,1);
imshow(m);
subplot(2,2,2);
imshow(m_hsv(:,:,1));
subplot(2,2,3);
imshow(m_hsv(:,:,2));
subplot(2,2,4);
% figure,imshow(m_hsv(:,:,3));
imshow(france_gris);

% figure,imshow(m_hsv(:,:,3));
% --> value n'est pas la luminosité car tout est à 1, alors que rouge et 
% bleu dont moins lumineux que le blanc

% la teinte est 

% autre aspect interessant : le blanc est considéré comme rouge (hue(blanc) = 0)

% coefficients pour le gris : 
% dans rgb2gray.m, 
% T = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
% coef = T(1,:);
% donne 0.2989    0.5870    0.1140

m = ones(256,256,3);
for i=1:256
    for j=1:256
        m(i,j,1)=(i-1)/255; % hue
        m(i,j,2)=(j-1)/255; % saturation
        m(i,j,3)=0.5; % value
    end
end
m_rgb=hsv2rgb(m);
imshow(m_rgb);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HSV et zones de la plage

image=imread('SpainBeach.png');
image_hsv=rgb2hsv(image);
%imshow(image);
%figure('name', 'image'), imshow(image);
%figure('name', 'rouge'), imshow(image(:,:,1));
%figure('name', 'green'),imshow(image(:,:,2));
%figure('name', 'blue'),imshow(image(:,:,3));
hue = image_hsv(:,:,1);
sat = image_hsv(:,:,2);
val = image_hsv(:,:,3);
intensite = rgb2gray(image);
% figure('name', 'hue'), imshow(hue);
% figure('name', 'saturation'),imshow(sat);
% figure('name', 'value'),imshow(val);
subplot(2,2,1), imshow(image);
subplot(2,2,2), imshow(hue);
subplot(2,2,3), imshow(sat);
subplot(2,2,4), imshow(intensite);
%subplot(2,2,4), imshow(val);

subplot(3,1,1), plot(imhist(sat));
subplot(3,1,2), plot(imhist(hue));
subplot(3,1,3), plot(imhist(intensite));

mer =(hue>130/255& hue<150/255&sat>130/355); % la mer, faible luminosite, haute saturation
mer = mer | (intensite > uint8(175)&sat<55/255) ;
mer=double(mer);
X= sqrt(hann(60)*hann(60)');
mer=imfilter(mer,X, 'conv');
se=strel('disk',30);
mer=imopen(mer,se);
se=strel('disk',50);
mer=imclose(mer,se);
mer=uint8(mer>400);
merVraie=multRgb( image, mer );
merVraieOpposee=multRgb( image, 1-mer );
subplot(1,2,1), imshow(merVraie); % la mer, grosse saturation
subplot(1,2,2), imshow(merVraieOpposee); %

plage=uint8(hue>0.03 & hue < 0.07);
plage=imopen(plage,strel('disk',4));
plage=imclose(plage,strel('disk',8));
plageVraie=multRgb( image, plage );
plageVraieOpposee=multRgb( image, 1-plage );
subplot(1,2,1), imshow(plageVraie); % la mer, grosse saturation
subplot(1,2,2), imshow(plageVraieOpposee); %

%terre=%uint8( hue>20/255 & hue<130/255);
terre =1-(mer | plage);
terre=imclose(terre, strel('disk', 10));
terre=uint8(terre);
terreVraie=multRgb( image, terre );
terreVraieOpposee=multRgb( image,1-terre);
subplot(1,2,1), imshow(terreVraie); 
subplot(1,2,2), imshow(terreVraieOpposee); 
% la terre a une faible saturation et une intensite moins grande que les
% vagues
imagesc(terre);


close all;
subplot(2,2,1); imshow(image);
subplot(2,2,2); imshow(merVraie);
subplot(2,2,3), imshow(plageVraie);
subplot(2,2,4), imshow(terreVraie);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Histogrammes et contraste

cargo=imread('cargo.jpg');
cargoGray=rgb2gray(cargo);
toulouseGray=imread('toulouse.bmp');

subplot(2,1,1), imshow(toulouseGray);
subplot(2,1,2), plot(imhist(toulouseGray));
% les pixels ne peuvent prendre qu'une trentaine de valeurs reparties non
% lineairement de 0 à 255

subplot(2,1,1), imshow(cargoGray);
subplot(2,1,2), plot(imhist(cargoGray));
% valeurs reparties continuement de 0 à 1, contrairement à l'image de Toulouse.
% un pic à blanc (blanc de la coque) et un à noir (ombre bateau)
% pas mal de pixels entre 120 et 200 (luminosité moyenne à haute).

cargoGrayEqualized=histeq(cargoGray);
subplot(1,2,1),imshow(cargoGray);
subplot(1,2,2), imshow(cargoGrayEqualized);
figure;
subplot(2,1,1), plot(imhist(cargoGray));
subplot(2,1,2), plot(imhist(cargoGrayEqualized));
% histogramme réparti sur toute la gamme des luminosités (mais environ un quart des
% 255 valeurs sont prises seulement, on voit ainsi des pics. Mais ceux-ci ont 
% même amplitude et sont répartis tout au long de [0;255] )
% on a augment� le contraste avec histeq

mystere1 = imread('imagex.bmp');
subplot(1,2,1),imshow((mystere1));
subplot(1,2,2), imshow(histeq(mystere1)); % Toulouse

mystere2 = imread('imagexx.bmp');
subplot(1,2,1),imshow(myst2Gray);
subplot(1,2,2), imshow(histeq(myst2Gray)); % la Terre




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contours du cargo

cargo=imread('cargo.jpg');
cargoGray=rgb2gray(cargo);
cargoDouble=double(cargoGray)/255;

derivVert=conv2([-1 1],ones(2));%[-1 1];
derivHor = derivVert';

derivVertCargo = imfilter(cargoDouble,derivVert,'conv');
%imshow(derivVertCargo);
derivHorCargo = imfilter(cargoDouble,derivHor,'conv');
%imshow(derivVertCargo);

derivAbsCargo = sqrt(derivHorCargo.^2 + derivVertCargo.^2);
derivAbsCargo=derivAbsCargo/max(max(derivAbsCargo));
imshow(derivAbsCargo);

h=imhist(derivAbsCargo);
plot(h);
imshow(derivAbsCargo>50/255);
%figure,imshow(cargo);

I = cargoGray;
BW1 = edge(I);%,'prewitt');
%BW2 = edge(I,'canny');
imshow(BW1);

X=fspecial('laplacian');
aa=imfilter( cargoGray,X,'conv');
aa=aa/mean(aa(:));
%imhist(aa);
imshow(aa>5);% imagesc(aa);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Etoiles

etoilesColor = imread('Etoiles.png');
etoilesUint8=rgb2gray(etoilesColor);
etoiles=double(etoilesUint8)/255;
imshow(etoiles);

etoilesDetect=double(etoiles>0.5);%.* etoiles$
subplot(1,2,1), imshow(etoilesDetect.*etoiles);
subplot(1,2,2), imshow((1-etoilesDetect).*etoiles);

CC = bwconncomp(etoilesDetect);
L = labelmatrix(CC);
S = regionprops(L,'Centroid');
S(5).Centroid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
% Palm tree, le temps passe

v=[1 2 3 4 5 6 7 8 9 10 11 12 17];
p=imread('palm-tree-island-01.png');
palmTrees=zeros(size(p,1),size(p,2),3,length(v),'uint8');
palmTreesGray=zeros(size(p,1),size(p,2),length(v),'uint8');
palmTreesGrayFlous=zeros(size(p,1),size(p,2),length(v),'uint8');

for i = 1:length(v)
    palmTrees(:,:,:,i) = imread(strcat('palm-tree-island-',num2str(v(i),'%02u'),'.png'));
end

for i = 1:length(v)
    palmTreesGray(:,:,i) = rgb2gray(palmTrees(:,:,:,i));
end

X=fspecial('gaussian',10,3);
for i = 1:length(v)
    palmTreesGrayFlous(:,:,i) = imfilter(palmTreesGray(:,:,i)...
                            ,X...
                            ,'conv');
end


for i = 1:length(v)
    imshow(palmTrees(:,:,:,i));
    pause;
end

for i =  2:length(v)
    subplot(2,2,1), imshow(palmTreesGray(:,:,i-1));
    subplot(2,2,2),imshow(palmTreesGray(:,:,i));
    subplot(2,2,3),imshow(palmTreesGrayFlous(:,:,i)-palmTreesGrayFlous(:,:,i-1));
    pause;
end




