function Z = multiplie2Det3D(mat2d, mat3d)
Z = cellfun(@(x) x.*mat2d,num2cell(mat3d,[1 2]),'UniformOutput',false);
Z = cat(3,Z{:});
end

