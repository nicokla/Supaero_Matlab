function [ critere ] = crit_K_avecRealisme( nu, alpha )
global L C image d;
critere=crit_K(nu);
critere = critere + manqueDeRealisme( nu, alpha );
end

