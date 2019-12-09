%%% Structure_Generator creates the graph of the markov model. %%%
%%% Requires: the structure type and the number of nodes
%%% Returns: the tree (parent_node,child_node) and the adjacency matrix of the tree
% Under the choice Structure_Type=1 the graph is a (random) Tree and if Structure_Type=0 then the model is a Markov chain

function [parent_node,child_node,adjacency] = Structure_Generator(Structure_Type,p)
    %%% Generate a single path tree structure (chain) and the corresponding adjacency matric %%%
    child_node=1:p; 
    adjacency=zeros(p);
    
    if Structure_Type==1
        %%%  Tree structured model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        parent_node=zeros(1,p);
        for k=2:p  %Generate a tree randomly
            parent_node(k)=  ceil((k-1)*rand());
        end 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        %%%  Markov chain structured model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        parent_node=0:p-1; 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%% Find the adjacency matrix
    for k=2:p
        adjacency(child_node(k),parent_node(k))=1;
    end    

    adjacency=adjacency'+adjacency;
end

