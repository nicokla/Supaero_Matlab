function y = sigmoid1( x , gamma, S )
%typical values : 
%gamma = 5, S = 150 , x=150;
y = 1-(2 / (1+exp(-gamma*((x/S) - 1))) );
end

