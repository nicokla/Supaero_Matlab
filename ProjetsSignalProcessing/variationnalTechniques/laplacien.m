function l = laplacien(u)
[ ux, uy ] = gradient( u );
l=div( ux, uy );

