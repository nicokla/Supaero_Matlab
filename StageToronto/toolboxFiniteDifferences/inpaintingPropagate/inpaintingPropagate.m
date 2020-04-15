function [ image ] = inpaintingPropagate( image, good, nbstepsMax )
masqueTemp=good;
h=ones(3);
[Mx,My,~]=size(image);
k=0;
while ~(sum(masqueTemp(:)) == Mx*My) %for i=1:4
    masque2=imfilter(masqueTemp,h,'conv');
    masque2(logical(masqueTemp))=0;
    % masque2 vaut maintenant la frontiere exterieure de
    % masqueTemp mais avec des coeff qui 
    % sont le nombre de voisins
    masque3=masque2>0;
    image2=imfilter(image,h,'conv');
    image(masque3)=image2(masque3)./masque2(masque3);
    masqueTemp=masqueTemp+double(masque3);
    k=k+1;
    if(k>nbstepsMax)
        break;
    end
    %imshow(image); pause;
end

