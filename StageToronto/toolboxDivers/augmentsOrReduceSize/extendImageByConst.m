function image2 = extendImageByConst( image, widthAddedAround, const )
w=widthAddedAround;
[Mx,My,Mz]=size(image);
image2=const * ones(Mx+2*w,My+2*w,Mz);
image2((w+1):(w+Mx),(w+1):(w+My),:)=image;
end

