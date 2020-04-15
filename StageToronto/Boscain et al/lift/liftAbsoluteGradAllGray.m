function image3d = liftAbsoluteGradAllGray(image, anglesApprox, thetaNumber )

[Mx,My]=size(image);
image3d=zeros(Mx,My,thetaNumber);

for i=1:Mx
    for j=1:My
        image3d(i,j,anglesApprox(i,j))=0.5;
    end
end

end
