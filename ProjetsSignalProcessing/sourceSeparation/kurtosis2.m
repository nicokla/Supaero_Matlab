function sortie = kurtosis2( entree )
sortie = (mean(entree.^4)/(mean(entree.^2)^2)) - 3;
end

