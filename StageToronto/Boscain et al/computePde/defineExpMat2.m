function defineExpMat2( Mx,My,thetaNumber,scheme,a,b,dt )
% La difference avec l'autre est que cette fonction ne load qu'1/8ème des coefficients

% global matricesExponentielles=cell(256,256)
global matricesExponentielles;
M=sqrt(Mx*My);
theta=linspace(0,pi-pi/thetaNumber,thetaNumber);
cosTheta=cos(theta);
sinTheta=sin(theta);
sinSin=sinTheta.^2;
cosCos=cosTheta.^2;
cosSin=cosTheta.*sinTheta;
funBase=@(x) 2*pi*(x-1)/M;

id=sparse(eye(thetaNumber));
mat2=-diag(2*ones(1,thetaNumber))+diag(ones(1,thetaNumber-1),1)+...
    diag(ones(1,thetaNumber-1),-1);
mat2(1,end)=1; mat2(end,1)=1; %mat2=mat2/2;
mat2=sparse(mat2);
if(strcmp(scheme,'schemeArticle'))
    diagOfFreqs=@(k,l) sparse(1:thetaNumber,1:thetaNumber,...
     cosTheta*sin(funBase(k)) + sinTheta*sin(funBase(l)));
    derivOfKl=@(a,b,k,l)0.5*(a*mat2-b*M*(diagOfFreqs(k,l).^2));
elseif(strcmp(scheme,'scheme2'))
    diagOfFreqs=@(k,l)sparse(1:thetaNumber,1:thetaNumber,...
        2*cosCos*(cos(funBase(k)) - 1) + ...
        2*sinSin*(cos(funBase(l)) - 1) + ...
        cosSin*(cos(funBase(k)+funBase(l)) - cos(funBase(k)-funBase(l))));
    derivOfKl=@(a,b,k,l)0.5*(a*mat2+b*M*diagOfFreqs(k,l));
elseif(strcmp(scheme,'scheme3'))
    diagOfFreqs=@(k,l)sparse(1:thetaNumber,1:thetaNumber,...
    2*cosCos*(cos(funBase(k)) - 1) + ...
    2*sinSin*(cos(funBase(l)) - 1) + ...
    2*cosSin*(cos(funBase(k))+cos(funBase(l))-cos(funBase(k)-funBase(l))...
    -1));
    derivOfKl=@(a,b,k,l)0.5*(a*mat2+b*M*diagOfFreqs(k,l));
elseif(strcmp(scheme,'sobel'))
    diagOfFreqs=@(k,l) sparse(1:thetaNumber,1:thetaNumber,...
     cosTheta*(sin(funBase(k))/2 + ...
        sin(funBase(k)+funBase(l))/4 +...
        sin(funBase(k)-funBase(l))/4) +...
     sinTheta*(sin(funBase(l))/2 + ...
        sin(funBase(l)+funBase(k))/4 +...
        sin(funBase(l)-funBase(k))/4)...
     );
    derivOfKl=@(a,b,k,l)0.5*(a*mat2-b*M*(diagOfFreqs(k,l).^2));
end

fprintf('coeff theta : %f\n',a/2);
fprintf('coeff spatial : %f\n',b*M/2);

matricesExponentielles=cell(256,256);
for k=1:Mx
    for l=1:My
        if(k<=Mx/2+1 && l<=My/2+1 && k>=l)
            matricesExponentielles{k,l}=...
              expm(dt*derivOfKl(a,b,k,l));
        end
    end
end












