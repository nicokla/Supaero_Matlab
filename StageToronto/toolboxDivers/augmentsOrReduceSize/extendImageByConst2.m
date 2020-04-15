function image2 = extendImageByConst2( image,const, w1,w2 )
[Mx,My,Mz]=size(image);
image2=const * ones(Mx+2*w1,My+2*w2,Mz);
image2((w1+1):(w1+Mx),(w2+1):(w2+My),:)=image;
end
