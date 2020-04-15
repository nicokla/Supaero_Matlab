%% Show the three ways we found to include things

%%
addpath(genpath(pwd));


%%
% current=pwd;
other='C:\Program Files\MATLAB\R2015a\toolbox\toolbox_fast_marching\';
% cd(other);
% addpath(genpath(pwd));
% cd(current);
% pwd
addpath(genpath(other));

%%
listeIncludesMe = {'lbp/subFunctions' ...
    'miscellaneous' 'distEtMoyenne' 'lbp'...
    'patchMatch' 'heatEquation' 'gradAndCo' };
for i=1:length(listeIncludesMe)
    getd(['me/' listeIncludesMe{i}]);
end

getd('HigherOrderTVinpainting');
% getd('patchmatch-2.1')
% getd('flann-1.8.4-src/src/matlab');
% getd('inpainting_criminisi2004-master');
getd('me/userInterface');


