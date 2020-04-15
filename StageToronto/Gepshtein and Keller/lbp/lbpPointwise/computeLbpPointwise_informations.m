function [ numberOfOnes,...
    numberOfTransitions,...
    wherePointwiseLbpIsComputableWithoutArtifacts,...
    lbpLists, ...
    lbp, ...
    lbpRotInv, ...
    lbpUniform, ...
    var1, ...
    discretizedVar,...
    tableUniformToNormal_numOf1,...
    tableUniformToNormal_debutDes1,...
    tableNormalToUniform2,...
rangeDiscretizedVar] =...
    computeLbpPointwise_informations(imageGris, n, R, good, nbBinsToDiscretizeVar)
% Use computeLbp3 et continue a calculer d'autres trucs.
% Le rotInv a ses non uniforms sur le slot n+1, le reste est entre 
% 0 et n
% Le uniform a ses non uniforms sur le zero, apres c'est le 


[Mx,My]=size(good);
[ continuousValues, lbpLists, whereItsTrue ] =...
    computeLbpPointwise(imageGris, n, R, good);

wherePointwiseLbpIsComputableWithoutArtifacts=prod(whereItsTrue,3);

numberOfOnes = sum(lbpLists,3);
numberOfTransitions=sum(abs(lbpLists-lbpLists(:,:,[n 1:(n-1)])),3);

lbp = zeros(Mx,My);
facteur=1;
for i=1:n
    lbp=lbp + facteur*lbpLists(:,:,i);
    facteur=2*facteur;
end

zoneUniform = numberOfTransitions<=2;
lbpRotInv=(n+1)*ones(Mx,My);
for i=0:n
    lbpRotInv((numberOfOnes==i) & zoneUniform)=i;
end

[tableNormalToUniform,...
    tableUniformToNormal_numOf1,...
    tableUniformToNormal_debutDes1,...
    tableNormalToUniform2] = ...
    makeTableNormalToUniform( n );
lbpUniform=full(tableNormalToUniform(lbp+1));

var1 = var( (continuousValues - repmat(imageGris,[1 1 n])), 0, 3);

[discretizedVar, rangeDiscretizedVar] =...
 discretizeScalarField( var1, nbBinsToDiscretizeVar,...
    wherePointwiseLbpIsComputableWithoutArtifacts);


aa=~logical(wherePointwiseLbpIsComputableWithoutArtifacts);
% nan or 0 or -1 ? let's say -1.
% because nan contaminate and 0 interfere.
% -1 can only be a problem for the plots but we know so it's ok.
var1(aa)=-1;
numberOfOnes(aa)=-1;
numberOfTransitions(aa)=-1;
% lbpLists, ...
lbp(aa)= -1;
lbpRotInv(aa)=-1;
lbpUniform(aa)=-1;
var1(aa)=-1;
discretizedVar(aa)=-1;
% tableUniformToNormal_numOf1(aa)
% tableUniformToNormal_debutDes1,...
% tableNormalToUniform2






