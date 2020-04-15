function analyseClic2D_old( image1, semiSize, thickness, color, otherArgs, func )
%% Almost the same as the 'new' version, but we have changed a little
% bit and don't use this version any more. We keep it for record

% To stop, use Ctrl/C or close the active plot.

figure;
allo=gcf;
numFig=allo.Number;
figure(numFig); axis tight equal;
imagesc(image1);
drawnow;
try
    while(true)
        figure(numFig); axis tight equal;
        [y,x]=ginput(1);
        x=round(x);
        y=round(y);

        imagesc(image1);
        drawRectangle(y,x,semiSize,color,thickness);
        drawnow;

        func(numFig+1,otherArgs,x,y);
    end
catch
    fprintf('\n\nYou stopped the visualization.\n\n');
end
