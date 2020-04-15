function [angles,noAngles,discretizedAngles,rangeDiscretizedAngles]=...
    getLbpAnglesOfBinaryLbp(lbpLists,numberOfOnes)
[Mx,My,n]=size(lbpLists);
expo=zeros(Mx,My);
for k=1:n
    expo=expo+lbpLists(:,:,k)*exp(1i*2*pi/n*(k-1));
end
angles=angle(expo);
noAngles=double(abs(expo) < 1e-6);
discretizedAngles=zeros(Mx,My);
masque=(mod(numberOfOnes,2)==1);
discretizedAngles(masque)=...
    round(mod(n*angles(masque)/(2*pi),n));
masque=(mod(numberOfOnes,2)==0);
discretizedAngles(masque)=...
    round(mod(0.5 + n*angles(masque)/(2*pi),n));     
rangeDiscretizedAngles=0:(n-1);