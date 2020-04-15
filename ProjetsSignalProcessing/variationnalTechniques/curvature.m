function c = curvature( u )
eps=1e-9;
[g1,g2]=gradient(u);
ng=sqrt(g1.^2+g2.^2+eps);
c=div(g1./ng,g2./ng);