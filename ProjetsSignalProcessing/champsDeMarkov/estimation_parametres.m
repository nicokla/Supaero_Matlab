function moyennes_variances = estimation_parametres(x,nb_classes,couleurs)

[nb_lignes,nb_colonnes] = size(x);
moyennes_variances = [];
for k = 1:nb_classes
	[x1,y1] = ginput(1);
	while (x1<1)||(x1>nb_colonnes)||(y1<1)||(y1>nb_lignes)
		[x1,y1] = ginput(1);
	end
	[x2,y2] = ginput(1);
	while (x2<1)||(x2>nb_colonnes)||(y2<1)||(y2>nb_lignes)||(x2==x1)||(y2==y1)
		[x2,y2] = ginput(1);
	end
	plot([x1,x1],[y1,y2],'Color',couleurs(k,:),'Linewidth',2);
	plot([x1,x2],[y2,y2],'Color',couleurs(k,:),'Linewidth',2);
	plot([x2,x2],[y2,y1],'Color',couleurs(k,:),'Linewidth',2);
	plot([x2,x1],[y1,y1],'Color',couleurs(k,:),'Linewidth',2);

	echantillons = [];
	for i = floor(min([y1,y2])):ceil(max([y1,y2]))
		for j = floor(min([x1,x2])):ceil(max([x1,x2]))
			echantillons = [echantillons, x(i,j)];
		end
	end
	echantillons = double(echantillons);
	[mu,Sigma] = estimation_mu_Sigma(echantillons);
	moyennes_variances = [moyennes_variances ; mu Sigma];
end
