function [ critere ] = crit_J_avecRealisme( p, alpha )
global L C image d;
critere = crit_J(p);
critere = critere + manqueDeRealisme( p(3:end), alpha );
end

