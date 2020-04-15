
% reads a graph as a full adjacency matrix
global graph;
graph = load('dolphin.dat');

% converts into a symmetric square nxn matrix
graph = max(graph, graph');
n=length(graph);

% converts into a sparse matrix
spgraph = sparse(graph);

%finds largest mincut between all pairs of non-adjacent nodes 
%...

