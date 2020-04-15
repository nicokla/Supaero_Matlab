function [ image, imageGris, good, bad, Mx, My ] = ...
    getImageAndMask2( nameFolder, nameFile, meanSizeSide, colorBad )
% Comme getImageAndMask mais on resize toujours,
% meme si ça fait grossir l'image.

fprintf('Load image and mask\n')
if(nameFolder(end)~='/')
    nameFolder=[nameFolder '/'];
end
image_old=imread([nameFolder  nameFile]);
image_old=double(image_old)/255;


if nargin <= 3
    [r,g,b]=deal(0,1,0); % green
else
    colorBadCell = num2cell(colorBad);
    [r,g,b]=deal(colorBadCell{:});
end
bad_old=(image_old(:,:,1)==r) & ...
    (image_old(:,:,2)==g) & ...
    (image_old(:,:,3)==b);
good_old=1-double(bad_old);
image_old = multiplie2Det3D(good_old , image_old);


[Mx_old,My_old,Mz_old]=size(image_old);
M=sqrt(Mx_old*My_old);
fprintf('Original size is %d by %d, mean size is %f.\n',Mx_old, My_old, M);
fprintf('Original number of pixels is %d.\n',Mx_old*My_old);

if nargin <= 2
    image = image_old;
    bad = bad_old;
else
    facteur=meanSizeSide/M
%     if(facteur<1)
        image = imresize(image_old, facteur);
        bad = imresize(bad_old, facteur);
        fprintf('Resized with a factor of %f.\n',facteur);
        [Mx,My,~]=size(image);
        fprintf('Number of pixels is now %d.\n',Mx*My);
        fprintf('Now size is %d by %d, mean size is %f.\n', Mx, My, meanSizeSide);
%     else
%         fprintf('The image is not resized.');
%         image = image_old;
%         bad = bad_old;
%     end
end

% bad = imdilate(bad,ones(3)); 
bad = dilatePerso(bad,ones(3));
good=double(1-bad);
if(size(image,3)==3)
    imageGris=rgb2gray(image);
elseif (size(image,3)==1)
    imageGris=image;
else
    imageGris=sum(image,3);
end
imageGris = multiplie2Det3D(good, imageGris);
image = multiplie2Det3D(good, image);

[Mx,My]=size(bad);

figure;
subplot(1,2,1), imshow(image);
subplot(1,2,2), imshow(bad);
end

