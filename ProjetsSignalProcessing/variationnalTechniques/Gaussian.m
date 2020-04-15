function G = Gaussian( n1,n2,sigma )
[X,Y]=meshgrid(-n2/2:n2/2-1,-n1/2:n1/2-1);
G=exp(-(X.^2+Y.^2)/(2*sigma^2));
G=G/sum(G(:));
G=fftshift(G);
