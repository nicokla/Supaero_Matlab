function [ l ] = getBase2ForcingLength( n, s )
% nbDigits=floor(log2(n))+1;
l=zeros(1,s);
i=1;
while(n~=0)
    l(i)=mod(n,2);
    n=floor(n/2);
    i=i+1;
end

