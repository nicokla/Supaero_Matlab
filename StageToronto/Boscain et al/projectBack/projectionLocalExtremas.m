function answer = projectionLocalExtremas( vectOf3dMat )
%vectOf3dMat=image3d(i,j,:)
% vectOf3dMat=v;
Mz=numel(vectOf3dMat);
% v=zeros(Mz,1);
% v2=zeros(Mz+4,1);
% v3=zeros(Mz+3,1);
% temp=0;
% somme=0;
% coeff=0;
% ii=1;
v=reshape(vectOf3dMat,[Mz,1]);
v2=v([(Mz-1),Mz,(1:Mz),1,2]);
% After Mz-1 --> after 1
v3=v2(2:(Mz+4))-v2(1:Mz+3);
%local maximas, at least 2 if the function is not constant :
[r,c,v4]=find(sign(v3(2:(Mz+1)).*v3(3:(Mz+2)))<0);
v5=v2(r+2);
if(isempty(r))
    answer=v(1);
else
    temp=0;
    somme=0;
    for k=1:size(r)
        ii=r(k);
        coeff=abs([1 1 -4 1 1]*v2(ii:(ii+4)));
        temp=temp+coeff*v5(k);
        somme=somme+coeff;
    end
    answer=temp/somme;
end

%    coeffMax=0;
%     for k=1:size(r)
%         ii=r(k);
%         coeff=std(v2(ii:(ii+4)));
%         if(coeff > coeffMax)
%             coeffMax=coeff;
%             answer=v5(k);%v2(ii+2)
%         end
%     end


