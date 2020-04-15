function result=UrbanDetec5(imsat,winsize)
offset = (winsize-1)/2;
result = zeros(size(imsat));
imsquare = imsat.^2;
for i=offset+1:size(imsat,1)-offset
    for j=offset+1:size(imsat,2)-offset
        v=imsat(i-offset:i+offset, j-offset:j+offset);
        v2=imsquare(i-offset:i+offset, j-offset:j+offset);
        result(i,j) = mean(v2(:)) - mean(v(:))^2 ;
    end
end
figure(1);
subplot(1,2,1), imagesc(imsat), colormap(gray);
subplot(1,2,2), imagesc(result), colormap(gray);

