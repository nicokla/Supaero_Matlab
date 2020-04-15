function [x, y, r] = Init_alea2(xmax, ymax, rmin, rmax, mat, coeff_autour)
    r=rmin+ceil((rmax-rmin)*rand);
    r2=round(coeff_autour*r);
    
%     i=1;
%     ok=0;
%     while(i<20 && ~ok)
%         x = r2 + ceil((xmax - 2*r2)*rand);
%         y = r2 + ceil((ymax - 2*r2)*rand);
%         n=sum(sum(mat(x-r:x+r,y-r:y+r)));
%         ok=(n/((2*r+1)^2)) > 1/4;
%         i=i+1;
%     end
    
    %if i==20
        [xlist, ylist] = find(mat(r2+1:end-r2, r2+1:end-r2));%,1,'first');
        xlist=xlist+r2;
        ylist=ylist+r2;
        taille=length(xlist);
        i=1;
        ok=0;
        while (~ok && i<50)
            k=ceil(rand*taille);
            x=xlist(k);
            y=ylist(k);
            n=sum(sum(mat(x-r:x+r,y-r:y+r)));
        	ok=(n/((2*r+1)^2)) > 5/100;
            i=i+1;
        end
        
    %end
    
    %[x, y] = find(mat(r2+1:end-r2, r2+1:end-r2),1,'first');
    %x=x+r2;
    %y=y+r2;
end

