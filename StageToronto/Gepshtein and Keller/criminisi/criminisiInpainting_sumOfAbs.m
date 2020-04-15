function image = criminisiInpainting3(image, good, semiSize, display)
% todo : 1) debug (noir)
% 2) inclure un mex pour l'etape de recherche (output x0,y0)

% mex -setp cpp
% mex bestExemplarHelper.cpp
% clear
% load

%% Loading : image, imageGris, good
% nameFolder='../Gepshtein and Keller - Images/';
% nameFile='rice.bmp';
% [ image, imageGris, good, ~, ~, ~ ] = ...
% getImageAndMask( nameFolder, nameFile, 400 ); % meanSizeSide
% semiSize=7;

%%
fullSize=2*semiSize+1;
% imageGris=sum(image,3);
patch=ones(fullSize)/(fullSize^2);
[Mx,My,Mz]=size(image);

fullyKnown=getFullyKnown(good, fullSize);

dx1=zeros(size(image));
dy1=zeros(size(image));

for i=1:Mz
    [dx1(:,:,i),dy1(:,:,i),~]= gradPerso( good, image(:,:,i), 'sym' );
end



    
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Algorithme

sizeBadInit=sum(sum(1-good));
sizeBad=sizeBadInit;
approxNbSteps = sizeBadInit/((2*semiSize+1)^2)*3;
fprintf('Nb de steps (approx) : %d\n\n',round(approxNbSteps));



etape=0;

tic
while sizeBad ~= 0

%% list
frontiere=frontiereIn(good, ones(3));
list = getList(frontiere);

if(display)
    figure(1), imshow(cat(3,good,frontiere,zeros(size(good))));
    title(num2str(etape));
end

%% gradient
gradXFrontiere=zeros(size(list,1),Mz);
gradYFrontiere=gradXFrontiere;
for i=1:Mz
    gradXFrontiere(:,i)=getEltIndices(dx1,list);
    gradYFrontiere(:,i)=getEltIndices(dy1,list);
end


%% dxFrontiere et dyFrontiere
cc=blur( 1-good, 6, 2, 2);
% imshow(cc);
[ dx, dy ] = grad_sobel( cc );
dxFrontiere=getEltIndices(dx,list);
dyFrontiere=getEltIndices(dy,list);
gradNorm=sqrt(dxFrontiere.^2 + dyFrontiere.^2);
dxFrontiere=dxFrontiere./gradNorm;
dyFrontiere=dyFrontiere./gradNorm;

%% prio2

prio2=zeros(size(list,1),1);
for i=1:Mz
    prio2=prio2+abs(dxFrontiere.*gradYFrontiere(:,i)-...
                    dyFrontiere.*gradXFrontiere(:,i));
%     prio2=max(prio2,abs(dxFrontiere.*gradYFrontiere(:,i)-...
%                     dyFrontiere.*gradXFrontiere(:,i)));
end


%% prio1
optionForEdges=1;
bb=convUsingCconv(good, patch, optionForEdges);
prio1 = getEltIndices(bb, list);

%% prioGlobale, cx, cy
prioGlobale = prio1.*prio2;
[~,indice]=max(prioGlobale);
center=list(indice,:);
cx=center(1);
cy=center(2);

%% dxMin, dxMax, dyMin, dyMax
xmin=max(1,cx-semiSize);
xmax=min(Mx,cx+semiSize);
ymin=max(1,cy-semiSize);
ymax=min(My,cy+semiSize);
dxMin=xmin-cx;
dxMax=xmax-cx;
dyMin=ymin-cy;
dyMax=ymax-cy;
deltaX=dxMin:dxMax;
deltaY=dyMin:dyMax;

%% Finding the best exemplar
goodLogical=logical(good);
x0y0=bestExemplarHelper(image,goodLogical,fullyKnown,...
          cx,cy,dxMin,...
		  dxMax,dyMin,dyMax);
x0=x0y0(1);
y0=x0y0(2);

%% Filling in
for i=deltaX
    for j=deltaY
        if(~good(cx+i,cy+j))
            image(cx+i,cy+j,:)=image(x0+i,y0+j,:);
%             imageGris(cx+i,cy+j)=imageGris(x0+i,y0+j);
            dx1(cx+i,cy+j,:)=dx1(x0+i,y0+j,:);
            dy1(cx+i,cy+j,:)=dy1(x0+i,y0+j,:);
        end
    end
end
good(cx+deltaX,cy+deltaY)=1;

%% Plot
etape=etape+1;

if(display)
    figure(2),imagesc(image); title(num2str(etape));
    drawnow;
end

sizeBad=sum(sum(1-good));
avancement = 1-(sizeBad/sizeBadInit);
fprintf('Etape %d : %3.2f %%\n',etape, 100*avancement);
drawnow

end
toc

sc(image)















