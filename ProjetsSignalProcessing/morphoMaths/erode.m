function [ m2 ] = erode( m, taille )
    m2=zeros(size(m));
    for i=1:size(m,1)
        for j=1:size(m,2)
            m2(i,j)=min(min(m(max(1,i-taille):min(size(m,1),i+taille) , max(1,j-taille):min(size(m,2),j+taille) )));
        end
    end
end

