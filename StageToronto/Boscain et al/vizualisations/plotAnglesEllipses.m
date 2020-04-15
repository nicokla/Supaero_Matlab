function plotAnglesEllipses( S, k )
global image0;
options.sub = k;
rotate = @(T)cat(3, T(:,:,2), T(:,:,1), -T(:,:,3));
plot_tensor_field(rotate(S), image0, options);
drawnow;
