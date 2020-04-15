function [indices, freqSelect, intensitesSelect, anglesSelect] =...
    plotFftPerso_2( t,s,f,normes,angles, proportionOfPower )

[intensities, ind] = sort(normes,'descend');
N=length(s);
totalPower = (s*s')/N;

i = 0;
cumulatedPower = 0;
addedPower=0;
while(cumulatedPower <  proportionOfPower * totalPower)
    i=i+1;
    addedPower =  intensities(i).^2 / 2;
    if(ind==0)
        addedPower=2*addedPower;
    end
    cumulatedPower = cumulatedPower + addedPower;
end
indices = ind(1:i);
freqSelect = f(ind(1:i));
anglesSelect = angles(ind(1:i));
intensitesSelect = intensities(1:i);

figure;
subplot(3,1,1); plot(t,s);
ha(1)=subplot(3,1,2); plot(f,normes);
ha(2)=subplot(3,1,3); 
stem(freqSelect,anglesSelect); ylim([-pi pi]);
linkaxes(ha, 'x');


end

