function [ dx, dy ] = grad_sobel( image3d )
    image3d=extendImageBySymmetry2(image3d,1);
%     image3d = extendImageByConst( image3d, 1, 0 );

%     noyauDx=invertKernelForConv([-0.25 -0.5 -0.25; 0 0 0; 0.25 0.5 0.25]/2) ;
%     noyauDy=invertKernelForConv([-0.25 0 0.25; -0.5 0 0.5; -0.25 0 0.25]/2) ;
    noyauDx=([-0.25 -0.5 -0.25; 0 0 0; 0.25 0.5 0.25]/2) ;
    noyauDy=([-0.25 0 0.25; -0.5 0 0.5; -0.25 0 0.25]/2) ;
    
    dx=cconvForXY_2(image3d, noyauDx);
    dy=cconvForXY_2(image3d, noyauDy);
    
    % noyauDx=invertKernelForConv([-0.25 -0.5 -0.25; 0 0 0; 0.25 0.5 0.25]/2) ;
    % noyauDy=invertKernelForConv([-0.25 0 0.25; -0.5 0 0.5; -0.25 0 0.25]/2) ;
    % dx=imfilter(imageGris,noyauDx,'conv');
    % dy=imfilter(imageGris,noyauDy,'conv');

    dx=keepOnlyCenter(dx,1);
    dy=keepOnlyCenter(dy,1);
end

