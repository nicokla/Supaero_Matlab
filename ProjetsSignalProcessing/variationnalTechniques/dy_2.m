function [ uy ] = dy_2( u )
uy=zeros(size(u));
uy(:,2:end-1)=u(:,3:end)-u(:,1:end-2);
