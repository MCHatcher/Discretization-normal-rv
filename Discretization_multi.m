% Discretization_multi, written by M. Hatcher (m.c.hatcher@soton.ac.uk)
% This code shows how to approximate multiple IID-Normal processes using the
% method in Adda and Cooper (2003, Dynamic Economics) as in the notes 
% of Makoto Nakajima (https://makotonakajima.github.io/comp/).

n = 6;   %No. of states
N_shocks = 21;  %No of shocks to approximate
mu_vec = linspace(-0.5,0.5,N_shocks);  %Means of shock processes
sigma_vec = linspace(0.01,0.1,N_shocks);  %Standard deviations of shock processes
p(1:n,1) = 1/n;
T_sim = 500;   %Simulation length

%Housekeeping
m_i = NaN(n,1); e_i = m_i; e_vec_stack = NaN(N_shocks,T_sim);
states = NaN(n,N_shocks);  %matrices to fill

%Find abscissas and states

for j=1:N_shocks

    mu_e = mu_vec(j);   
    sigma_e = sigma_vec(j);

    for i=1:n-1
        m_i(i) = norminv(i/n)*sigma_e + mu_e;
    
        if i==1
            e_i(i) = mu_e - sigma_e*n*normpdf( (m_i(i)-mu_e)/sigma_e );
        else
            e_i(i) = mu_e - sigma_e*n*( normpdf( (m_i(i)-mu_e)/sigma_e ) -  normpdf( (m_i(i-1)-mu_e)/sigma_e ) );
        end
    end

e_i(n) = mu_e + sigma_e*n*normpdf( (m_i(n-1)-mu_e)/sigma_e );

%Obtain draws
    for t=1:T_sim    
        e_vec_stack(j,t) = randsample(e_i,1);
    end

end

%Plot first and last simuated series
figure(1)
plot(e_vec_stack(1,1:50)), ylabel('Simulated value'), xlabel('Time'), hold on,
plot(e_vec_stack(N_shocks,1:50))

%Sanity checks
mean_sim_lower = min( mean(e_vec_stack,2) )
mean_sim_upper = max( mean(e_vec_stack,2) )
sd_sim_lower = min( sqrt( var(e_vec_stack,0,2) ) )
sd_sim_upper = max( sqrt( var(e_vec_stack,0,2) ) )

        
        

    




