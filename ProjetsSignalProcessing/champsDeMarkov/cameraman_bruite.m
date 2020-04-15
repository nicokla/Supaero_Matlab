function x_bruitee = cameraman_bruite(sigma)

nb_nvg = 256;
x = imread('cameraman.tif');
[nb_lignes,nb_colonnes] = size(x);
x_bruitee = floor(double(x)+sigma*randn(nb_lignes,nb_colonnes));
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		if x_bruitee(i,j)<0
			x_bruitee(i,j) = 0;
		end
		if x_bruitee(i,j)>=nb_nvg
			x_bruitee(i,j) = nb_nvg-1;
		end
	end
end