function [nbClasses, dataClassesForLearning, learningData,learningClasses, testData,testClasses, testSize] = ...
prepareData( data, classes, learningProportion)
    [nbSamples,nbDimensions]=size(data);
    nbClasses=max(classes);
    dataClasses=cell(nbClasses,1);
    sizeClasses=zeros(nbClasses,1);
    permutations=cell(nbClasses,1);
    sizeClassesForLearning=zeros(nbClasses,1);
    dataClassesForLearning=cell(nbClasses,1);
    dataClassesForTest=cell(nbClasses,1);
    for i=1:nbClasses
        dataClasses{i}=data(classes==i,:);
        sizeClasses(i)=size(dataClasses{i},1);
        permutations{i}=randperm(sizeClasses(i)); % can vary
        sizeClassesForLearning(i)=round(learningProportion*sizeClasses(i));
        dataClassesForLearning{i}=dataClasses{i}(permutations{i}(1:sizeClassesForLearning(i)),:);
        dataClassesForTest{i}=dataClasses{i}(permutations{i}(sizeClassesForLearning(i)+1:sizeClasses(i)),:);
    end
    learningSize=sum(sizeClassesForLearning);%round(learningProportion*nbSamples);
    testSize=nbSamples-learningSize;

    % learningData=zeros(learningSize,nbDimensions);
    % testData=zeros(testSize,nbDimensions);
    learningData=[];
    testData=[];
    learningClasses=[];
    testClasses=[];
    for i=1:nbClasses
        learningData=[learningData; dataClassesForLearning{i}];
        testData=[testData; dataClassesForTest{i}];
        learningClasses=[learningClasses; repmat(i, sizeClassesForLearning(i),1)];
        testClasses=[testClasses; repmat(i, sizeClasses(i)-sizeClassesForLearning(i),1)];
    end
end

