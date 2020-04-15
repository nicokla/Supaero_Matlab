function [ x,y,r,perf_new ] = Metropolis2( masques_interieur, ...
    masques_autour, x_in, y_in, r_in, rmin, rmax,...
    T, image, perf_old, sigma_rayon, sigma_deplacement, coeff_autour,...
    coeff_importance)
r = r_in+round(sigma_rayon*randn);
r = max( rmin, min( rmax , r ) );
r2=round(coeff_autour*r);

x = x_in + round(sigma_deplacement*randn);
x = max( r2, min( size(image,1)-r2, x ) );

y = y_in + round(sigma_deplacement*randn);
y = max( r2, min( size(image,2)-r2, y ) );

perf_new = perf(x, y, r, image, masques_interieur, masques_autour, rmin,...
    coeff_autour, coeff_importance);

if perf_new > perf_old + T*log(rand)

else
    x=x_in;
    y=y_in;
    r=r_in;
    perf_new=perf_old;
end

end

