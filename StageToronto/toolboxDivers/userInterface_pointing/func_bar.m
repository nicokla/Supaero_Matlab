function func_bar(otherArgs,x,y)
% was used along with analyseClic2D_old.m to visualize interactively
% the LBP+var histogram
    representation1_1=otherArgs{1};
    n=otherArgs{2};
    nbBinsToDiscretizeVar=otherArgs{3};
    figure(numFig); axis tight equal;
    bar3(reshape(representation1_1(x,y,:),[n+2,nbBinsToDiscretizeVar]));
    drawnow;
end
