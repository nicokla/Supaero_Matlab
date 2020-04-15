function image = keepOnlyCenter2( image2, w1,w2 )
[Mx,My,~]=size(image2);
image=image2((1+w1):(Mx-w1),(1+w2):(My-w2),:);
end

