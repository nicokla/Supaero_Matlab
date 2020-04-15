function [ numberOfOnes,...
    numberOfTransitions,...
    isUniform,...
    wherePointwiseLbpIsComputableWithoutArtifacts,...
    lbpLists, ...
    var1, ...
    discretizedVar,...
    angles,...
    discretizedAngles,...
    noAngles] =...
     computeLbpPointwise_informations2(...
      imageGris, n, R, good, nbBinsToDiscretizeVar)

[ continuousValues, lbpLists, whereItsTrue ] =...
    computeLbpPointwise(imageGris, n, R, good);
wherePointwiseLbpIsComputableWithoutArtifacts=prod(whereItsTrue,3);
numberOfOnes = sum(lbpLists,3);
numberOfTransitions=sum(abs(lbpLists-lbpLists(:,:,[n 1:(n-1)])),3);
isUniform=numberOfTransitions<=2;
var1 = var( (continuousValues - repmat(imageGris,[1 1 n])), 0, 3);

% Convention :  0:(nbBinsToDiscretizeVar-1)
[discretizedVar, rangeDiscretizedVar] =...
 discretizeScalarField( var1, nbBinsToDiscretizeVar,...
    wherePointwiseLbpIsComputableWithoutArtifacts);

% Convention :  0:(n-1)
[angles,noAngles,discretizedAngles,rangeDiscretizedAngles]=...
    getLbpAnglesOfBinaryLbp(lbpLists,numberOfOnes);

aa=~logical(wherePointwiseLbpIsComputableWithoutArtifacts);
% nan or 0 or -1 ? let's say -1.
% because nan contaminate and 0 interfere.
% -1 can only be a problem for the plots but we know so it's ok.
var1(aa)=-1;
numberOfOnes(aa)=-1;
numberOfTransitions(aa)=-1;
var1(aa)=-1;
discretizedVar(aa)=-1;




