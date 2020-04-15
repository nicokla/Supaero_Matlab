function k_out = invertKernelForConv( k_in )
% [Mx,My]=size(k_in);
k_out=k_in(end:-1:1, end:-1:1);
end

