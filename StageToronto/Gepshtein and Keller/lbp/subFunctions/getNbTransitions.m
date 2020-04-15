function [ n ] = getNbTransitions( l )
% M=length(l);
% n=double(l(1)~=l(end));
% for i=1:(M-1)
%     n=n+double(l(i)~=l(i+1));
% end

l2=l - l([end 1:(end-1)]);
n=sum(abs(l2));
end

