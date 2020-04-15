function [ errorNb, errorRate, confusionMatrix, errorsIndices] = ...
errorsInfos(testClasses, testClassesSupposed )
    errorsIndices=find(testClassesSupposed ~= testClasses);
    %testClassesSupposed(errorsIndices)
    %testClasses(errorsIndices)
    testSize=length(testClasses);
    errorNb=sum(testClassesSupposed ~= testClasses);
    errorRate=errorNb/testSize;
    confusionMatrix=confusionmat(testClasses,testClassesSupposed);
end

