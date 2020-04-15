figure1=[ones(1,3) zeros(1,6)];
figure2=[2 zeros(1,8) 1 zeros(1,8) 0.5 zeros(1,8)];
stem(figure1);
stem(figure2);
% plot(figure1);
yoyo=conv2(figure1,figure2);
stem(yoyo);
der=[-1 0 1];
yoyo2=conv2(figure1,der);
stem(yoyo2)


