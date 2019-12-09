function visual_representation_structure_learning(prob_of_missing_at_least_one_edge,qstep,qmax,qvalues,points,beta,alpha,p)
    %%% 3D plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [x,y]=meshgrid(1:1:points,0.00:qstep:qmax);
    figure
    mesh(x,y,prob_of_missing_at_least_one_edge(1:qvalues,:))
    xlabel('number of samples $n\times 10^3$','Interpreter','latex')
    zlabel('probability of failure $\delta$','Interpreter','latex')
    ylabel('cross-over probability $q$','Interpreter','latex')
    xlim([1 points])
    ylim([0 qmax])
    zlim([0 1])
    colorbar
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Smoothing by using Splines%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [z,w]=meshgrid(1:0.05:points,0.00:qstep:qmax);
    Zq = interp2(x,y,prob_of_missing_at_least_one_edge(1:qvalues,:),z,w,'spline');
    figure

    Zq(Zq>1)=1;
    Zq(Zq<0)=0;
    mesh(z,w,Zq)
    xlabel('number of samples $n\times 10^3$','Interpreter','latex')
    zlabel('probability of failure $\delta$','Interpreter','latex')
    ylabel('cross-over probability $q$','Interpreter','latex')
    xlim([1 points])
    ylim([0 qmax])
    zlim([0 1])
    colorbar
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Comparison of the simulation and the theoretical bound%%%%%%%%%%%%%
    figure
    x1 = linspace(0, 0.28);
    %The multiplicative constant should be chosen 
    y1 = 1.165*(1-tanh(beta)*(1-2*x1).^4).*(1-2*x1).^(-4)*(1-tanh(beta))^(-2)*(tanh(alpha))^(-2)*log(2*p)/1000;% Closed form expression of the bound
    plot(x1,y1,'r','linewidth',2)
    xlabel('cross-over probability $q$','Interpreter','latex')
    ylabel('number of samples $n\times 10^3$','Interpreter','latex')
    ylim([1 points])
    xlim([0 0.45])
    legend({'$n=c\frac{[1-(1-2q)^4\tanh(\beta)]\log(p/\delta)}{(1-2q)^4(1-\tanh(\beta)^2)\tanh^2(\alpha)}$'},'Interpreter','latex')
    hold on
    pcolor(y,x,prob_of_missing_at_least_one_edge) ;
    colorbar
    hold on
    plot(x1,y1,'r','linewidth',2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

