function result = curvature_2( u )
% Approximation plus precise de la courbure que la fonction curvature.m
[dxPlus,dyPlus]=gradient(u);
[dxMoins,dyMoins]=gradientT(u);
eps=1e-9;

b1=zeros(size(u));
b1(:,2:end-1)=u(:,3:end)-u(:,1:end-2);
b1(1:end-1,2:end-1)=b1(1:end-1,2:end-1)+...
  u(2:end,3:end)-u(2:end,1:end-2);
a1=dxPlus./(eps+abs(dxPlus)+(b1/4).^2);

b2=zeros(size(u));
b2(:,2:end-1)=u(:,3:end)-u(:,1:end-2);
b2(2:end,2:end-1)=b2(2:end,2:end-1)+...
  u(1:end-1,3:end)-u(1:end-1,1:end-2);
a2=dxMoins./(eps+abs(dxMoins)+(b2/4).^2);

b3=zeros(size(u));
b3(2:end-1,:)=u(3:end,:)-u(1:end-2,:);
b3(2:end-1,1:end-1)=b3(2:end-1,1:end-1)+...
    u(3:end,2:end)-u(1:end-2,2:end);
a3=dyPlus./(eps+abs(dyPlus)+(b3/4).^2);

b4=zeros(size(u));
b4(2:end-1,:)=u(3:end,:)-u(1:end-2,:);
b4(2:end-1,2:end)=b4(2:end-1,2:end)+...
    u(3:end,1:end-1)-u(1:end-2,1:end-1);
a4=dyMoins./(eps+abs(dyMoins)+(b4/4).^2);

result=a1-a2+a3-a4;

