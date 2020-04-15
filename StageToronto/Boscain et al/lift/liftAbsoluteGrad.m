function image3d = liftAbsoluteGrad(image, anglesApprox, thetaNumber )

[Mx,My]=size(image);
image3d=zeros(Mx,My,thetaNumber);

for i=1:Mx
    for j=1:My
        if(anglesApprox(i,j) ~= 0 && ~isnan(anglesApprox(i,j)))
            image3d(i,j,anglesApprox(i,j))=image(i,j);
        end
    end
end

end

