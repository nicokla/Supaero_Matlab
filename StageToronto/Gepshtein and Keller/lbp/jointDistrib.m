function result = jointDistrib(rangeLbpRotInv,rangeDiscretizedVar,...
    lbpRotInvZone, discretizedVarZone, fullSize) %optionNormaliser)

result = zeros(length(rangeLbpRotInv), length(rangeDiscretizedVar));
for i=1:fullSize
    for j=1:fullSize
        a=lbpRotInvZone(i,j)+1;
        b=discretizedVarZone(i,j)+1;
        result(a,b)=result(a,b)+1;
    end
end
% if(optionNormaliser)
%     result = result / sum(sum(result));
% end

% result=result(:);


