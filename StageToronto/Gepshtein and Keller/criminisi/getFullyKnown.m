function [ fullyKnown ] = getFullyKnown( good, fullSize )
good2 = extendImageByConst( good, 1, 0 ); % We ignore the values outside of the image

fullyKnownTemp=convUsingCconv( 1-good2, ones(fullSize), 2 ); % option 2 => convolution without periodicity
% Where bad pixels are close (ie if bad are centered on patch ones(fullSize)
% all the covered pixels are bad in fullyKnown)
fullyKnown=(fullyKnownTemp < 0.1); %double(...)
% fullyKnown2=imerode(good2,ones(fullSize));

fullyKnown=keepOnlyCenter( fullyKnown, 1 ); % We keep it the same size as the matrix named 'good'.


