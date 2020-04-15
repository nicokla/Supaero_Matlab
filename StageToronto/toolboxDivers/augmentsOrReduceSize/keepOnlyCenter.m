function image = keepOnlyCenter( image2, w )
[Mx,My,~]=size(image2);
image=image2((1+w):(Mx-w),(1+w):(My-w),:);
end

