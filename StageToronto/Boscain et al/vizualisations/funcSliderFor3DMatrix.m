function funcSliderFor3DMatrix(image3d)
global defaultMin defaultMax defaultVal;
defaultMin=[0 0 0 0 0];
defaultMax=[1 1 1 1 1];
defaultVal=[0.5 0 0 0 0];
[Mx,My,Mz]=size(image3d);
f= @(k) image3d(:,:,1+round((Mz-1)*k));
funcslider2(f,'imagesc(z1)')
