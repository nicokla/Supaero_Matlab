function result = curvature_3( u )
% Approximation plus precise de la courbure que la fonction curvature.m
% Conditions de bords corrigées par rapport à curvature_2.m
%u=Xn;

[dxPlus,dyPlus]=gradient(u);
[dxMoins,dyMoins]=gradientT(u);
eps=1e-9;

b1=u(:,[2:end end])-u(:,[1 1:end-1]);
b1(1,:) = 2*b1(1,:);
b1(end,:) = 2*b1(end,:);
b12=u([2:end end],[2:end end])-u([2:end end],[1 1:end-1]);
b12(1,:) = 2*b12(1,:);
b12(end,:) = 2*b12(end,:);
b1=b1+b12;
a1=dxPlus./(eps+abs(dxPlus)+(b1/4).^2);

b2=u(:,[2:end end])-u(:,[1 1:end-1]);
b2(1,:) = 2*b2(1,:);
b2(end,:) = 2*b2(end,:);
b22=u([1 1:end-1],[2:end end])-u([1 1:end-1],[1 1:end-1]);
b22(1,:) = 2*b22(1,:);
b22(end,:) = 2*b22(end,:);
b2=b2+b22;
a2=dxMoins./(eps+abs(dxMoins)+(b2/4).^2);

b3=u([2:end end],:)-u([1 1:end-1],:);
b3(:,1) = 2*b3(:,1);
b3(:,end) = 2*b3(:,end);
b32=u([2:end end],[2:end end])-u([1 1:end-1],[2:end end]);
b32(:,1) = 2*b32(:,1);
b32(:,end) = 2*b32(:,end);
b3=b3+b32;
a3=dyPlus./(eps+abs(dyPlus)+(b3/4).^2);

b4=u([2:end end],:)-u([1 1:end-1],:);
b4(:,1) = 2*b4(:,1);
b4(:,end) = 2*b4(:,end);
b42=u([2:end end],[1 1:end-1])-u([1 1:end-1],[1 1:end-1]);
b42(:,1) = 2*b42(:,1);
b42(:,end) = 2*b42(:,end);
b4=b4+b42;
a4=dyMoins./(eps+abs(dyMoins)+(b4/4).^2);

result=a1-a2+a3-a4;

