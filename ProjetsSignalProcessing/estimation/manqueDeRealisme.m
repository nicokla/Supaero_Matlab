function y = manqueDeRealisme( nu, alpha )
problemes=zeros(size(nu));

if nu(end) < 1/2
    problemes(end)=1/2 - nu(end);
elseif nu(end) > 5
    problemes(end)=nu(end)-5;
else
    problemes(end)=0;
end
y=sum(alpha.*problemes);

end

