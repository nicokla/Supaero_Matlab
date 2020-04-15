function h = hanning2D( size )
h1 = hann(size);
h = h1 * h1';
h=h/sum(sum(h));
% surf(h)


