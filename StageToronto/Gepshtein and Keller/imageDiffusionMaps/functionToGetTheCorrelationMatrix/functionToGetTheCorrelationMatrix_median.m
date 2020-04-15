function sparseCorrelationMatrix=...
	functionToGetTheCorrelationMatrix_median(...
I,J,D,N)

sigma=median(D(:));

% 0.6065 by default at the sigma location, here we choose 0.85.
% This is because sigma computed here is a sigma which is a little
% too small (it's not computed on the whole dataset but on the KNN
% distances).
facteur=sqrt(1/(2*log(1/0.85)));
sigma=facteur*sigma;

twoSigmaSquared=2*sigma^2;
expo=exp(-(D.^2)/twoSigmaSquared);
sparseCorrelationMatrix=sparse(...
	I, J, expo, N, N);

