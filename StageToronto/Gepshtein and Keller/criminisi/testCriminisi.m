
clear

nameFolder='../../Gepshtein and Keller - Images/';
nameFile='rice.bmp';
% nameFolder='../../Criminisi - Images/';
% nameFile='image8_4.png';
[ image, imageGris, good, ~, ~, ~ ] = ...
getImageAndMask( nameFolder, nameFile, 400 ); % meanSizeSide
image0=image;
good0=good;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
semiSize=9;
semiSize2=semiSize;%round(semiSize/2);
display=1;
N=20;

%% First initialize the image !
image=image0;
good=good0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Choose one of the version of Criminisi to do a test :

image = criminisiInpainting_specialRGB(image, good, 5, 1);
image = criminisiInpainting_absOfSum(image, good, 6, 1);
image = criminisiInpainting_eachComponentSeparately(image, good, 8, 1);
image = criminisiInpainting_sumOfAbs(image, good, 9, 1);
image = ...
	criminisiInpainting_sumOfAbs_almostNoriega...
	(image, good, semiSize,...
	 semiSize2, display, N);

image = criminisiInpainting_absOfSum(image(:,:,1), good, semiSize);
image = criminisiInpainting_specialMono(image(:,:,1), good, 4);






