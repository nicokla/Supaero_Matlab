function image = criminisiInpainting4(image, good, semiSize,...
     semiSize2, display, N)
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
delta=(-semiSize):semiSize;

sigma_gradient=0;
sigma_tenseur=0.5;
for i=1:Mz
[dx1(:,:,i),dy1(:,:,i)] = ...
    gradPerso3(image(:,:,i), good, sigma_tenseur,...
        sigma_gradient);
end
% normGrad=sum(sqrt(dx1.^2+dy1.^2),3); %sum of the norms of the grad
% figure(3); sc(normGrad);
% eps=graythresh(normGrad);
% expNormGrad=exp(normGrad);
% sc(expNormGrad)
% hist(expNormGrad(:),100);

%% Could be made faster by using the last histogram to build the current one
% using substraction of the intersection.
histoAll=zeros(Mx,My,N*Mz);
mini=zeros(Mz,1);
maxi=zeros(Mz,1);
for k=1:Mz
    mini(k)=min(min(image(:,:,k)));
    maxi(k)=max(max(image(:,:,k)));
    for i=1:Mx
        for j=1:My
            if(fullyKnown(i,j))
                histoAll(i,j,(k-1)*N+(1:N))=...
                    1/Mz*reshape(getHisto(image(i+delta,j+delta,k),N,...
                    mini(k),maxi(k)),[1,1,N]);
            end
        end
    end
end
histoPatch=zeros(Mz*N,1);


    
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Algorithme

sizeBadInit=sum(sum(1-good));
sizeBad=sizeBadInit;
approxNbSteps = sizeBadInit/((2*semiSize2+1)^2)*3;
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
prio2=1+3*prio2/max(prio2);
% prio2=exp(prio2/eps);

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
% histoPatch=zeros(1,Mz*N);
for k=1:Mz
    histoPatch((k-1)*N+(1:N))=...
        1/Mz*getHisto2( image(xmin:xmax,ymin:ymax,k),N,...
            mini(k),maxi(k),good(xmin:xmax,ymin:ymax) );
end

%% Finding the best exemplar
x0y0=bestExemplarHelper2(image, histoAll, histoPatch,fullyKnown,...
          cx,cy,dxMin,...
		  dxMax,dyMin,dyMax);
x0=x0y0(1);
y0=x0y0(2);

%% Filling in
xmin=max(1,cx-semiSize2);
xmax=min(Mx,cx+semiSize2);
ymin=max(1,cy-semiSize2);
ymax=min(My,cy+semiSize2);
dxMin=xmin-cx;
dxMax=xmax-cx;
dyMin=ymin-cy;
dyMax=ymax-cy;
deltaX=dxMin:dxMax;
deltaY=dyMin:dyMax;
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















