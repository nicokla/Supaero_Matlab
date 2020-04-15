function result = psnr( image, image_approx )
maxi=max(image(:));
diffSquared=(image-image_approx).^2;
diff_num=sqrt(mean(diffSquared(:)));
result = 20*log10(maxi/diff_num);
end

