function image=normalizeAfterProjectionFun(image, normalizeAfterProjection)
global good imageInReconstr image0;

if strcmp(normalizeAfterProjection,'max')
    M=max(image(:));
    if(M ~= 0)
        image=image/M;
    end
elseif  strcmp(normalizeAfterProjection,'maxAndMin')
    M=max(image(:));
    m=min(image(:));
    if((M-m) ~= 0)
        image=(image-m)/(M-m);
    end
elseif strcmp(normalizeAfterProjection,'nearestVect')
    % add good et imageOriginale en argument
    goodLogical=logical(good);
    bidule = image(goodLogical).*imageInReconstr(goodLogical);
    coeff1=sum(bidule(:));
    bidule2=image(goodLogical).^2;
    coeff2=sum(bidule2(:));
    if(coeff2~=0)
        image=image*(coeff1/coeff2);
    end
% elseif strcmp(normalizeAfterProjection,'none') 
% --> do nothing in this case
elseif strcmp(normalizeAfterProjection,'nearestVect2')
    %we allow ourselves to use constants (linear regression)
    goodLogical=logical(good);
    
    vecteurImage=image0(goodLogical);
    vecteurNow=image(goodLogical);
    moyImage=mean(vecteurImage);
    moyNow=mean(vecteurNow);
    vecteurImage=vecteurImage-moyImage;
    vecteurNow=vecteurNow-moyNow;
    coeffMult = (vecteurImage' *vecteurNow)/(vecteurNow' *vecteurNow);
    image=coeffMult*(image-moyNow)+moyImage;
    
    image(image>1)=1;
    image(image<0)=0;
    
%     vecteurImage=imageInReconstr(goodLogical);
%     vecteurNow=image(goodLogical);
%     moyImage=mean(vecteurImage);
%     moyNow=mean(vecteurNow);
%     vecteurImage=vecteurImage-moyImage;
%     vecteurNow=vecteurNow-moyNow;
%     coeffMult = (vecteurImage' *vecteurNow)/(vecteurNow' *vecteurNow);
%     image=coeffMult*(image-moyNow)+moyImage;
% 
%     image(image>1)=1;
%     image(image<0)=0;
    
%     minImage=min(image(:));
%     maxImage=max(image(:));
%     image=(image-minImage)/(maxImage-minImage);
end



end

