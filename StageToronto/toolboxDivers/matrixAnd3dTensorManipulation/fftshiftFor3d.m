function c = fftshiftFor3d( a )
    b=fftshift(a,1);
    c=fftshift(b,2);
end

