function absolutePath = includeRelativePath( relativePath )
current=pwd;
cd(relativePath);
absolutePath=pwd;
addpath(genpath(absolutePath));
cd(current);


