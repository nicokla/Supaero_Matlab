function [ critere ] = crit_J( p )
global L C image d;
% p = s I0 l0 c0 sigma_l sigma_c alpha n
image_estim=imageEstimDeP( p );
% ecart quadratique relatif
critere = (mean((d(:) - image_estim(:)).^2) / mean((d(:).^2)));%10*log10
end

