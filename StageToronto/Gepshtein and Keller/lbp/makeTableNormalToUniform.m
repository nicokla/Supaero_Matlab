function [tableNormalToUniform,...
    tableUniformToNormal_numOf1,...
    tableUniformToNormal_debutDes1,...
    tableNormalToUniform2] = ...
    makeTableNormalToUniform( n )
% Tout ceux qui sont à zéro sont pas uniformes
% tableNormalToUniform2(debutDes1,numOf1)=uniformIndex;
% access tableNormalToUniform(x+1) (because else 0 is not accessible)

tableNormalToUniform=sparse(1, 2^n);
tableNormalToUniform2=zeros(n,n-1);
tailleUniform=(n*(n-1))+2;
tableUniformToNormal=zeros(tailleUniform,1);
tableUniformToNormal_numOf1=zeros(tailleUniform,1);
tableUniformToNormal_debutDes1=zeros(tailleUniform,1);

tableUniformToNormal(1)=0;
tableNormalToUniform(1)=1;%(0)=1 in fact but can't access 0 index in matlab
tableUniformToNormal_numOf1(1)=0;
tableUniformToNormal(tailleUniform)=2^n-1;
tableNormalToUniform(2^n)=tailleUniform; % ((2^n)-1)=tailleUniform actually, see remark above
tableUniformToNormal_numOf1(tailleUniform)=n;
for numOf1 = 1:(n-1)
    list=[zeros(1,n-numOf1) ones(1,numOf1)];
%         list=[ ones(1,numOf1) zeros(1,n-numOf1) ];
    for debutDes1=1:n
        uniformIndex=(numOf1-1)*n+(debutDes1-1)+2;
        lbpNumber = list2Num(list);
        tableNormalToUniform(lbpNumber+1)=uniformIndex;
        tableUniformToNormal(uniformIndex)=lbpNumber;
        tableUniformToNormal_numOf1(uniformIndex)=numOf1;
        tableNormalToUniform2(debutDes1,numOf1)=uniformIndex;
        tableUniformToNormal_debutDes1(uniformIndex)=debutDes1;
%         list = list([n, 1:(n-1)]);
        list = list([2:n, 1]);
    end
end
% tableUniformToNormal
% tableNormalToUniform
% sort(tableNormalToUniform)
% % The only one we will actually use is tableNormalToUniform(lbp+1)
% % If the lbp number is not uniform, tableNormalToUniform(lbp+1) == 0.
% % (this zero is stored as a zero matrix but that should not be a major problem)
% % --> a=full(tableNormalToUniform(1,251))
% cado=[3 2 1]
% cado([3 2 ; 1 1]) --> it works
% cado=sparse([3 2 1])
% full(cado([3 2 ; 1 1])) --> it works


