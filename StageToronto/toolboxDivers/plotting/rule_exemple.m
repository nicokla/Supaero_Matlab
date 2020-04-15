function v = ruleForVar( u, options )
% u --> numberOfOnes,discretizedVar
v=ones(1,3); %saturation=1
v(3)=u(1)/options.n;  % value depends on numberOfOnes 
v(1)=u(2)/options.var; % hue depends on discretizedVar
