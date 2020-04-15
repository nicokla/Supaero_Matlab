
% loads a given initial sudoku grid
global solution
solution = load('sudoku_easy.dat')
%solution = load('sudoku_medium.dat')
%solution = load('sudoku_hard.dat')

% initializes domains of 9x9 cells
global domains
domains = ones(9,9,9);

% prunes values for cells already assigned
for i = 1:9
    for j = 1:9
        if solution(i,j) ~= 0
            for k = 1:9
                if k ~= solution(i,j)
                    domains(i,j,k) = 0;
                end;
            end;
        end;
    end;
end;


a=sum(domains,3);
while length( find(a ~= ones(9)) ) ~=0
    sum_temp=sum(domains(:));
    sum_temp_old=sum_temp+1;
     while (sum_temp ~= sum_temp_old & sum_temp>81)
         for i = [1 4 7]
             for j=[1 4 7]    
                prunes(i:i+2,j:j+2);
             end
         end

         for i = 1:9   
             prunes(1:9,i);
         end

         for i = 1:9   
             prunes(i,1:9);
         end
         sum_temp_old=sum_temp;
         sum_temp=sum(domains(:));
     end

     a=sum(domains,3);
     if( length( find(a ~= ones(9)) ) ==0 )
        break
     end
     
     flag=0;
     for i = 1:9
         for j=1:9
             if (a(i,j)>1)%(a(i,j)==0)
                 solution(i,j)=find(domains(i,j,:),1);
                 domains(i,j,:)=0;
                 domains(i,j,solution(i,j))=1;
                 flag=1;
                 break
             end
             if (flag==1)
                 break
             end
         end
         if (flag==1)
             break
         end
     end
    if (flag==0) % si on a pas pu faire de choix
        break
    end

end


if (sum(domains(:)) ~= 81)
    'error not a complete solution!'
else
    solution
end

