function result=UrbanDetec(imsat,winsize)
%(name1,name2,winsize,threshold)
% Written by Xavier Descombes, INRIA
% Lecture de l'image
% imsat = imread(name1);

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

% Sliding window
% initialization
for i = 1 : winsize 
    for j = 1 : winsize
        order1  = order1 + imsat(i,j);
        order2  = order2 + imsquare(i,j);
    end
end
result(offset+1,offset+1) = order2/num - (order1/num)^2;
 
for i = offset+1 : 2 : dim(1)-offset-1 
    % We scan line i from left to rigth
    for j = offset+2 : dim(2)-offset
        for k = (-offset) : offset       
            di = i+k; dj = j-offset-1;
            order1 = order1 - imsat(di,dj); 
            order2 = order2 - imsquare(di,dj);
            dj = j+offset;
            order1 = order1 + imsat(di,dj); 
            order2 = order2 + imsquare(di,dj); 
        end
        result(i,j) = order2/num - (order1/num)^2;
    end

    % We change from line i to line i+1
    for k = (-offset) : offset 
        di = i-offset; dj = dim(2)-offset+k;
        order1 = order1 - imsat(di,dj); 
        order2 = order2 - imsquare(di,dj);
        di = i+1+offset;
        order1 = order1 + imsat(di,dj); 
        order2 = order2 + imsquare(di,dj); 
    end
    result(i+1,dim(2)-offset) = order2/num - (order1/num)^2;

    % We scan line i+1 from right to left
    for  j = dim(2)-offset-1 : -1 : offset+1 
        for k= (-offset) : offset        
            di = i+1+k; dj = j+offset+1;
            order1 = order1 - imsat(di,dj); 
            order2 = order2 - imsquare(di,dj);
            dj = j-offset;
            order1 = order1 + imsat(di,dj); 
            order2 = order2 + imsquare(di,dj); 
        end
        result(i+1,j) = order2/num - (order1/num)^2; 
    end

    %  change line i+1 to i+2
    if (i<dim(1)-offset-2)
        for k=(-offset) : offset 
           di = i+1-offset; dj = offset+1+k;
           order1 = order1 - imsat(di,dj); 
           order2 = order2 - imsquare(di,dj);
           di = i+2+offset;
           order1 = order1 + imsat(di,dj); 
           order2 = order2 + imsquare(di,dj);
        end
        result(i+2,offset+1) =  order2/num - (order1/num)^2; 
    end 
%     disp(num2str(i));
%     pause(0.001);
end


% Display the original image and the computed texture 
figure(1);
subplot(1,2,1), imagesc(imsat), colormap(gray);
subplot(1,2,2), imagesc(result), colormap(gray);

% imwrite(result,name2)
% Threshold the texture parameter
%  for i = 1 : dim(1)
%       for j = 1 : dim(2)
%        if result(i,j) < 0 % threshold ?
%          result(i,j) = 0;
%        elseif result(i,j) > ??? % threshold2 ?
%          result(i,j) = 255;
%        end
%      end
%  end
% figure
% imagesc(villageVar1,[30 250])


