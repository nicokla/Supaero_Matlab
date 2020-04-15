function sparseCorrelationMatrix=...
	functionToGetTheCorrelationMatrix_bertozzi(...
I,J,D,N,...
indexOfVoisins,numberOfVoisins,...
distanceOfVoisins)

% 0.6065 by default at the sigma location, here we choose 0.85.
% This is because sigma computed here is a sigma which is a little
% too small (it's not computed on the whole dataset but on the KNN
% distances).
facteur=sqrt(1/(2*log(1/0.85)));
twoSigmaSquared=zeros(size(indexOfVoisins,1),1);
sigma=zeros(size(indexOfVoisins,1),1);
for i=1:size(indexOfVoisins,1)
    sigma(i)=facteur*median(distanceOfVoisins(i,1:numberOfVoisins(i)));
%     sigma(i)=median(distanceOfVoisins(i,1:numberOfVoisins(i)));
    twoSigmaSquared(i)=2*sigma(i)^2;
end

expo=zeros(size(I));
for i=1:size(I,1)
    j=I(i);
    l=J(i);
    twoSigmaSquared0=sqrt(twoSigmaSquared(j)*twoSigmaSquared(l));
    expo(i)=exp(-(D(i).^2)/twoSigmaSquared0);
end

sparseCorrelationMatrix=sparse(...
	I, J, expo, N, N);



