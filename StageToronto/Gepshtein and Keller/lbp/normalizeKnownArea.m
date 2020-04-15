function lbpHistRotInv2 = normalizeKnownArea( lbpHistRotInv, good )
[Mx,My]=size(good);
lbpHistRotInv2=lbpHistRotInv;
for i=1:Mx
    for j=1:My
        if(good(i,j))
            lbpHistRotInv2(i,j,:)=lbpHistRotInv(i,j,:)/sum(lbpHistRotInv(i,j,:));
        else
            lbpHistRotInv2(i,j,:)=0;
        end
    end
end

