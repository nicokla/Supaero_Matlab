function [u,snrList] = Perona_Malik( u0_nonBruite, u0, nit, alpha, tau, option)
u=u0;
%tau=0.1;
%figure; colormap(gray);
snrList=zeros(nit, 1);
snr0=snr(u0_nonBruite,u0);
for i=1:nit
    %imagesc(u);%axis equal
    %title(sprintf('Equation chaleur : Iteration %i/%i',i-1,nit));
    [ ux, uy ] = gradient( u );
    norme_gradient=sqrt(ux.^2+ uy.^2) ;
    if( strcmp(option,'racine') )
        coeff= ones(size(u)) ./ sqrt(1 + (norme_gradient/alpha).^2);
    else
        coeff= ones(size(u)) ./ (1 + (norme_gradient/alpha).^2);
    end
    u=u+tau*div( coeff.*ux, coeff.*uy );
    %pause;
    snrList(i) = snr(u0_nonBruite,u)-snr0;
end


end


