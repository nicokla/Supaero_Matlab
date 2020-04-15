function [ h ] = computeLbpHistOverOnePatch( lbp, range )
range=(range-0.5);
range = [range (range(end)+1)];
h=histcounts(lbp,range);%,'BinMethod','integers');

