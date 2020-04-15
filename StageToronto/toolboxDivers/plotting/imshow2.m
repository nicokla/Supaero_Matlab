function imshow2(image) %, figureOrNot 
% Don't require the image to be between 0 and 1 (or 0 and 255 for uint8)
% Also, call figure by default
% if figureOrNot % || (nargin == 1) 
%     figure;
% end
imagesc(image);
colormap gray;
axis off;
axis tight;
axis equal;
colorbar;
drawnow;

end

