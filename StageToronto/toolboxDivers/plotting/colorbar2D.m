function colorbar2D( range1, range2, rule, options, name1, name2 )
% the rule should be for 2
l1=length(range1);
l2=length(range2);
mat3d=zeros(l2,l1,2);
mat3d(:,:,2)=range2(:)*ones(1,l1);%(end:(-1):1)'
mat3d(:,:,1)=ones(l2,1)*(range1(:)');
matException=ones(size(mat3d,1),size(mat3d,2));
[matRGB,~]=plotMat3DColorWithRule( ...
    mat3d, matException, rule, options );
imagesc([range1(1),range1(end)],...
    [range2(1),range2(end)],...
    matRGB);
xlabel(name1);
ylabel(name2);
% ylim([range1(1)-0.5,range1(end)+0.5])
% xlim([range2(1)-0.5,range2(end)+0.5])
% set(gca,'YDir','reverse');
set(gca,'YDir','normal'); 

