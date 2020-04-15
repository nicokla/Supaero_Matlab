function  [E1, E2] = UrbanDetec6(imsat,winsize)
% imsat=village;
% winsize=9;

offset = (winsize-1)/2;
num = winsize*winsize;
dim = size(imsat);

diese_j = zeros(1,256);
diese_ij = zeros(256);
c_ij = zeros(256); %diese_ij ./ (diese_j * ones(1, 256));
sigma2_j =  zeros(1,256);
E1 = zeros(size(imsat));
E2 = zeros(size(imsat));

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

intensites = 0:255;
intensitesCarres = intensites.^2;

i=offset+1;
j=offset+1;

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
E1(i,j) = sigma2_j*diese_j'/num;
[C,j_max]=max(diese_j); 
E2(i,j) = sigma2_j(j_max);


for i = offset+1 : 2 : dim(1)-offset-1 
    % We scan line i from left to rigth
    for j = offset+2 : dim(2)-offset
        for k = (-offset) : offset
            di = i+k; dj = j-offset-1;
            ddj=imMean(di,dj)+1;
            ddi=imsat(di,dj)+1;
            diese_j(ddj) = diese_j(ddj) - 1;
            diese_ij(ddi,ddj) = diese_ij(ddi,ddj) - 1;
            if(diese_j(ddj)==0)
               c_ij(:,ddj) = 0;
            else
               c_ij(:,ddj) = ...
                diese_ij(:,ddj) / diese_j(ddj); 
            end
            
            dj = j+offset;
            ddj=imMean(di,dj)+1;
            ddi=imsat(di,dj)+1;
            diese_j(ddj) = diese_j(ddj) + 1;
            diese_ij(ddi,ddj) = diese_ij(ddi,ddj) + 1;
            c_ij(:,ddj) = ...
                diese_ij(:,ddj) / diese_j(ddj); 
        end
        sigma2_j= ( intensitesCarres * c_ij ) - ...
        ( intensites * c_ij ).^2;
        E1(i,j) = sigma2_j*diese_j'/num;
        [C,j_max]=max(diese_j); 
        E2(i,j) = sigma2_j(j_max); 
    end

    % We change from line i to line i+1
    for k = (-offset) : offset 
        di = i-offset; dj = dim(2)-offset+k;
        ddj=imMean(di,dj)+1;
        ddi=imsat(di,dj)+1;
        diese_j(ddj) = diese_j(ddj) - 1;
        diese_ij(ddi,ddj) = diese_ij(ddi,ddj) - 1;
        if(diese_j(ddj)==0)
           c_ij(:,ddj) = 0;
        else
           c_ij(:,ddj) = ...
            diese_ij(:,ddj) / diese_j(ddj); 
        end
            
        di = i+1+offset;
        ddj=imMean(di,dj)+1;
        ddi=imsat(di,dj)+1;
        diese_j(ddj) = diese_j(ddj) + 1;
        diese_ij(ddi,ddj) = diese_ij(ddi,ddj) + 1;
        c_ij(:,ddj) = ...
            diese_ij(:,ddj) / diese_j(ddj); 
    end
    sigma2_j= ( intensitesCarres * c_ij ) - ...
    ( intensites * c_ij ).^2;
    E1(i+1,dim(2)-offset) = sigma2_j*diese_j'/num;
    [C,j_max]=max(diese_j); 
    E2(i+1,dim(2)-offset) = sigma2_j(j_max); 

    % We scan line i+1 from right to left
    for  j = dim(2)-offset-1 : -1 : offset+1 
        for k= (-offset) : offset        
            di = i+1+k; dj = j+offset+1;
            ddj=imMean(di,dj)+1;
            ddi=imsat(di,dj)+1;
            diese_j(ddj) = diese_j(ddj) - 1;
            diese_ij(ddi,ddj) = diese_ij(ddi,ddj) - 1;
            if(diese_j(ddj)==0)
               c_ij(:,ddj) = 0;
            else
               c_ij(:,ddj) = ...
                diese_ij(:,ddj) / diese_j(ddj); 
            end
            
            dj = j-offset;
            ddj=imMean(di,dj)+1;
            ddi=imsat(di,dj)+1;
            diese_j(ddj) = diese_j(ddj) + 1;
            diese_ij(ddi,ddj) = diese_ij(ddi,ddj) + 1;
            c_ij(:,ddj) = ...
                diese_ij(:,ddj) / diese_j(ddj); 
        end
        sigma2_j= ( intensitesCarres * c_ij ) - ...
        ( intensites * c_ij ).^2;
        E1(i+1,j) = sigma2_j*diese_j'/num;
        [C,j_max]=max(diese_j); 
        E2(i+1,j) = sigma2_j(j_max); 
    end

    %  change line i+1 to i+2
    if (i<dim(1)-offset-2)
        for k=(-offset) : offset 
            di = i+1-offset; dj = offset+1+k;
            ddj=imMean(di,dj)+1;
            ddi=imsat(di,dj)+1;
            diese_j(ddj) = diese_j(ddj) - 1;
            diese_ij(ddi,ddj) = diese_ij(ddi,ddj) - 1;
            if(diese_j(ddj)==0)
               c_ij(:,ddj) = 0;
            else
               c_ij(:,ddj) = ...
                diese_ij(:,ddj) / diese_j(ddj); 
            end
            
            di = i+2+offset;
            ddj=imMean(di,dj)+1;
            ddi=imsat(di,dj)+1;
            diese_j(ddj) = diese_j(ddj) + 1;
            diese_ij(ddi,ddj) = diese_ij(ddi,ddj) + 1;
            c_ij(:,ddj) = ...
                diese_ij(:,ddj) / diese_j(ddj); 
        end
        sigma2_j= ( intensitesCarres * c_ij ) - ...
        ( intensites * c_ij ).^2;
        E1(i+2,offset+1) = sigma2_j*diese_j'/num;
        [C,j_max]=max(diese_j); 
        E2(i+2,offset+1) = sigma2_j(j_max); 
    end
    disp(num2str(i));
    pause(0.001);
end


figure(1);
subplot(1,3,1), imagesc(imsat), colormap(gray);
subplot(1,3,2), imagesc(E1), colormap(gray);
subplot(1,3,3), imagesc(E2), colormap(gray);



