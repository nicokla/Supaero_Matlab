function [ testClassesSupposed ] = maximumLikelihood( nbClasses,...
dataClassesForLearning, testData, testSize)
    nbDimensions=size(testData,2);
    moyennes=zeros(nbClasses,nbDimensions);
    matricesDeCovariance=zeros(nbDimensions,nbDimensions,nbClasses);
    proba=zeros(testSize,nbClasses);
    for i=1:nbClasses
        moyennes(i,:)=mean(dataClassesForLearning{i});
        matricesDeCovariance(:,:,i)=cov(dataClassesForLearning{i});
        proba(:,i)=mvnpdf(testData,moyennes(i,:),matricesDeCovariance(:,:,i));
    end
    [~,testClassesSupposed]=max(proba,[],2);
end

