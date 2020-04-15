function [result, E1, E2]=UrbanDetec2(imsat,winsize)
%imsat=village;
%winsize=9;

% initialization
dim = size(imsat);
offset = (winsize-1)/2;
num = winsize*winsize;
order1 = 0;
order2 = 0;
result = zeros(dim(1),dim(2));

% Computation of the pixel square value
imsquare = imsat.^2;

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
E1 = zeros(dim(1),dim(2));
E2 = zeros(dim(1),dim(2));

% Sliding window
% initialization
for i = 1 : winsize 
    for j = 1 : winsize
        order1  = order1 + imsat(i,j);
        order2  = order2 + imsquare(i,j);
        intensite = imsat(i,j);
        intensiteMoyenne = imMean(i,j);
        diese_j(intensiteMoyenne+1) = diese_j(intensiteMoyenne+1)+1;
        diese_ij(intensite+1,intensiteMoyenne+1) = diese_ij(intensite+1,intensiteMoyenne+1)+1;
    end
end
result(offset+1,offset+1) = order2/num - (order1/num)^2;
for j=1:256
    if diese_j(j) ~= 0
        c_ij(:,j) = diese_ij(:,j) / diese_j(j);
    end
    sigma2_j(j)=var(0:255,c_ij(:,j));
end
E1(offset+1,offset+1) = sigma2_j'*diese_j/256;%sum(diese_j);
[C,j_max]=max(diese_j); 
E2(offset+1,offset+1) = sigma2_j(j_max);


for i = offset+1 : 2 : dim(1)-offset-1 
    % We scan line i from left to rigth
    for j = offset+2 : dim(2)-offset
        for k = (-offset) : offset       
            di = i+k; dj = j-offset-1;
            order1 = order1 - imsat(di,dj); 
            order2 = order2 - imsquare(di,dj);
            diese_j(imMean(di,dj)+1) = ...
            diese_j(imMean(di,dj)+1)-1;
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1) = ...
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1)-1;
            dj = j+offset;
            order1 = order1 + imsat(di,dj); 
            order2 = order2 + imsquare(di,dj);
            diese_j(imMean(di,dj)+1) = ...
            diese_j(imMean(di,dj)+1)+1;
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1) = ...
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1)+1;
        end
        result(i,j) = order2/num - (order1/num)^2;
        for dj=1:256
            if diese_j(dj) ~= 0
                c_ij(:,dj) = diese_ij(:,dj) / diese_j(dj);
            end
            sigma2_j(dj)=var(0:255,c_ij(:,dj));
        end
        E1(i,j) = sigma2_j'*diese_j/256;%sum(diese_j);
        [C,j_max]=max(diese_j); 
        E2(j,j) = sigma2_j(j_max);
    end

	% We change from line i to line i+1
    for k = (-offset) : offset       
        di = i-offset; dj = dim(2)-offset+k;
        order1 = order1 - imsat(di,dj); 
        order2 = order2 - imsquare(di,dj);
        diese_j(imMean(di,dj)+1) = ...
        diese_j(imMean(di,dj)+1)-1;
        diese_ij(imsat(di,dj)+1,imMean(di,dj)+1) = ...
        diese_ij(imsat(di,dj)+1,imMean(di,dj)+1)-1;
        di = i+1+offset;
        order1 = order1 + imsat(di,dj); 
        order2 = order2 + imsquare(di,dj);
        diese_j(imMean(di,dj)+1) = ...
        diese_j(imMean(di,dj)+1)+1;
        diese_ij(imsat(di,dj)+1,imMean(di,dj)+1) = ...
        diese_ij(imsat(di,dj)+1,imMean(di,dj)+1)+1;
    end
    result(i+1,dim(2)-offset) = order2/num - (order1/num)^2;
    for dj=1:256
        if diese_j(dj) ~= 0
            c_ij(:,dj) = diese_ij(:,dj) / diese_j(dj);
        end
        sigma2_j(dj)=var(0:255,c_ij(:,dj));
    end
    E1(i+1,dim(2)-offset) = sigma2_j'*diese_j/256;%sum(diese_j);
    [C,j_max]=max(diese_j); 
    E2(i+1,dim(2)-offset) = sigma2_j(j_max);
    
    
    
    % We scan line i+1 from right to left
    for j = dim(2)-offset-1 : -1 : offset+1 
        for k = (-offset) : offset       
            di = i+1+k; dj = j+offset+1;
            order1 = order1 - imsat(di,dj); 
            order2 = order2 - imsquare(di,dj);
            diese_j(imMean(di,dj)+1) = ...
            diese_j(imMean(di,dj)+1)-1;
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1) = ...
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1)-1;
            dj = j-offset;
            order1 = order1 + imsat(di,dj); 
            order2 = order2 + imsquare(di,dj);
            diese_j(imMean(di,dj)+1) = ...
            diese_j(imMean(di,dj)+1)+1;
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1) = ...
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1)+1;
        end
        result(i+1,j) = order2/num - (order1/num)^2;
        for dj=1:256
            if diese_j(dj) ~= 0
                c_ij(:,dj) = diese_ij(:,dj) / diese_j(dj);
            end
            sigma2_j(dj)=var(0:255,c_ij(:,dj));
        end
        E1(i+1,j) = sigma2_j'*diese_j/256;%sum(diese_j);
        [C,j_max]=max(diese_j); 
        E2(i+1,j) = sigma2_j(j_max);
    end

    %  change line i+1 to i+2
    if (i<dim(1)-offset-2)
        for k = (-offset) : offset       
            di = i+1-offset; dj = offset+1+k;
            order1 = order1 - imsat(di,dj); 
            order2 = order2 - imsquare(di,dj);
            diese_j(imMean(di,dj)+1) = ...
            diese_j(imMean(di,dj)+1)-1;
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1) = ...
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1)-1;
            di = i+2+offset;
            order1 = order1 + imsat(di,dj); 
            order2 = order2 + imsquare(di,dj);
            diese_j(imMean(di,dj)+1) = ...
            diese_j(imMean(di,dj)+1)+1;
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1) = ...
            diese_ij(imsat(di,dj)+1,imMean(di,dj)+1)+1;
        end
        result(i+2,offset+1) = order2/num - (order1/num)^2;
        for dj=1:256
            if diese_j(dj) ~= 0
                c_ij(:,dj) = diese_ij(:,dj) / diese_j(dj);
            end
            sigma2_j(dj)=var(0:255,c_ij(:,dj));
        end
        E1(i+2,offset+1) = sigma2_j'*diese_j/256;%sum(diese_j);
        [C,j_max]=max(diese_j); 
        E2(i+2,offset+1) = sigma2_j(j_max);
    end
    disp(num2str(i));
    pause(0.01);
end


% Display the original image and the computed texture 
figure(1);
subplot(2,2,1), imagesc(imsat), colormap(gray);
subplot(2,2,2), imagesc(result), colormap(gray);
subplot(2,2,3), imagesc(E1), colormap(gray);
subplot(2,2,4), imagesc(E2), colormap(gray);


