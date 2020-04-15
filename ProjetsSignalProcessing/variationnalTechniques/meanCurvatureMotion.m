function [f,snrList] = meanCurvatureMotion(I_nonBruite, I, niter, tau )
epsilon = 1e-6;
amplitude = @(u)sqrt(sum(u.^2,3)+epsilon^2);
T=ceil(niter*tau);
f = I;
clf; k = 0;
snrList=zeros(niter, 1);
snr0=snr(I_nonBruite,I);
for i=1:niter
    f = f + tau * amplitude(gradient(f)) .* curvature_3(f);
    snrList(i) = snr(I_nonBruite,f)-snr0;
    if mod(i,floor(niter/4))==0
        k = k+1;
        subplot(2,2,k), imshow(f);
        title(strcat(['T=' num2str(T*k/4,3)]));
    end
end


