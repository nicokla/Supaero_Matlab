% Code de classification supervisee (recodage de la fonction classify)
clear all;

%% Load data
load fisheriris;

%%%%%%%%%%%%%
%% 0) Loading data and classes
data=meas;
classes = repmat([1 2 3],50,1);
classes=classes(:);%classes=species;
[nbSamples,nbDimensions]=size(data);
nbClasses=max(classes);

% preparing learningData and testData
learningProportion=0.6
[nbClasses, dataClassesForLearning, learningData,learningClasses, testData,testClasses, testSize] = ...
prepareData( data, classes, learningProportion)


%% Visualisation
[mappedX,mapping]=pca(data,2)
s = ones(1,nbSamples)*30;
scatter(mappedX(:,1),mappedX(:,2),s,classes, 'filled');
(mapping.lambda(1)+mapping.lambda(2))/sum(mapping.lambda)

%%%%%%%%%%
%% 1) K-plus proches voisins
K=3;
testClassesSupposed = KPlusProchesVoisins( nbClasses, learningData,learningClasses, ...
testData, testSize, K );
[ errorNb, errorRate, confusionMatrix, errorsIndices] = ...
errorsInfos(testClasses, testClassesSupposed )

%%%%%%%%%
%% 2) Maximum likelihood
testClassesSupposed = maximumLikelihood( nbClasses,...
     dataClassesForLearning, testData, testSize);
[ errorNb, errorRate, confusionMatrix, errorsIndices] = ...
errorsInfos(testClasses, testClassesSupposed )

%%%%%%%%%%%%%
%% 3) Classification lineaire : perceptron



%%%%%%%%%%%%%
%% 4) Réseaux de neurones

[x,t] = iris_dataset;
net = patternnet(10);
net = train(net,x,t);
view(net);
y = net(x);
perf = perform(net,t,y);
classes_true =  vec2ind(t);
classes_guessed = vec2ind(y);
[C,order] = confusionmat(classes_true,classes_guessed); 
plotconfusion(classes_true,classes_guessed);

