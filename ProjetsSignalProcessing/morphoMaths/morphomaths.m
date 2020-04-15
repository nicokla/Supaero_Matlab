%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% examples

I = imread('cameraman.tif');
imshow(I);%, title('Original')

se = strel('ball',5,5);
I2 = imerode(I,se);
figure, imshow(I2)%, title('Dilated')

%%%%%%%%%%%%%%%%%%%%%%%%%
%% detecteur de contour
europe=imread('EuropeBW.bmp');
europe = ~europe;
imshow(europe);

se = strel('disk',1);
imshow(europe-imerode(europe,se));
%imshow(imdilate(europe,se)-europe);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% combien de globules ?

bloodBW_rgb = imread('bloodBW.png');
bloodBW = rgb2gray(bloodBW_rgb);
bloodBW=255-bloodBW;
bloodBW=bloodBW>127;
subplot(1,2,1) , imshow(bloodBW);

se = strel('disk',15);
bloodBW_erode = imerode(bloodBW,se);
subplot(1,2,2) , imshow(bloodBW_erode);
compConn = bwconncomp(bloodBW_erode);
compConn.NumObjects


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% distance max entre les points en Europe

europe=imread('EuropeBW.bmp');
europe = ~europe;
imshow(europe);

europe2=europe;
m3=zeros(size(m2));
i=0;
while (~isempty(find(europe2, 1)))
    i=i+1;
    se = strel('disk',i);
    europe2 = imerode(europe,se);
    m3(europe2)=i;
    %imshow(europe2);
    %pause;
end
imagesc(m3);
% %95


m2=europe;
m3=zeros(size(m2));
while(length(find(m2)) > 0)
    m3=m3+m2;
    m2=imerode(m2,strel('disk',1));
end
imagesc(m3);
% 113

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% tests d'imopen et imclose
% se = strel('disk',10);
% imshow(europe);
% m3=europe;
% for i=1:2:10
%     se = strel('disk',i);
%     europe = imclose(europe,se);
%     m3=m3+europe;
% end
% imagesc(m3);
% close enleve les petites taches sombres
% open enleve les petites taches claires

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% deux close successifs, deux open successifs

% se = strel('disk',10);
% europe2=imclose(europe,se);
% imshow(europe2);
% pause;
% europe2=imclose(europe2,se);
% imshow(europe2);
%-> c'est bien pareil

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% debruitage d'un degradé

m = zeros(256,'uint8');
for i = 1:256
    m(i,:)=i-1;
end
imshow(m)
m=double(m)/255;
%sigma = .08; % noise level
%m2 = m + sigma*randn(size(m));
m2 = imnoise(m,'salt & pepper',0.1);
imshow(m2);

se = strel('disk',2);
se2 = strel('disk',4);
m3=imopen(imclose(m2,se),se2);
%imshow(imclose(m2,se));
imshow(m3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ï¿½toiles les plus lumineuses

pleiades = imread('pleiades.bmp');
pleiades = rgb2gray(pleiades);
imshow(pleiades);
se = strel('disk',2);
se2 = strel('disk',4);
pleiades2 = imopen(pleiades,strel('disk',8));
imshow(pleiades2);
pleiades3 = imclose(pleiades2,strel('disk',30));
imshow(pleiades3);
imshow(pleiades3>=220);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% detection de maximas locaux
% deux parametres: rayon de l'elem structurant (taille de l'etoile detectï¿½e <= rayon)
% threshold (luminosite de l'etoile)
rayon=30;
pleiadesOpen = imopen(pleiades,strel('disk',rayon));
pleiades4 = pleiades-pleiadesOpen ;
subplot(2,2,1) , imshow(pleiades);%pleiades4)
subplot(2,2,2) , imshow(pleiadesOpen);%pleiades4)
subplot(2,2,3) , imshow(pleiades4);

imhist(pleiades4)
threshold=60;

newImage=pleiades;
newImage(pleiades4<threshold)=0;
imshow(newImage);

newImage2=pleiades;
newImage2(pleiades4>=threshold)=0;
imshow(newImage2)

% pleiades.*double(pleiades4>=threshold));
% figure, imshow(pleiades4>=threshold);


%% examples bsconncomp
m = imread('Images3.jpg');
m=m<100;
imshow(m);

% enlever le plus grand
CC = bwconncomp(m);
numPixels = cellfun(@numel,CC.PixelIdxList);
% mm=cell2mat(CC.PixelIdxList(1));
%S = reshape(S, 3, 8);
[biggest,idx] = max(numPixels);
m(CC.PixelIdxList{idx}) = 0;
figure, imshow(m);

% centroids
CC = bwconncomp(m);
L = labelmatrix(CC);
S = regionprops(L,'Centroid');
S.Centroid;

