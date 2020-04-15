function [...
...%sparseMatrixDistance,...
indexToX,...
indexToY,...
xyToIndex,...
I,J,D,N,...
indexOfVoisins,numberOfVoisins,...
distanceOfVoisins] = ...
	getSparseMatrixDistance(...
x,...
y,...
d,...
whereTextureDescriptorIsDefined)

N=sum(whereTextureDescriptorIsDefined(:));
[Mx,My]=size(whereTextureDescriptorIsDefined);
[indexToX,indexToY]=find(whereTextureDescriptorIsDefined);
[~,~,k]=size(x);

xyToIndex=zeros(Mx,My);
for i=1:N
    a=indexToX(i);
    b=indexToY(i);
    xyToIndex(a,b)=i;
end

I=zeros(k*N,1);
J=zeros(k*N,1);
D=zeros(k*N,1);

indexOfVoisins=zeros(N,k);
distanceOfVoisins=zeros(N,k);
numberOfVoisins=zeros(N,1);
u=1;
for i=1:Mx
    for j=1:My
        %if(whereTextureDescriptorIsDefined(i,j))
        if xyToIndex(i,j)~=0
            ii=xyToIndex(i,j);
            for l=1:k
                t=x(i,j,l);
                s=y(i,j,l);
                %if(whereTextureDescriptorIsDefined(t,s))
                if xyToIndex(t,s)~=0
                    numberOfVoisins(ii)=numberOfVoisins(ii)+1;
                    indexOfVoisins(ii,numberOfVoisins(ii))=...
                        xyToIndex(t,s);
                    distanceOfVoisins(ii,numberOfVoisins(ii))=...
                        d(i,j,l);
                    I(u)=ii;
                    J(u)=xyToIndex(t,s);
                    D(u)=d(i,j,l);
                    u=u+1;
                end
            end
        end
    end
end
% sparseMatrixDistance=sparse(...
% 	I, J, D, N, N);






	