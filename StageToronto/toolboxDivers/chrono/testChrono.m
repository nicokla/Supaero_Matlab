

for i=1:10
[ dureeEnSecondes, timeString ] =...
    chronometrerTache( tache, input );
dureeEnSecondesAll(i)=dureeEnSecondes;
end
plot(dureeEnSecondes);