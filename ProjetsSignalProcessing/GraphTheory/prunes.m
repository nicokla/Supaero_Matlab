% prunes values for a given bloc of variables
function prunes(rows,columns)
global domains
global solution

% creates a bipartite graph with rows as cells and columns as values
b = zeros(9,9);
n=0;
for i = rows
    for j = columns
        n = n + 1;
        for k = 1:9
            if domains(i,j,k) == 1
                b(n,k) = 1;
            end;
        end;
    end;
end;

n=0;
for i = rows
    for j = columns
        n = n + 1;
        if solution(i,j) == 0
            for k = 1:9
                if domains(i,j,k) == 1
                    % tests each remaining value to see if its assignment has no perfect matching
                    c = b;
                    
                    c(n,:)=0;
                    c(n,k)=1;
                    [val m1 m2]=bipartite_matching(c);
                    if(val<9)
                        domains(i,j,k) = 0; 
                        if sum(domains(i,j,:))==1
                          solution(i,j)=find(domains(i,j,:));
                        end
                    end
                    
                    
                    
                end;
            end;
        end;
    end;
end;

