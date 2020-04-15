function [ n ] = list2Num( l )
M=length(l);
n=0;
for i=1:M
    n=2*n;
    n=n+l(i);
end

