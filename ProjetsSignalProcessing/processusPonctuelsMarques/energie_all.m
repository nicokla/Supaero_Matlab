function energie = energie_all( R, I, x, y, beta )
energie = 0;
energie2=0;
if x==[]
    return;
end

N=length(x);
R_au_carre=R^2;
for i=1:N
    energie = energie + sigmoid1(...
        energie_simple( R, I, x(i), y(i)  ) , gamma, S );
end
for i = 1:N-1
    for j=i+1:N
        energie2 = energie2 + ( ( (x(i)-x(j))^2 + (y(i)-y(j))^2 ) < 2*R_au_carre ) ;
        % penalisation si recouvrement suffisant, c-a-d distance de - de
        % sqrt(2)*R
    end
end

energie = energie+beta*energie2;

end
