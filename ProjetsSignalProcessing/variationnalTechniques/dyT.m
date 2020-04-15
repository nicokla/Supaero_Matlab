function [ py ] = dyT( p )
py=p - p(:,[1 1:end-1]);
py(:,1)=p(:,1);
py(:,end)=-p(:,end-1);
