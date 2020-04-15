function getd( p )
if ~iscell(p)
    path([p '/'],path);
else
    for a=1:length(p)
        path([p{a} '/'],path);
    end
end
