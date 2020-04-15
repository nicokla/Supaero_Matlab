function drawRectangle(centreX,centreY,semiSize,couleur,thickness)
% couleur triplet de nombres (rgb) avec max convention = 1 au lieu de 255.
    x1=centreX-semiSize;
    x2=centreX+semiSize;
    y1=centreY-semiSize;
    y2=centreY+semiSize;
    hold on;
	plot([x1,x1],[y1,y2],'Color',couleur,'Linewidth',thickness);
	plot([x1,x2],[y2,y2],'Color',couleur,'Linewidth',thickness);
	plot([x2,x2],[y2,y1],'Color',couleur,'Linewidth',thickness);
	plot([x2,x1],[y1,y1],'Color',couleur,'Linewidth',thickness);
    drawnow;
end