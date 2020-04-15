
imageGris = rgb2gray(double(imread('peppers.png'))/255);
% imageGris = imread('../../../Gepshtein and Keller - Images/1.5.01.tiff');
% imageGris=double(imageGris)/255;
sc(imageGris)

%%
n=8;
R=1;
good=ones(size(imageGris));
nbBinsToDiscretizeVar=3;

[ numberOfOnes,...
    numberOfTransitions,...
    isUniform,...
    wherePointwiseLbpIsComputableWithoutArtifacts,...
    lbpLists, ...
    var1, ...
    discretizedVar,...
    angles,...
    discretizedAngles,...
    noAngles] =...
     computeLbpPointwise_informations2(...
      imageGris, n, R, good, nbBinsToDiscretizeVar);

matException=double(wherePointwiseLbpIsComputableWithoutArtifacts);

options.n=n;
options.var=nbBinsToDiscretizeVar;

mat3d_RotInv=numberOfOnes;
[matRGB,matHSV]=...
    plotMat3DColorWithRule( ...
    mat3d_RotInv, matException, @ruleForRotInv,...
    options);
% imshow2(matRGB);
name1='numberOfOnes';
colorbar1D( 0:8, @ruleForRotInv, options, name1);
colorbar1D( 0:8, @ruleForRotInv2, options, name1);
imageGris=rgb2gray(matRGB);
sc(n*imageGris,'hsv');colorbar

matException2=min(matException,1-double(noAngles)); 
mat3d_Uniform=cat(3,numberOfOnes,discretizedAngles);
[matRGB,matHSV]=...
    plotMat3DColorWithRule( mat3d_Uniform, matException2,...
    @ruleForUniform, options );
name1='Number of 1s';
name2='Discretized angles';
colorbar2D(0:n, 0:(n-1), @ruleForUniform, options, name1, name2 );


mat3d_Var=cat(3,numberOfOnes,discretizedVar);
[matRGB,matHSV]=...
    plotMat3DColorWithRule( mat3d_Var, matException,...
     @ruleForVar, options);
name1='Number of 1s';
name2='Discretized Variance';
colorbar2D(0:n, 0:(nbBinsToDiscretizeVar-1),...
    @ruleForVar, options, name1, name2 );









  