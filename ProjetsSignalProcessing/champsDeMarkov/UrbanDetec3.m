function result=UrbanDetec3(imsat,winsize)
offset = (winsize-1)/2;
result = zeros(size(imsat));
imsquare = imsat.^2;
sumCarres=0;
sumPixels=0;
num = winsize*winsize;
for i=offset+1:size(imsat,1)-offset
    j=offset+1;
    v=imsat(i-offset:i+offset, j-offset:j+offset);
    v2=imsquare(i-offset:i+offset, j-offset:j+offset);
    sumCarres=sum(v2(:));
    sumPixels=sum(v(:));
    result(i,j) = sumCarres/num - (sumPixels/num)^2 ;
    for j=offset+2:size(imsat,2)-offset
        sumCarres=sumCarres - sum(imsquare(i-offset:i+offset,j-offset-1)) ...
                            + sum(imsquare(i-offset:i+offset,j+offset));
        sumPixels=sumPixels - sum(imsat(i-offset:i+offset,j-offset-1)) ...
                            + sum(imsat(i-offset:i+offset,j+offset));
        result(i,j) = sumCarres/num - (sumPixels/num)^2 ;
    end
end

figure(1);
subplot(1,2,1), imagesc(imsat), colormap(gray);
subplot(1,2,2), imagesc(result), colormap(gray);

