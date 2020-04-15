function imagesc2(image, option, figureOrNot, mini0, maxi0)
% varargout{1:nargout}
% varargin, nargin

% if(size(image,3)>1)
%     image=rgb2gray(image);
% end
if (nargin <= 2) || figureOrNot 
    figure;
end

if(nargin == 1)
    option=0;
end

if(option==0)
    txt='jet';
elseif(option==1)
    txt='hot';
elseif(option==2)
    txt='hsv';
elseif(option==3)
    txt='parula';
elseif(option==4)
    txt='gray';
elseif(option==5)
    txt='lines';
elseif(option==6)
    txt='colorcube';
elseif(option==7)
    if (nargin <= 3) 
        mini=min(min(min(image)));
        maxi=max(max(max(image)));
    else
        mini=mini0;
        maxi=maxi0;
    end
    total=maxi-mini;
    if (mini < 0) && (maxi > 0)
        totalCouleur = 256;
        totalCouleurNegative = round((totalCouleur-1)*(mini/total));
        totalCouleurPositive = totalCouleurNegative+(totalCouleur-1);
        maxAbs=max(abs(totalCouleurNegative),abs(totalCouleurPositive));
        txt=[];
        for i=totalCouleurNegative:0
            b=abs(i/maxAbs);
            txt = [txt; 0 0 b];
        end
        for i=1:totalCouleurPositive
            r=i/maxAbs;
            txt = [txt; r 0 0];
        end
    else
        txt='jet';
    end
end

imagesc(image);
axis off;
colormap(txt);
Mz=size(image,3);
if(Mz==1)
    colorbar;
end
axis tight equal;
if(option==7)
    caxis([mini maxi]);
end

drawnow;


end

