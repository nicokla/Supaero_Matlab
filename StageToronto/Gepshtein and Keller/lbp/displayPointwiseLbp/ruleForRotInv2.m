function v = ruleForRotInv2( u, options )
v=zeros(1,3); %saturation=0, hue=0
% value depends on numberOfOnes :
v(3)=abs( 2*u(1)/options.n - 1 ); 


