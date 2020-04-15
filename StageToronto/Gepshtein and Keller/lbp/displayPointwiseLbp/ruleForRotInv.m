function [ v ] = ruleForRotInv( u, options )
% numberOfOnes
v=zeros(1,3); %saturation=0, hue=0
v(3)=u(1)/options.n; % value depends on numberOfOnes


