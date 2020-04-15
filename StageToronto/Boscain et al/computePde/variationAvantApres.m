function variation = variationAvantApres( image3dAvant, image3dApres )
% Also works for 2d matrices, because for x an integer,
% mean(x)==sum(x)==x.
% We could add as an option which p-norm we want to use 
% (here we use the norme 1)
% We could also use mean instead of sum 
variation=mean(mean(mean(abs(image3dApres-image3dAvant))));
end

