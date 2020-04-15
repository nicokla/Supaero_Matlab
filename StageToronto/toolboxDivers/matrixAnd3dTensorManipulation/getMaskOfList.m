function mask = getMaskOfList( Mx,My,list )
mask=zeros(Mx,My);
for i=1:size(list,1)
    mask(list(i,1),list(i,2))=1;
end

