function [ y1, y2 ] = FastICA( o1, o2 )%, minFinal, maxFinal )
% Si tailles différentes, renvoie une erreur
if((size(o1,1) ~= size(o2,1)) || (size(o1,2) ~= size(o2,2)))
    disp('Error, inputs don''t have the same size.')
    return;
end

% Si on a pas des doubles, il doublise les matrices
if(~ strcmp(class(o1),'double'))
    o1=double(o1);
end
if(~ strcmp(class(o2),'double'))
    o2=double(o2);
end

% Retiens la hauteur et la largeur des matrices pour faire un reshape à la fin
sizeI=size(o1,1);
sizeJ=size(o1,2);

% Mets sous forme de lignes
o1=o1(:)';
o2=o2(:)';

% Variable centrées et de puissance unitaire
o1=o1-mean(o1);
o2=o2-mean(o2);
taille=length(o1);
o1=sqrt(taille)*o1/norm(o1);
o2=sqrt(taille)*o2/norm(o2);

% Blanchiment
mel(1,:)=o1;
mel(2,:)=o2;
covMat = mel*mel'/taille;
[H1,D,H2]=svd(covMat);%eig
M=(D^(-1/2))*H2;
z=M*mel;

% Rotation pour maximiser la valeur absolue du kurtosis (donc la non
% gaussianité)
w1_avant=[1; 0];
w1=rand(2,1);
while(norm(w1-w1_avant) > 1e-6)
    w1_avant=w1;
    y=w1'*z;
    w1= sign(kurtosis2(y))*(mean( z.*(ones(2,1)*((w1'*z).^3)) , 2) - 3*w1);
    w1=w1/norm(w1);
end
y1=w1'*z;
w2=[-w1(2); w1(1)];
y2=-w2'*z;

% Remets sous forme de matrices
y1=reshape(y1,sizeI,sizeJ);
y2=reshape(y2,sizeI,sizeJ);

end

