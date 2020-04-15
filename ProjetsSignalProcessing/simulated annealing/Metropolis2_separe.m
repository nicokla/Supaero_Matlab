function [ x,y,r,perf_new ] = Metropolis2_separe( masques, x_in, y_in, r_in, rmin, rmax, T, image, perf_old, sigma_rayon, sigma_deplacement )
r=r_in;
r2=round(sqrt(2)*r);

x = x_in + round(sigma_deplacement*randn);
x = max( r2, min( size(image,1)-r2, x ) );

y = y_in + round(sigma_deplacement*randn);
y = max( r2, min( size(image,2)-r2, y ) );

perf_new = perf(x, y, r, image, masques, rmin);

if perf_new > perf_old + T*log(rand)
    r=r_in; % on change de position en gardant le mm rayon
else
    x=x_in;
    y=y_in;
    
    r = r_in+round(sigma_rayon*randn);
    r = max( rmin, min( rmax , r ) );
    r2=round(sqrt(2)*r);
    x = max( r2, min( size(image,1)-r2, x ) );
    y = max( r2, min( size(image,2)-r2, y ) );
    
    perf_new2 = perf(x, y, r, image, masques, rmin);
    if perf_new2 > perf_old + T*log(rand)
        perf_new=perf_new2; 
        % on reste sur la mm position (ou decale si rayon trop grand) en changeant le rayon
    else
        r=r_in; % on ne change rien
        perf_new=perf_old;
    end

end

end

