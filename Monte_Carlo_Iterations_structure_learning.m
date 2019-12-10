%%% Evaluates the probability of estimating incorrectly the original tree and the average number of mismatched edges for a fixed value of q by using n number of (noisy) samples through runs=500 independent runs
%Requires: Synthetic Samples noisy, the number of samples n, the adjacency matrix of the original Tree, and the number of iterations (runs).
%Returns: The estimated error probability and the average number of mismatched edges.
function [temp_number_of_mismatched_edges,temp_prob_of_missing_at_least_one_edge] = Monte_Carlo_Iterations_structure_learning(noisy,runs,n,adjacency)
    temp_number_of_mismatched_edges=zeros(1,runs);
    temp_prob_of_missing_at_least_one_edge=zeros(1,runs);
    parfor iter=1:runs
        Corr_matrix_estimate_noisy=noisy(n*(iter-1)+1:n*(iter),:)'*noisy(n*(iter-1)+1:n*(iter),:)/n; % Evaluate the correlation matrix
        [Tree_est_noisy,Cost2] = UndirectedMaximumSpanningTree (Corr_matrix_estimate_noisy); % Estimated the structure
        Error=nnz(adjacency-Tree_est_noisy)/4; % Counts the number of mismatched edges
        temp_number_of_mismatched_edges(iter)=Error/runs; % Store the percentage to evaluate the average number of mismatched edges
        if Error~=0 % at least one edge was missed
            temp_prob_of_missing_at_least_one_edge(iter)=1/runs; % Store the percentage to evaluate the probability of incorrect recovery
        end    
    end
end