% S = regionprops(L ou CC, name_property)
% L = labelmatrix(CC); % with CC = bwconncomp(m);
%[L, num] = bwlabel(BW); % (BW, n) % n=4 or 8, default 8
%[L, NUM] = bwlabeln(BW) % only useful for 3D matrices, else use bwlabel
% RGB = label2rgb(L);
% RGB2 = label2rgb(L, 'spring', 'c', 'shuffle'); 
% [r, c] = find(L==2); rc = [r c]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% reconnaissance d'objets

m = imread('Images2.jpg');%('Images3.jpg');
m=m<100;
imshow(m);

se_disk=strel('disk',6);
% nhood_disk= m(120:200,100:175);
% se_disk2 =  strel('arbitrary', nhood_disk);
% nhood_disk2= imerode(nhood_disk,strel('disk',2));
% se_disk3 =  strel('arbitrary', nhood_disk2);

se_diamond=strel('diamond',6);
% nhood_diamond = m(120:200,546 : 630);
% se_diamond2 =  strel('arbitrary', nhood_diamond);
% nhood_diamond2 = imerode(nhood_diamond,strel('disk',2));
% se_diamond3 =  strel('arbitrary', nhood_diamond2);

se_rectangle=strel('rectangle',[3 5]);
% nhood_rectangle = m(120:200,319 : 400);
% se_rectangle2 =  strel('arbitrary', nhood_rectangle);
% nhood_rectangle2 = imerode(nhood_rectangle,strel('disk',2));
% se_rectangle3 =  strel('arbitrary', nhood_rectangle2);

se_octagon=strel('octagon',6);
% nhood_octagon = m(120:200,208:290);
% se_octagon2 = strel('arbitrary', nhood_octagon);
% nhood_octagon2 = imerode(nhood_octagon,strel('disk',2));
% se_octagon3 = strel('arbitrary', nhood_octagon2);

nhood_ellipse = m(120:200,434:535);
%se_ellipse2 = strel('arbitrary', nhood_ellipse);
nhood_ellipse2 =imerode(nhood_ellipse,strel('disk',3));
imshow(nhood_ellipse2);
se_ellipse = strel('arbitrary', nhood_ellipse2);



% m = imread('Images3.jpg');
% m=m<100;
% imshow(m);

%compConn = bwconncomp(m);
%compConnVolumes=compConn.PixelIdxList;

se = se_diamond;%diamond rectangle disk octagon ellipse
%imshow(getnhood(se));

m2=m;
%m2=imopen(m,se);%erode open  
[L0, num0] = bwlabel(m);
m2=imerode(m,se);
[L, num] = bwlabel(m2);
points = zeros(num,2);
for i=1:num
    [points(i,1),points(i,2)] = find(L==i,1);
end
m2=imdilate(m2,se);
[L2, num2] = bwlabel(m2);
vol_ancien = zeros(1,num);
vol_new = zeros(1,num);
for i=1:num
    vol_ancien(i)=sum(sum(L0==L0(points(i,1),points(i,2))));
    vol_new(i)=sum(sum(L2==L2(points(i,1),points(i,2))));
end
rapports = vol_ancien./vol_new;

% imshow(m2);
m_dessin=zeros(size(m2),'uint8');
m_dessin(m)=255;
m_dessin(m2)=100;
imshow(m_dessin);

compConn2 = bwconncomp(m2);
nombre = compConn2.NumObjects;
compConnVolumes2=compConn2.PixelIdxList;

rayon = 8;

%a= strel('ball', 4, 10, 0);
%b=getnhood(a);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% squelettisation
m = imread('Diplo1.gif');
m=m>=1;
imshow(m);

m2=m;
m3=zeros(size(m2));
while(length(find(m2)) > 0)
    m3=m3+m2;
    m2=imerode(m2,strel('disk',1));
end
imagesc(m3);
X=fspecial('laplacian');
m4=imfilter(m3,X,'conv');
imagesc(m4);

imagesc(m3-imopen(m3,strel('disk', 1)));

I = m;
I_eps=false(size(I));
I_w=false(size(I));
I_sq=false(size(I));
se = strel('disk',1);
while ~isempty(find(I, 1))
    I_eps = imerode(I,se);
    I_w = imdilate(I_eps,se);
    I_sq = I_sq + I - I_w;
    I=I_eps;
end
I_sq=I_sq>0.5;
imshow(I_sq);
imshow(m & ~I_sq);

m_color=zeros(size(m,1),size(m,2),3,'uint8');
m_color(:,:,2)=255*(m & ~I_sq);
m_color(:,:,1)=255*I_sq;
imshow(m_color);
















