function mat = getExpMat(i, j)
% we suppose Mx and My are even here, and also numTheta
global matricesExponentielles;
a=0;
c=0;
[Mx,My]=size(matricesExponentielles);
numTheta=size(matricesExponentielles{1,1},1);
if(i>(Mx/2)+1 && j>(My/2)+1)
    a=0;
    i=Mx+2-i;
    j=My+2-j;
elseif(i>(Mx/2)+1)
    a=1;
    i=Mx+2-i;
elseif(j>(My/2)+1)
    a=1;
    j=My+2-j;
end
if(i<j)
    c=1;
    j_temp=j;
    j=i;
    i=j_temp;
end
% now i<=Mx/2+1, j<=My/2+1, et i>=j
mat=matricesExponentielles{i,j};
if(c)
    allo=(numTheta/2)+1;
    v=[(allo:(-1):1) (numTheta:(-1):(allo+1))];
    mat=mat(v,v);
end
if(a)
    v=[1 (numTheta:(-1):2)];
    mat=mat(v,v);
end







