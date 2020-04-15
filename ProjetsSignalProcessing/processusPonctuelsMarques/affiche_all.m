function affiche_all( I,abscisses_centres_disques,ordonnees_centres_disques, R )
global theta;
global rose;
hold off;
imagesc(I);
axis('image');
colormap(gray(256));
hx = xlabel('$x$','FontSize',20);
set(hx,'Interpreter','Latex');
hy = ylabel('$y$','FontSize',20);
set(hy,'Interpreter','Latex');
hold on;
N=length(abscisses_centres_disques);
for k = 1:N
    abscisses_cercle = abscisses_centres_disques(k)+R*cos(theta);
    ordonnees_cercle = ordonnees_centres_disques(k)+R*sin(theta);
    plot(abscisses_cercle,ordonnees_cercle,'Color',rose,'LineWidth',2);
end
end

