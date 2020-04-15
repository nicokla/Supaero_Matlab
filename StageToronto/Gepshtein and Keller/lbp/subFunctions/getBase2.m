function [ l ] = getBase2( n )
nbDigits=floor(log2(n))+1;
l=zeros(1,nbDigits);
for(i=1:nbDigits)
    l(i)=mod(n,2);
    n=floor(n/2);
end

