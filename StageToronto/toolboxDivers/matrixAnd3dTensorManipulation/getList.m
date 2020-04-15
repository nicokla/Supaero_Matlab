function list = getList(binaryMask)
% kernel=ones(3);
% frontiereIn0 = frontiereIn(binaryMask, kernel);
% mask=double(mask);
a=sum(sum(binaryMask));
list=zeros(a,2);
k=1;
for i=1:size(binaryMask,1)
	for j=1:size(binaryMask,2)
		if(binaryMask(i,j))
			list(k,1)=i;
			list(k,2)=j;
			k=k+1;
		end
	end
end



