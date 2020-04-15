function px = dxT( p )
px=p - p([1 1:end-1],:);
px(1,:)=p(1,:);
px(end,:)=-p(end-1,:);


