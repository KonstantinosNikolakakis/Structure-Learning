% The function takes CostMatrix as input and returns the maximum spanning tree T by using Kruskal's Algorithm
% The algorithm requires the underling graph to be connected!
% Requires: The Covariance Matrix (edges' weights)
% Returns: The adjacency matrix and the cost. 
% This algorithm was revised by Konstantinos Nikolakakis, 10/08/2019.

function [ Tree,Cost ] =  UndirectedMaximumSpanningTree (CostMatrix)
% This algorithm was revised by Konstantinos Nikolakakis, 10/08/2019.
p = size (CostMatrix,1); %Number of vertices
EdgeWeights = zeros(nnz(triu(CostMatrix,1)),3); %Initialization of the matrix EdgeWeights
EdgeWeightsCounter = 0;
for i = 1:p
    for j = (i+1):p
        if ((CostMatrix(i,j))~=0)
            EdgeWeightsCounter = EdgeWeightsCounter + 1;
            EdgeWeights(EdgeWeightsCounter,1) = CostMatrix(i,j); % First column of EdgeWeights are the weights
            EdgeWeights(EdgeWeightsCounter,2) = i; % Second and third column are the vertices that the edges connect
            EdgeWeights(EdgeWeightsCounter,3) = j;
        end
    end
end

SortedEdgeWeights = sortrows(EdgeWeights); %Sorts the rows of the matrix EdgeWeights in ascending order based on the elements in the first column.
number_of_edges = size(SortedEdgeWeights,1);  

% We use the Disjoint sets data structures to detect cycle while adding new
% edges. Union by Rank with path compression is implemented here.

% Assign parent pointers to each vertex. Initially each vertex points to 
% itself. Now we have a conceptual forest of n trees representing n disjoint 
% sets 
global ParentPointer ;
ParentPointer(1:p) = 1:p;

% Assign a rank to each vertex (root of each tree). Initially all vertices have the rank zero.
TreeRank(1:p) = 0;

% Visit each edge in the sorted edges array
% If the two end vertices of the edge are in different sets (no cycle), add
% the edge to the set of edges in maximum spanning tree
MSTreeEdges = zeros(number_of_edges,3);
MSTreeEdgesCounter = 0; i = number_of_edges;
while ((MSTreeEdgesCounter < (p-1)) && (i>=1))
%Find the roots of the trees that the selected edge's two vertices belong to. Also perform path compression to avoid cycles.
    
    temproot = SortedEdgeWeights(i,2);
    root1 = FIND_PathCompression(temproot);
  
    temproot = SortedEdgeWeights(i,3);
    root2 = FIND_PathCompression(temproot);
    
    if (root1 ~= root2)
        MSTreeEdgesCounter = MSTreeEdgesCounter + 1;
        MSTreeEdges(MSTreeEdgesCounter,1:3) = SortedEdgeWeights(i,:);
        if (TreeRank(root1)>TreeRank(root2))
            ParentPointer(root2)=root1;
        else
            if (TreeRank(root1)==TreeRank(root2))
               TreeRank(root2)=TreeRank(root2) + 1;
            end
            ParentPointer(root1)=root2;
        end
    end
    i = i - 1;
end

MSTreeEdgesCounter = 0;

Tree(1:p,1:p)=0;
while (MSTreeEdgesCounter < (p-1)) %Generate the adjancency matrix of the MST
    MSTreeEdgesCounter = MSTreeEdgesCounter + 1;
    Tree(MSTreeEdges(MSTreeEdgesCounter,2),MSTreeEdges(MSTreeEdgesCounter,3))=1;
    Tree(MSTreeEdges(MSTreeEdgesCounter,3),MSTreeEdges(MSTreeEdgesCounter,2))=1;
end


Cost = 0;
for i = 1:p
    for j = i+1:p
       if Tree( i,j ) == 1 
          Cost = Cost + CostMatrix( i,j );
       end
    end
end

end

function [parent] = FIND_PathCompression(temproot)

    global ParentPointer;
    ParentPointer(temproot);
    if (ParentPointer(temproot)~=temproot)
        ParentPointer(temproot) = FIND_PathCompression(ParentPointer(temproot));
    end
    parent = ParentPointer(temproot);
end