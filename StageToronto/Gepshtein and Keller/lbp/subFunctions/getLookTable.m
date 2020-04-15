function [ result ] = getLookTable( n )
% The result should be used like this : lookTable(n+1)
% because else 0 is not taken into account (because of the matlab
% convention that arrays start at index 1)
result=(n+1) * ones( 1 , (2^n));
for i=1:(2^n)
    r=getBase2ForcingLength(i-1,n);
%     r=[r zeros(1,n-length(r))];
    a=getNbTransitions(r);
    if(a<=2) % in practice can be 0 or 2
        result(i)=sum(r);
%     else
%         result(i)=n+1; % not useful because already initialized like
%         this.
    end
end

end

