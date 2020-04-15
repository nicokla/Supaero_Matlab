function [ ux ] = dx_2( u )
ux=zeros(size(u));
ux(2:end-1,:)=u(3:end,:)-u(1:end-2,:);