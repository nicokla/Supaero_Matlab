function image = projectBack( image3d, optionProjection )

type=optionProjection.type;
normalizeAfterProjection=optionProjection.normalizeAfterProjection;
if(strcmp(type,'normeP') ||...
    strcmp(type,'normePFromTheMean'))
    p=optionProjection.p;
end

[u,v,w]=size(image3d);
image=zeros(u,v);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(type,'max')
    image = max(image3d,[],3);
elseif strcmp(type,'sum')
    image = sum(image3d,3);
elseif strcmp(type, 'mean')
    image=mean(image3d,3);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(type,'minPlusMax')
    image = (min(image3d,[],3) + max(image3d,[],3))/2;
elseif strcmp(type,'min')
    image = min(image3d,[],3);
elseif strcmp(type,'maxFromGray')
    image3d = image3d-255/2;
    [M,I]=max(abs(image3d),[],3); 
    for i=1:size(image3d,1)
        for j=1:size(image3d,2)
            image(i,j) = image3d(i,j,I(i,j));
        end
    end
    image=255/2+image;
elseif strcmp(type,'maxFromMean')
    moyenne=mean(image3d,3);
    image3d = image3d-repmat(moyenne,[1 1 size(image3d,3)]);
    [M,I]=max(abs(image3d),[],3); 
    for i=1:size(image3d,1)
        for j=1:size(image3d,2)
            image(i,j) = image3d(i,j,I(i,j));
        end
    end
    image=moyenne+image;
elseif strcmp(type,'norme2')
    image=sqrt(mean(image3d.^2,3));
elseif strcmp(type,'normeP')
    image=(mean(abs(image3d).^p,3)).^(1/p);

elseif strcmp(type,'localExtremas')
% good but very slow 
    fprintf('Starting to compute local extrema projection\n');
    [Mx,My,Mz]=size(image3d);

%     f=@(n) mod(n,Mz);
    for i=1:Mx
        for j=1:My
            image(i,j)=projectionLocalExtremas(image3d(i,j,:));
        end
    end
    fprintf('Finishing to compute local extrema projection\n');

elseif strcmp(type,'projectForRealisticGrad2')
    % farthest from the mean
    imageMoyenne = mean(image3d,3);
    petit = min(image3d,[],3);
    grand = max(image3d,[],3);
    p1 = imageMoyenne - petit;
    p2 = grand - imageMoyenne;
    zonePetit = p1>p2;
    image(zonePetit) = petit(zonePetit);
    image(~zonePetit) = grand(~zonePetit);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% norme p apres avoir enleve la moyenne (equivalent d'ecart type)
elseif strcmp(type,'normePFromTheMean')
    moyenne=mean(image3d,3);
    image3d = image3d-repmat(moyenne,[1 1 size(image3d,3)]);
    image=(mean(abs(image3d).^p,3)).^(1/p);

% norme infinie apres avoir enlevé la moyenne
elseif strcmp(type,'normeInfinieFromTheMean')
    moyenne=mean(image3d,3);
    image3d = image3d-repmat(moyenne,[1 1 size(image3d,3)]);
    image=max(abs(image3d),[],3); 
    image(image<1e-12)=0;
% moyennes des maximas locaux (detectes apres smoothing)
% Todo
end

if ~strcmp(normalizeAfterProjection,'none')
    image=normalizeAfterProjectionFun(...
        image,normalizeAfterProjection);
end

end

