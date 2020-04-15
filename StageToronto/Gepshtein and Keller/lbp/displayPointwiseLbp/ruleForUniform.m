function v = ruleForUniform( u, options )
%numberOfOnes,discretizedAngles
v=ones(1,3); %saturation=1
v(1)=u(2)/options.n; % hue depends on discretizedAngles
v(3)=u(1)/options.n; % value depends on numberOfOnes

