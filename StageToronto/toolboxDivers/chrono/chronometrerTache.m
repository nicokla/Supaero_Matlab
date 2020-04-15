function [ dureeEnSecondes, timeString ] =...
    chronometrerTache( tache, input )

dateDebut=now;

tache(input);

dateFin=now;
dureeEnJours=dateFin-dateDebut;
dureeEnSecondes=dureeEnJours*3600*24;
timeString=datestr(dureeEnJours,'HH_MM_SS_FFF');
