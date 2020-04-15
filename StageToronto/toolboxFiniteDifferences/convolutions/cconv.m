function result = cconv( f, h )
result = real(ifft2(fft2(f).*repmat(fft2(h),[1 1 size(f,3)])));
end
% imagesc(gaussian2(10,2))
% imagesc(abs(fft2(gaussian2(10,2))))
