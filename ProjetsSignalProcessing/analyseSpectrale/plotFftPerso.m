function plotFftPerso( t,s,f,normes,angles )
figure;
subplot(3,1,1); plot(t,s);
ha(1)=subplot(3,1,2); plot(f,normes);
ha(2)=subplot(3,1,3); plot(f,angles); ylim([-pi pi]);
linkaxes(ha, 'x');
end