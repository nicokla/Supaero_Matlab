%% Image du zebre
name_file='zebre.gif';
image=imread(name_file);
image=double(image)/255;
[nl,nc] = size(image);


%% Clustering sans SVM

imshow(image);
image2=image>0.9 | image<0.3;
figure, imshow(image2)
image3 = imdilate(image2, strel('disk', 1));
figure,imshow(image3);
image4=bwlabel(image3);
imagesc(image4);
image5=image4==4;
imagesc(image5);
image5_1=imdilate(image5, strel('disk', 1));
imagesc(image5_1);
image6=1-image5_1;
imagesc(image6);
image7=bwlabel(image6);
imagesc(image7);
image8=1-(image7==1);
imagesc(image8);
image9=imdilate(image8, strel('disk',1));
imagesc(image9);
image10=imerode(image9, strel('disk',2));
imagesc(image10);
imshow(image10.*image);
figure, imshow((1-image10).*image);
image11=image10;


%% Correction du clustering à la main

figure(1);
imshow(image11.*image);
figure(2);
imshow((1-image11).*image);
figure(1);
while 1 % stopper la boucle infinie avec ctrl/C
    [b1,a1] = ginput(1);
    a1=round(a1);
    b1=round(b1);
    image11(a1-1:a1+1,b1-1:b1+1)=1;
    figure(1);
    imagesc(image11.*image);
    figure(2);
    imagesc((1-image11).*image);
    figure(1);
end

figure(1);
imagesc(image11.*image);
figure(2);
imagesc((1-image11).*image);
while 1  % stopper la boucle infinie avec ctrl/C
    [b1,a1] = ginput(1);
    a1=round(a1);
    b1=round(b1);
    image11(a1-1:a1+1,b1-1:b1+1)=0;
    figure(1);
    imagesc(image11.*image);
    figure(2);
    imagesc((1-image11).*image);
    figure(1);
end

imshow(image11.*image);
figure, imshow((1-image11).*image);

% image11=image>0.8 | image<0.5;
% figure, imshow(image11)