function [ centres, classesDeChaquePoints ] = Kmeans( entrees, nbClasses, optionPause )
% entrees=meas;
% nbClasses=3;
% optionPause=1;

dimSpace = size(entrees,2);
nbEchantillons = size(entrees,1);

if(dimSpace >= 3)
    dimRed=3;
else
    dimRed=2;
end

if(optionPause && dimSpace > 3)
    [mappedX,mapping] =pca(entrees,dimRed);
end
s = ones(1,nbEchantillons)*30;
meanEntrees = mean(entrees);

m1=mean(entrees);
matCovar = (entrees' * entrees) / nbEchantillons ;
matCovar = matCovar - (m1' * m1);
centres = mvnrnd(m1, matCovar,nbClasses);
centresNew = mvnrnd(m1, matCovar,nbClasses);

nbSteps=0;
dist=zeros(1,nbClasses);
nbVect=zeros(1,nbClasses);
classesDeChaquePoints=ones(1,nbEchantillons);
%classesDeChaquePointsNew=-2*ones(1,nbEchantillons);

while(centres~=centresNew) %for i=1:20
    centres=centresNew;
    nbVect=zeros(nbClasses);
    %classesDeChaquePoints=classesDeChaquePointsNew;
    for j=1:nbEchantillons
        for k=1:nbClasses
            dist(k)=norm(entrees(j,:)-centres(k,:));
        end
        [C,I]=min(dist);
        classesDeChaquePoints(j)=I; %New
        centresNew(I,:)=centresNew(I,:)+entrees(j,:);
        nbVect(I)=nbVect(I)+1;
    end
    for k=1:nbClasses
        if(nbVect(k) ~= 0)
            centresNew(k,:)=centresNew(k,:)/nbVect(k);
        end
    end
    nbSteps=nbSteps+1;
    
    % Plotting the step
    if(optionPause)
        clf;
        c=classesDeChaquePoints;
        if(dimSpace > 3)
            mappedCentres =(centres-repmat(meanEntrees,[nbClasses 1]))*pinv((mapping.M)');
            scatter3(mappedX(:,1),mappedX(:,2),mappedX(:,3),s,c);
            hold on;
            scatter3(mappedCentres(:,1),mappedCentres(:,2),mappedCentres(:,3),[30; 30; 30],[4;4;4],'fill');
        elseif (dimSpace==3)
            scatter3(entrees(:,1),entrees(:,2),entrees(:,3),s,c);
            hold on;
            scatter3(centres(:,1),centres(:,2),centres(:,3),[30; 30; 30],[4;4;4],'fill');
        elseif(dimSpace == 2)     
            scatter(entrees(:,1),entrees(:,2),s,c);
            hold on;
            scatter(centres(:,1),centres(:,2),[30; 30; 30],[4;4;4],'fill');
        end
        pause;
    end
end

end

