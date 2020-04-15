function [result] = blur2( f, h, optionForEdges)
% juste un alias en fait, pas vraiment utile
result = convUsingCconv(f,h,optionForEdges);

