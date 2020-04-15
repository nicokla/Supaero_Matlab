function  [E1, E2] = UrbanDetec4(imsat,winsize)
offset = (winsize-1)/2;
result = zeros(size(imsat));
%imsquare = imsat.^2;

masqueMeanVoisins = zeros(3);
for i = 1:3
    for j=1:3
        if mod(i+j,2)==1
            masqueMeanVoisins(i,j)=1/4;
        end
    end
end
imMean=imfilter(imsat,masqueMeanVoisins,'conv');
imMean=floor(imMean);

diese_j = zeros(256,1);
diese_ij = zeros(256);
c_ij = zeros(256); %diese_ij ./ (diese_j * ones(1, 256));
sigma2_j =  zeros(256,1);
E1 = zeros(size(imsat));
E2 = zeros(size(imsat));

intensites = 0:255;
intensitesCarres = intensites.^2;

for i=offset+1:size(imsat,1)-offset
    for j=offset+1:size(imsat,2)-offset
        v=imsat(i-offset:i+offset, j-offset:j+offset);
        v=v(:);
        v3=imMean(i-offset:i+offset, j-offset:j+offset);
        v3=v3(:);
        for a=0:255
            c=find(v3==a);
            diese_j(a+1) = length(c);
            if(diese_j(a+1) ~= 0)
                for b=0:255
                    diese_ij(b+1,a+1) = length(find(v(c)==b));
                end
                c_ij(:,a+1) = diese_ij(:,a+1) / diese_j(a+1) ;
                sigma2_j(a+1)=intensitesCarres * c_ij(:,a+1) - ...
                            ( intensites       * c_ij(:,a+1))^2;
            else
                diese_ij(:,a+1)=0;
                c_ij(:,a+1)=0;
                sigma2_j(a+1)=0;
            end
        end
        E1(i,j) = sigma2_j'*diese_j/256;
        [C,j_max]=max(diese_j); 
        E2(i,j) = sigma2_j(j_max);
    end
    disp(num2str(i));
    pause(0.01);
end

figure(1);
subplot(1,3,1), imagesc(imsat), colormap(gray);
subplot(1,3,2), imagesc(E1), colormap(gray);
subplot(1,3,3), imagesc(E2), colormap(gray);


