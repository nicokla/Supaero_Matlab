function plotContinuousAngles(canBeLifted, anglesExacts)
caxis([0 (pi*(255/256))]);
colormap(hsv);
% imagesc(anglesExacts, 'alphadata', canBeLifted);%~isnan(X));
imagesc(angle, 'alphadata', machin);%~isnan(X));
set(gca, 'color', 'k')
colorbar
end

