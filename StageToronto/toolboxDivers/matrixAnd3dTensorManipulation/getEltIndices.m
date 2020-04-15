function answer = getEltIndices(mat, listeIJ)
answer=zeros(size(listeIJ,1),1);
for i=1:size(listeIJ,1)
	answer(i)=mat(listeIJ(i,1),listeIJ(i,2));
end
