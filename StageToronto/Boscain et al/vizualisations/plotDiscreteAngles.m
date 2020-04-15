function plotDiscreteAngles(anglesApprox, canBeLifted)
global thetaNumber;
imagesc(anglesApprox.*canBeLifted);%drawnow;
caxis([-0.5, thetaNumber+0.5]);
colormap([0,0,0; hsv(thetaNumber)]); 
colorbar;
drawnow;

% caxis([1 thetaNumber]);
% colormap(hsv);
% % % anglesApprox(canBeLifted)=NaN;
% imagesc(anglesApprox, 'alphadata', canBeLifted | ~isnan(anglesApprox));%);
% set(gca, 'color', 'k');
% colorbar