function [ ] = UrbanDetect2( name, rayon1, rayon2, rayon3, rayon4 )
m = imread(name);
se=strel('disk',rayon1);
m_top=imtophat(m,se);
m_down = imbothat(m,se);
mini=min(m_top,m_down); 
maxi=max(m_top,m_down); 
level_mini = graythresh(mini);
tmini=im2bw(mini,level_mini);
level_maxi = graythresh(maxi);
tmaxi=im2bw(maxi,level_maxi);

se=strel('disk',rayon2);
otmini=imopen(tmini,se);
figure;
subplot(1,2,1),imagesc(otmini);

se=strel('disk',rayon3);
ctmaxi=imclose(tmaxi,se);
se=strel('disk',rayon4);
cotmaxi=imopen(ctmaxi,se);
subplot(1,2,2),imagesc(cotmaxi);


[L,num] = bwlabel(cotmaxi);
L_selection = L .* otmini;
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
figure;
subplot(1,2,1),imagesc(uint8(solution) .* m);
subplot(1,2,2),imagesc(uint8(1-solution) .* m);

end

