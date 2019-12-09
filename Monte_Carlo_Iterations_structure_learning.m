function [temp_number_of_mismatched_edges,temp_prob_of_missing_at_least_one_edge] = Monte_Carlo_Iterations_structure_learning(noisy,runs,n,adjacency)
    temp_number_of_mismatched_edges=zeros(1,runs);
    temp_prob_of_missing_at_least_one_edge=zeros(1,runs);
    parfor iter=1:runs
        Corr_matrix_estimate_noisy=noisy(n*(iter-1)+1:n*(iter),:)'*noisy(n*(iter-1)+1:n*(iter),:)/n;
        [Tree_est_noisy,Cost2] = UndirectedMaximumSpanningTree (Corr_matrix_estimate_noisy);
        Error=nnz(adjacency-Tree_est_noisy)/4;
        temp_number_of_mismatched_edges(iter)=Error/runs;
        if Error~=0
            temp_prob_of_missing_at_least_one_edge(iter)=1/runs;
        end    
    end
end

