function [ x, y ] = inputCoordAndShow( semiSize, couleur, thickness )
    [x,y]=ginput(1);
    x=round(x); y=round(y);
    drawRectangle(x, y, semiSize, couleur, thickness);
end

