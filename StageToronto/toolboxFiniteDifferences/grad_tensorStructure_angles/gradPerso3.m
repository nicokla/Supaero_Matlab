function [dx, dy] = ...
  gradPerso3(image, good, sigma_tenseur,...
  sigma_gradient)

image2 = blurPerso(image, sigma_gradient, good);
[ dx, dy, ~ ] = gradPerso( good, image2, 'sym' );
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
    
[e1,~] = eigbasis(S);
[lambda1,~] = eigenval(S);
lambda1=abs(lambda1);
dx=lambda1.*e1(:,:,1);
dy=lambda1.*e1(:,:,2);

% normeOfGrad = sqrt(lambda1+lambda2);
% normeOfGrad(~logical(good))=0;

end

