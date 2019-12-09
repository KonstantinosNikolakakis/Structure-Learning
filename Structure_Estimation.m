%%% Predictive learning for hidden tree-shaped distributions%%% Last revision: Dec 2019 (Matlab R2019b) 
% Author: Konstantinos Nikolakakis, Paper Title: Predictive Learning on Hidden Tree-Structured Ising Models
% Distribution estimation from synthetic data. Data are generated by a tree
% structured Ising model distribution and the noise is generated by a BSC
% with cross-over probability q in(0, 0.2). We estimate the average error of the marginals and the probability of the small set Total Variation (ssTV) to be less than a possitive number gamma.  
clear;
clc;
close all;
tic
rng('shuffle')

corr_strong=0.8; %correlation of strong edges
corr_weak=0.2;    %correlation of weak edges
alpha=atanh(corr_weak); %parameter alpha
beta=atanh(corr_strong); %parameter beta
total_number_of_samples=10^7;

p=100; %number of variable nodes of the tree

%%% Generate the graph structure and the corresponding adjacency matric %%%
Structure_Type=1; % Choose 1 to generate a TREE or 0 to generate a CHAIN
[parent_node,child_node,adjacency]=Structure_Generator(Structure_Type,p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Print the graphical model %%%
[ Tree,Cost1 ] =  UndirectedMaximumSpanningTree (adjacency );
bg1 = biograph(Tree); %'biograph' requires Bioinformatics Toolbox
get(bg1.nodes,'ID');
view(bg1);
[row,col] = find(Tree);
G = digraph(row,col);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Set the strength of edges %%%
theta=zeros(p,p);
for k=1:p   
    if parent_node(k)~=0
        if mod(parent_node(k),2) == 1
            theta(child_node(k),parent_node(k))=alpha;
        else
            theta(child_node(k),parent_node(k))=beta;
        end
    end
end
theta=theta+theta';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

corr_matrix_true=tanh(theta); %original correlation matrix

%%% Find the pair-wise marginal distributions %%%
E=corr_matrix_true; 
Conditional_Prob=zeros(size(E));
Conditional_Prob(E~=0)=(1+E(E~=0))/2; %evalute the probability p(X_i * X_j=+1), the latter is equivalent with the conditional probability p(X_i= X_j | X_j)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Generate synthetic data for the underlying Markov model %%%
% The product variables X_i * X_j are independet for all the edges (i,j)
samples=Samples_Generator(total_number_of_samples,p,child_node,parent_node,Conditional_Prob);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            


%Estimate the correlation matrix
Corr_matrix_estimate=samples'*samples/total_number_of_samples;
           
runs=100; % Monte-Carlo averaging
N=total_number_of_samples/runs;

qvalues=46;
qcounter=0;
qmax=0.45;
qstep=0.01;

batch_size=1000;
number_of_mismatched_edges=zeros(length(0.00:qstep:qmax),length(batch_size:batch_size:N));
prob_of_missing_at_least_one_edge=zeros(length(0.00:qstep:qmax),length(batch_size:batch_size:N));

for q=0.00:qstep:qmax
    toc
    qcounter=qcounter+1;
    noise=ones(total_number_of_samples,p); % Initialize the multiplicative binary noise 
    noise(q*ones(total_number_of_samples,p)>rand(total_number_of_samples,p))=-1; % Generate the noise
    
    %%% Add noise to the data %%%%
    noisy=noise.*samples;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ncounter=0;
    for n=batch_size:batch_size:N
        ncounter=ncounter+1;
        % Estimate the average number of mismatched edges and the probability of incorrect recovery through 100 independent runs
        [temp_number_of_mismatched_edges,temp_prob_of_missing_at_least_one_edge] = Monte_Carlo_Iterations_structure_learning(noisy,runs,n,adjacency);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        number_of_mismatched_edges(qcounter,ncounter)=sum(temp_number_of_mismatched_edges);
        prob_of_missing_at_least_one_edge(qcounter,ncounter)=sum(temp_prob_of_missing_at_least_one_edge);
    end
end

visual_representation_structure_learning(prob_of_missing_at_least_one_edge,qstep,qmax,qvalues,N/batch_size,beta,alpha,p);