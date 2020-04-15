function [ S, lambda1, lambda2, e1, e2,...
    normeOfGrad, anisotropy, anisotropyLog,...
    anglesExacts, problem] = ...
  getAngles2(image, good, sigma_tenseur,...
  sigma_gradient)

%% The same as getAngles, just a slight change of the 
% input/output (we don't use some of the input/output anymore)

image2 = blurPerso(image, sigma_gradient, good);
[ dx, dy, problem ] = gradPerso( good, image2, 'sym' );
tensorize = @(u)cat(3, u(:,:,1).^2, u(:,:,2).^2, u(:,:,1).*u(:,:,2));
S = blurPerso( tensorize( cat(3,dx,dy) ), sigma_tenseur, good);

delta = @(S)(S(:,:,1)-S(:,:,2)).^2 + 4*S(:,:,3).^2;
eigenval = @(S)deal( ...
    (S(:,:,1)+S(:,:,2)+sqrt(abs(delta(S))))/2,  ...
    (S(:,:,1)+S(:,:,2)-sqrt(abs(delta(S))))/2 );
normalize = @(u)u./repmat(sqrt(sum(u.^2,3)), [1 1 2]);
eig1 = @(S)normalize( cat(3,2*S(:,:,3), S(:,:,2)-S(:,:,1)+sqrt(abs(delta(S))) ) );
ortho = @(u)deal(u, cat(3,-u(:,:,2), u(:,:,1)));
eigbasis = @(S)ortho(eig1(S));
    
[e1,e2] = eigbasis(S);
[lambda1,lambda2] = eigenval(S);
lambda1=abs(lambda1);%+1e-30;
lambda2=abs(lambda2);%+1e-30;
if(lambda1<lambda2)
    lambda3=lambda2;
    lambda2=lambda1;
    lambda1=lambda3;
end

normeOfGrad = sqrt(lambda1+lambda2);
% medianGrad=median(normeOfGrad(:));
normeOfGrad(~logical(good))=0;
% anisotropy = sqrt(lambda1./lambda2);
% anisotropy = 1/(1-sqrt(1/2))*((sqrt(lambda1./(lambda1+lambda2)))-sqrt(1/2));
% anisotropy = 2*((lambda1./(lambda1+lambda2))-0.5);
% anisotropy = sqrt(lambda1)./(normeOfGrad+medianGrad/3);
% anisotropy = sqrt(lambda1)./max(normeOfGrad,medianGrad);
% anisotropy=anisotropy.*normeOfGrad;
anisotropy = (lambda1-lambda2)./(lambda1+lambda2);

anisotropy(~logical(good))=0;
anisotropyLog = log(abs(anisotropy));

anglesExacts=mod(atan(e1(:,:,2)./e1(:,:,1)) + pi/2 , pi);
[row,col]=find(isnan(anglesExacts));

for i=1:size(row,1)
    u=row(i);v=col(i);
    anglesExacts(u,v)=...
        mod(atan(dy(u,v)./(dx(u,v)+1e-6))+pi/2, pi);
%     anglesExacts(u,v)=...
%         mod(atan(e2(u,v,2)./e2(u,v,1)), pi);
end
% anglesExacts(anglesExacts>=10)=0;% against nan, ie 0/0
anglesExacts(~logical(good))=0;
anglesExacts(isnan(anglesExacts))=0;

end

