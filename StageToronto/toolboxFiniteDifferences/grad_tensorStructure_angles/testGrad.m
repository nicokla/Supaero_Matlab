


includeEverything();
[image, imageGris, good, bad, Mx, My]=loadExampleImage('forest.png');


[dx, dy] = grad_sobel(imageGris);
imagesc2(dx);


test1=ones(20,1)*(1:20);
[dx, dy] = grad_sobel(test1);
imagesc2(dx);
imagesc2(dy);

[ norme, angle ] = getAbsAndAngleOfDxDy( dx, dy );
imshow2(norme);
imagesc2(angle,2);





