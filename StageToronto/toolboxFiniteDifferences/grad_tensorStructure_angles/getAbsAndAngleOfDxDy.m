function [ norme, angle ] = getAbsAndAngleOfDxDy( dx, dy )
norme=sqrt(dx.^2+dy.^2);
angle=acos(dx./norme);
end

