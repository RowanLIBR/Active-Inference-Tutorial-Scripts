%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-- Code/solutions for pencil and paper exercises --%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Supplementary Code for: A Step-by-Step Tutorial on Active Inference Modelling and its 
% Application to Empirical Data

% By: Ryan Smith, Karl J. Friston, Christopher J. Whyte

% Note to readers: be sure to run sections individually

clear
close all
rng('default')


%% Static perception

%priors
D = [.75 .25]';

%likelihood mapping
A = [.8 .2;
    .2 .8];

%observaions
o = [1 0]';

%express generative model in terms of update equations
lns = nat_log(D) + nat_log(A)*o;

%normalise using a softmax function to find posterior
s = (exp(lns)/sum(exp(lns)));

return

%% Dynamic perception

clear

%priors
D = [.5 .5]';

%likelihood mapping
A = [.9 .1;
     .1 .9];
 
%transitions
B = [1 0;
     0 1];

%observations
o{1,1} = [1 0]';
o{1,2} = [0 0]';
o{2,1} = [1 0]';
o{2,2} = [1 0]';
%number of timesteps
T = 2;

%initialise posterior 
for t = 1:T 
    Qs(:,t) = [.5 .5]';
end 

for t = 1:T 
    for tau = 1:T
        %get correct D and B for each time point
        if tau == 1% first timepoint
            lnD = nat_log(D); % past
            lnBs = nat_log(B'*Qs(:,tau+1));% future
        elseif tau == T % last timepoint
             lnD  = nat_log(B'*Qs(:,tau-1));%no contribution from future
        else % 1 > tau > T
             lnD  = nat_log(B*Q(:,tau-1));
             lnBs = nat_log(B'*Q(:,tau+1));
        end 
        %likelihood
        lnAo = nat_log(A*o{t,tau});
        %update equation
        if tau == 1
           lns = .5*lnD + .5*lnBs + lnAo;
        elseif tau == T
            lns = .5*lnD + lnAo;
        end 
        %normalise using a softmax function to find posterior
        Qs(:,tau) = (exp(lns)/sum(exp(lns)));
    end 
end

%% functions

% natural log that replaces zero values with very small values for numerical reasons.
function y = nat_log(x)
y = log(x+.01);
end 
