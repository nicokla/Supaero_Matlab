function [ dx, dy, problem ] = gradPerso2( image, good, option )
% Comme gradPerso mais marche aussi pour matrice 3d.
% For each pixels in good :
% If it's possible, we compute the 2nd order.
% Else, if it's possible, we compute the first order.
if(nargin <= 2)
    option='sym';
end

[Mx, My, Mz]= size(image);

if(nargin==1)
    good=ones(Mx,My);
end

dx=zeros(Mx+2,My+2, Mz);
dy=zeros(Mx+2,My+2, Mz);
problem=zeros(Mx+2,My+2);

% We extend the image to be able
% to compute derivatives on the edges
if(strcmp(option,'sym'))
    image=image([1 1:Mx Mx],[1 1:My My], :);
    good=good([1 1:Mx Mx],[1 1:My My], :);
elseif(strcmp(option,'per'))
    image=image([Mx 1:Mx 1],[My 1:My 1], :);
    good=good([Mx 1:Mx 1],[My 1:My 1], :);
end

% We do the calculations
for i=2:(Mx+1)
    for j=2:(My+1)
        if(good(i,j))
            if(good(i+1,j) && good(i-1,j))
                dx(i,j, :)=(image(i+1,j, :)-image(i-1,j, :))/2;
            elseif good(i+1,j)
                dx(i,j, :)=(image(i+1,j, :)-image(i,j, :));
            elseif good(i-1,j)
                dx(i,j, :)=(image(i,j, :)-image(i-1,j, :));
            else
                problem(i,j)=1;
            end
            
            if(good(i,j+1) && good(i,j-1))
                dy(i,j, :)=(image(i,j+1, :)-image(i,j-1, :))/2;
            elseif good(i,j+1)
                dy(i,j, :)=(image(i,j+1, :)-image(i,j, :));
            elseif good(i,j-1)
                dy(i,j, :)=(image(i,j, :)-image(i,j-1, :));
            else
                problem(i,j)=1;
            end
            
            % if either of dx or dy could not be computed,
            % we cancel the other (it would have no meaning
            % for the purpose of angle calculation later on)
            if(problem(i,j))
                dx(i,j, :)=0;
                dy(i,j, :)=0;
            end
        end
    end
end


% We crop back to the real size
dx=dx(2:(Mx+1),2:(My+1), :);
dy=dy(2:(Mx+1),2:(My+1), :);
problem=problem(2:(Mx+1),2:(My+1));




end

