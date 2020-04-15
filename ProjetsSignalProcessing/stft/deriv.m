function dx=deriv(x,t)
n=length(x);

for i=1:n-1
    dx(i)=(x(i)-x(i+1))/(t(i)-t(i+1));
end
dx(n)=dx(n-1);
end