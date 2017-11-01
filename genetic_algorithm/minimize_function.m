function y = my_GA_min()

population_number = 10;

% Init population
P = rand(population_number, 1);

% Evaluate population
E = zeros(population_number, 1); % Prealocation for speed
for i = 1:numel(P)
    E(i) = custom_function(P(i));
end


% Check if termination is reached

    % Select solution for next population
    
    % Perform crossover and mutation
    
    % Evaluate population
    
y = min(E);