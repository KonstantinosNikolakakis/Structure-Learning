function  samples_f= Samples_Generator(total_number_of_samples,p,child_node,parent_node,Conditional_Prob)
    samples=zeros(total_number_of_samples,p);
    for N=1:total_number_of_samples
            %Generate samples according to the tree structured distribution 
            Prodmatrix=zeros(p);
            for r=2:p
                if rand()<=Conditional_Prob(child_node(r),parent_node(r))
                    Prodmatrix(child_node(r),parent_node(r))=1;
                else
                    Prodmatrix(child_node(r),parent_node(r))=-1;
                end
            end
            Prodmatrix=Prodmatrix+Prodmatrix';
            %Generate a sample for the root which is independent with the products X_i*X_j because E[X_i* X_i * X_j]=0 for all the edges (i,j) 
            samplestemp=zeros(1,p);
            samplestemp(1)=-1;
            if rand()>0.5 %the marginal of the root is uniform
                 samplestemp(1)=1;
            end 
            
            % We generate samples for the remaining p-1 nodes by using the Markov property 
            for k=1:p-1
                I = find(parent_node==k); % find all the children nodes of the parent node k
                samplestemp(I)= samplestemp(k)*Prodmatrix(I,k);
            end    

            samples(N,:)=samplestemp; %store the vector sample
    end
    samples_f=samples;
end

