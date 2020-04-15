function [ h ] = gaussian( Mx,My,sigma )
%% Now we use gaussian2.m, ie fspecial de matlab
% we still let this code for his informative value

    if(mod(Mx,2)==0)
        tx = [0:Mx/2 -Mx/2+1:-1];
    else
        tx = [0:Mx/2 -Mx/2:-1];
    end
    
    if(mod(My,2)==0)
        ty = [0:My/2 -My/2+1:-1];
    else
        ty = [0:My/2 -My/2:-1];
    end
    
    [Y,X] = meshgrid(ty,tx);
    normalize = @(h)h/sum(h(:));
    h = normalize( exp( -(X.^2+Y.^2)/(2*sigma^2) ) );
end

