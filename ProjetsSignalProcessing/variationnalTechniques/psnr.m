function p = psnr( x, y, max )
d = mean( (x(:)-y(:)).^2 );
p = 10*log10( max^2/d );
end