function Z = multiplie1Det3D( mat1d, mat3d )
Z=mat3d;
for i=1:length(mat1d)
    Z(:,:,i)=mat1d(i)*Z(:,:,i);
end
end

