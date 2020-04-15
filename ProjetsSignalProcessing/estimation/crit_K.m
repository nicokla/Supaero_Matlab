function [ critere ] = crit_K( nu)
% p = s I0 l0 c0 sigma_l sigma_c alpha n
global L C image d;
[image_estime, p] = imageEstimeDeNu(nu);
critere = mean((d(:) - image_estime(:)).^2) / mean((d(:).^2));
end

