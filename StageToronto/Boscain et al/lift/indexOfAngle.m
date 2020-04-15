function [ i ] = indexOfAngle( angle,thetaNumber )
angleExact=mod(angle,pi);
i=round(angleExact/(pi/thetaNumber));
if i==thetaNumber
    i=0;
end
i=i+1;
end

