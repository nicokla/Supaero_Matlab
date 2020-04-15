function zoneOk = calculCentreOk(good, cote, rayon)
[Mx,~]=size(good);
good=[zeros(Mx,1) good zeros(Mx,1)];
[~,My]=size(good);
good=[zeros(1,My);good;zeros(1,My)];

se = strel('square',cote);
se2=strel('disk',ceil(rayon),0);

% nhood1 = getnhood(se);
% nhood2 = getnhood(se2);
% nhood3 = logical(conv2(double(nhood1),double(nhood2)));
% se3 = strel('arbitrary', nhood3);
% zoneOk=imerode(good,se3);
zoneOk=good;
zoneOk=imerode(zoneOk,se2);
zoneOk=imerode(zoneOk,se);

zoneOk=zoneOk(2:(end-1),2:(end-1));
end

