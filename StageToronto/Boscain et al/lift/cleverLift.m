function image3d=...
cleverLift(image, anglesApprox, thetaNumber, canBeLifted, option)


[Mx,My]=size(image);
image3d=zeros(Mx,My,thetaNumber);
equal=strcmp(option,'equal');
smaller=strcmp(option,'smaller');

for i=1:Mx
    for j=1:My
        if canBeLifted(i,j)  % && (anglesApprox(i,j)~=0)
           image3d(i,j,anglesApprox(i,j))=image(i,j);
        else
            if equal
                image3d(i,j,:)=image(i,j);
            elseif smaller
                image3d(i,j,:)=image(i,j)/thetaNumber;
            end
        end
    end
end
    
    
end

