% Discretization, written by M. Hatcher (m.c.hatcher@soton.ac.uk)
% This code shows how to approximate an IID-Normal process using the
% method in Adda and Cooper (2003, Dynamic Economics) as in the notes 
% of Makoto Nakajima (https://makotonakajima.github.io/comp/).

n = 6;  %No. of states
mu_e = 0; %Mean of process
sigma_e = 0.01; %Standard deviation
p(1:n,1) = 1/n;
T_shock = 500;  %Simulation length
N_sim = 10;   %No. of simulations

%Housekeeping
m_i = NaN(n,1); e_i = m_i; e_vec_stack = NaN(N_sim,T_shock);

%Find abscissas and states
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
for i=1:N_sim
    rng(i)
    for t=1:T_shock    
        e_vec_stack(i,t) = randsample(e_i,1);
    end
end

%Plot first simuated series
figure(1)
plot(e_vec_stack(1,1:50)), ylabel('Simulated value'), xlabel('Time'), hold on,

%Sanity check
mean_sim_lower = min( mean(e_vec_stack,2) )
mean_sim_upper = max( mean(e_vec_stack,2) )
sd_sim_lower = min( sqrt( var(e_vec_stack,0,2) ) )
sd_sim_upper = max( sqrt( var(e_vec_stack,0,2) ) )

        
        

    




