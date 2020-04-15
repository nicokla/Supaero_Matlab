load fisheriris;
% meas, species
species_nb = [ones(50,1); 2*ones(50,1); 3*ones(50,1)];

% newff
% feedforwardnet fitnet patternnet cascadeforwardnet
% train
% sim

%%%%%%%%%%%%%%%%%%%%%
%% examples from help

%% help of feedforwardnet :
% [x,t] = simplefit_dataset;
% net = feedforwardnet(10)
% net = train(net,x,t);
% view(net)
% y = net(x);
% perf = perform(net,y,t)

%% help of newff
% [inputs,targets] = simplefitdata;
% net = newff(inputs,targets,20);
% net = train(net,inputs,targets);
% outputs = net(inputs);
% errors = outputs - targets;
% perf = perform(net,outputs,targets)

%% help of train
% x = [0 1 2 3 4 5 6 7 8];
% t = [0 0.84 0.91 0.14 -0.77 -0.96 -0.28 0.66 0.99];
% plot(x,t,'o')
% net = feedforwardnet(10);
% net = configure(net,x,t);
% y1 = net(x)
% plot(x,t,'o',x,y1,'x')
% net = train(net,x,t);
% y2 = net(x)
% plot(x,t,'o',x,y1,'x',x,y2,'*')

%% help of sim
% [x,t] =  house_dataset;
% net = feedforwardnet(10);
% net = train(net,x,t);
% y = net(x);
%y = sim(net,x,xi,ai)
%y = net(x,xi,ai)


%% example plot confusion
% load simpleclass_dataset
% net = patternnet(20);
% net = train(net,simpleclassInputs,simpleclassTargets);
% simpleclassOutputs = sim(net,simpleclassInputs);
% plotconfusion(simpleclassTargets,simpleclassOutputs);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% xor
x = [0 0; 0 1; 1 0; 1 1]';
y = [0; 1; 1; 0]';

net = feedforwardnet([2 1]);
net.trainParam.epochs=50;
net.divideFcn='';
net = train(net,x,y);
sim(net,x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% rond et rand

a=3*rand(1,1000) - 1.5;
b=3*rand(1,1000) - 1.5;
c=[a;b];
c2=complex(a,b);
d=abs(c2)<1;
hold on;
for i = 1:1000
    if d(i)
        scatter(a(i),b(i),40,1.5,'fill')
    else
        scatter(a(i),b(i),40,7.2,'fill')
    end
end

net = feedforwardnet([10 1]);
%net.trainParam.epochs=50;
net.divideFcn='';
net = train(net,c,d);

hold on;
for i = linspace(-1.5,1.5,50)
    for j=linspace(-1.5,1.5,50)
        if sim(net,[i ; j])>0.5
            scatter(i,j,40,1.5,'fill')
        else
            scatter(i,j,40,7.2,'fill')
        end
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% fisher iris
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% image












