function normalizedSparseCorrelationMatrix=...
	functionToNormalizeTheCorrelationMatrix(...
sparseCorrelationMatrix,...
paramsToNormalizeTheCorrelationMatrix)

alpha=paramsToNormalizeTheCorrelationMatrix.alpha;
markovOrSym=paramsToNormalizeTheCorrelationMatrix.markovOrSym;

N=size(sparseCorrelationMatrix,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if(alpha>0)
    sparseCorrelationMatrix=max(...
        sparseCorrelationMatrix,sparseCorrelationMatrix');
    v=sum(sparseCorrelationMatrix,2);
    invOfV = 1./v;
    invOfV(invOfV>1e6)=0;
    renormMatLeft = spdiags(invOfV.^alpha, 0,...
        N, N);
    % renormMatRight = spdiags (1./sqrt(sum(corrMat,1)), 0,...
    % N, N);
    sparseCorrelationMatrix =...
        renormMatLeft * sparseCorrelationMatrix * renormMatLeft;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if markovOrSym
    v=sum(sparseCorrelationMatrix,2);
    invOfV = 1./v;
    invOfV(invOfV>1e6)=0;
    renormMat =  spdiags (invOfV, 0, N, N);
    normalizedSparseCorrelationMatrix = ...
        renormMat * sparseCorrelationMatrix ;
else
    sparseCorrelationMatrix=max(...
        sparseCorrelationMatrix,sparseCorrelationMatrix');
    
    v=sum(sparseCorrelationMatrix,2);
    invOfV = 1./v;
    invOfV(invOfV>1e6)=0;

    renormMatLeft = spdiags (sqrt(invOfV), 0,...
        N, N);
    % renormMatRight = spdiags (1./sqrt(sum(corrMat,1)), 0,...
    % N, N);
    
    normalizedSparseCorrelationMatrix =...
        renormMatLeft * sparseCorrelationMatrix * renormMatLeft;
end



