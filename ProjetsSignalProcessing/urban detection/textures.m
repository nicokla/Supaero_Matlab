%%%%%%%%%%%%%%%%
% threshold
m = imread('village.gif');
figure,imshow(double(m)/double(max(m(:))))
m1=uint8(m>70);
%figure,imshow(255*m1);
se=strel('disk',18);
m2=uint8(imclose(m1,se));
subplot(1,2,1),imagesc(m.*m2);
subplot(1,2,2),imagesc(m.*(1-m2));

%%%%%%%%%%%%%%%%
% variance et threshold :

% complexité divisée par (taille_du_cote_de_la_fenetre/2) grâce au chemin
% les contours sont gardés 
UrbanDetec('village.gif','village2.gif',9,200);
UrbanDetec('village.gif','village2.gif',7,120);
UrbanDetec('village.gif','village2.gif',17,140);%UrbanDetect
UrbanDetec('village.gif','village2.gif',25,150);

%%%%%%%%%%%%%%%%%%%%%%%%
% Méthode morphologique
rayon1=5;%3
se=strel('disk',rayon1);
m_top=imtophat(m,se); %m-imopen(m,se);
figure, imagesc(m_top)
m_down = imbothat(m,se);
figure, imagesc(m_down)

% ne garde que les endroits où on est fortement en ville
mini=min(m_top,m_down); 
% on garde les endroits où on est ne serait-ce que faiblement en ville :
% bosses (toits lumineux) et les creux (ombres dans les rues)
maxi=max(m_top,m_down); 
figure, imagesc(mini)
figure, imagesc(maxi)

%imhist(mini)
level_mini = graythresh(mini);
tmini=im2bw(mini,level_mini);
figure, imagesc(tmini);

level_maxi = graythresh(maxi);
tmaxi=im2bw(maxi,level_maxi);
figure, imagesc(tmaxi);


%%%%%%%%%%%%%%%%%%%%%%%
% enleve les zones claires trop petites 
rayon2=3%1 2 3;
se=strel('disk',rayon2);
otmini=imopen(tmini,se);
figure, imagesc(otmini);

%%%%%%%%%%%%%%%%%%%%%%%%%
% enleve le bruit foncé intérieur à la ville
rayon3=3;
se=strel('disk',rayon3);
ctmaxi=imclose(tmaxi,se);
figure, imagesc(ctmaxi);

% enleve le bruit lumineux hors de la ville
rayon4=6;
se=strel('disk',rayon4);
cotmaxi=imopen(ctmaxi,se);
figure, imagesc(cotmaxi);

%%%%%%%%%%%%%%%%%%%%%%%%%

[L,num] = bwlabel(cotmaxi);
%[L2,num2] = bwlabel(otmini);
figure, imagesc(L);
L_selection = L .* otmini;
% figure, imagesc(L_selection);
liste=[];
for i=1:num
    if(length(find(L_selection==i))~=0)
        liste=[liste i];
    end
end
solution=zeros(size(m));
for i=1:length(liste)
    solution = solution | (L==liste(i));
end

figure, imagesc(solution)
figure,imagesc(uint8(solution) .* m);
figure,imagesc(uint8(1-solution) .* m);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UrbanDetect2( 'village.gif', 7, 4, 3, 6 );
UrbanDetect2( 'village.gif', 3, 2, 4, 5 );





