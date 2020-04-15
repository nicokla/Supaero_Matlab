function [result, rangeDiscretizedVar] = ...
discretizeScalarField( var1, nbZones,...
    wherePointwiseLbpIsComputableWithoutArtifacts)
% first zone coded by zeros
% var1Sorted = sort(var1(:),'ascend');
tictac=var1(logical(wherePointwiseLbpIsComputableWithoutArtifacts));
var1Sorted = sort(tictac,'ascend');

tailleVar1=length(var1Sorted);
limites=zeros(1,nbZones-1);
for i=1:(nbZones-1)
    limites(i) = var1Sorted(round(i*tailleVar1/nbZones));
end

result=zeros(size(var1));
for i=2:(nbZones-1)
    result(var1>limites(i-1) & var1<limites(i))=i-1;
end
result(var1>limites(nbZones-1))=nbZones-1;

rangeDiscretizedVar = 0:(nbZones-1);
% imagesc2(result);





