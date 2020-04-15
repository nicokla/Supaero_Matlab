function plotDiscreteAngles2(canBeLifted, anglesApprox,...
     anisotropy, normeOfGrad)
 
global thetaNumber;

%%
ax1=subplot(2,2,1);
imagesc(canBeLifted.*anglesApprox);%drawnow;
caxis([-0.5, thetaNumber+0.5]);
colormap(ax1,[0,0,0; hsv(thetaNumber)]); 
colorbar(ax1);
axis off %equal tigh;
% freezeColors
% cbfreeze(colorbar)

%%
ax2=subplot(2,2,2);
imagesc(anisotropy);
colormap(ax2,hot);
colorbar(ax2);
axis off %equal tigh;
% freezeColors
% cbfreeze(colorbar)

%%
ax3=subplot(2,2,3);
imagesc(normeOfGrad);
colormap(ax3,jet);
colorbar(ax3);
axis off %equal tigh;
% freezeColors
% cbfreeze(colorbar)

end

