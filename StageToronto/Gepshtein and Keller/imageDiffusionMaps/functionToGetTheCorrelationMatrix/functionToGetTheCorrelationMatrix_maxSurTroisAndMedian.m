function sparseCorrelationMatrix=...
	functionToGetTheCorrelationMatrix_maxSurTroisAndMedian(...
I,J,D,N)

sigma = ( median(D(:)) + max(D(:))/3 ) / 2;

%exp(-1/(2*(facteur²)))=0.85
%(-1/(2*(facteur²)))=ln(0.85)
%(1/(2*(facteur²)))=ln(1/0.85)
%(2*(facteur²))=1/(ln(1/0.85))
%facteur=sqrt(1/(2*ln(1/0.85)));

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

