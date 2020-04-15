function contours = hildrett( u0, nit, mingrad)%, maxlapl, mingrad )
usigma = Heat_Equation( u0, nit, 0.1 );
[ux,uy]=gradient(usigma);

norme_gradient=sqrt(ux.^2 + uy.^2);
a1=norme_gradient>mingrad;
l=laplacien(usigma);
signes=sign(l);
contours1 = ...
    signes(2:end-1,2:end-1)~=signes(1:end-2,2:end-1) |...
    signes(2:end-1,2:end-1)~=signes(2:end-1,1:end-2) |...
    signes(2:end-1,2:end-1)~=signes(3:end,2:end-1) |...
    signes(2:end-1,2:end-1)~=signes(2:end-1,3:end) |...
    signes(2:end-1,2:end-1)~=signes(3:end,3:end) |...
    signes(2:end-1,2:end-1)~=signes(1:end-2,1:end-2) |...
    signes(2:end-1,2:end-1)~=signes(1:end-2,3:end) |...
    signes(2:end-1,2:end-1)~=signes(3:end,1:end-2)...
    ;
contours1=contours1 & signes(2:end-1,2:end-1)>=0;
contours=contours1 & a1(2:end-1,2:end-1);
%figure, imagesc(contours), colormap gray;

% figure(6), imagesc(usigma), colormap gray;
% figure(1), imagesc(norme_gradient), colormap gray;
% figure(2), imshow(a1);%, colormap gray;
% figure(3), imagesc(l), colormap gray;
% figure(4), imshow(contours1);
% figure(5), imshow(contours);
