function answer = getSizeOfVariable(variable)

nameVariable=varname(variable);
s=whos(nameVariable);
answer=[s.bytes];

k=1;
n=0;
while(1000*k<answer)
    k=k*1000;
    n=n+3;
end
fprintf('%3.3f * 10^%d bytes\n', answer/k, n);
fprintf('%3.3f * 1024^%d bytes\n', (answer/k)/(1.024^(n/3)), n/3);



