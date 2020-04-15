function [matRGB,matHSL]=...
    plotMat3DColorWithRule( mat3d, matException, rule, options )
% Rule is a handle to a function with the rule from mat3d column to a
% matHSL pixel

[Mx,My,Mz]=size(mat3d);
matHSL=zeros(Mx,My,3);

for i=1:Mx
    for j=1:My
        matHSL(i,j,:)=reshape(rule(mat3d(i,j,:), options),[1 1 3]);
%         temp=mat3d(i,j,:);
%         matHSL(i,j)=rule(temp(:));
    end
end

matRGB=hsl2rgb(matHSL);
for i=1:3
    matRGB(:,:,i)=matException.*matRGB(:,:,i);
    matHSL(:,:,i)=matException.*matHSL(:,:,i);
end
imagesc(matRGB);

