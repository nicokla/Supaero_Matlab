function testClassesSupposed = KPlusProchesVoisins...
        ( nbClasses, learningData, learningClasses, testData, testSize, K )
nbVoisins=zeros(testSize,nbClasses);
distances=zeros(size(learningData,1),1);
for i=1:size(testData,1)
    for j=1:size(learningData,1)
        distances(j)=sqrt(sum((testData(i,:) - learningData(j,:)).^2));
    end
    
    [~,indices] = sort(distances);
    for j=1:nbClasses
        nbVoisins(i,j)=sum(learningClasses(indices(1:K))==j);
    end
end
[~,testClassesSupposed]=max(nbVoisins,[],2);

end

