function result = extrapolate( xFloat,yFloat,smallPatch )
xVect=[1-xFloat; xFloat];
yVect=[1-yFloat; yFloat];
result=xVect'*smallPatch*yVect;

% [y1,x1] = meshgrid(0:1);
% result = interp2(y1, x1, smallPatch, yFloat, xFloat);



% [Xq,Yq] = meshgrid(0:0.1:1);
% Vq=interp2(x,y, smallPatch, Xq, Yq);
% surf(Xq,Yq,Vq)



