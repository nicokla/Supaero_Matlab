function colorbar1D( range1, rule, options, name1)
mat3d=range1(:)';
matException=ones(size(mat3d));
[matRGB,~]=plotMat3DColorWithRule( ...
    mat3d, matException, rule, options );
imagesc([range1(1),range1(end)],...
    [(-0.5),0.5],...
    matRGB);
xlabel(name1);

