function u= Heat_Equation( u0, nit, tau )

u=u0;
%tau=0.1;
%figure(1); colormap(gray);
%title(sprintf('Equation chaleur : Iteration %i/%i',i-1,nit));
for i=1:nit
%     imagesc(u);%axis equal    
    u=u+tau*laplacien(u);
    %pause;
end
% figure; colormap(gray);imagesc(u);axis equal
% title(sprintf('Equation chaleur : Iteration %i/%i',i-1,nit));


end

