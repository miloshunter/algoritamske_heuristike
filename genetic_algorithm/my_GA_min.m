function y = my_GA_min()

    t = 1;
    num_of_iterations = 30;
    population_number = 10;
    parameter_number = 1;

    % Init population
    P = rand(population_number, parameter_number);

    % Evaluate population
    %E = zeros(population_number, parameter_number); % Prealocation for speed
    
    E = evaluate_population(P);
    
    %for i = 1:numel(P)
    %    E(i) = custom_function(P(i));
    %end

    % Check if termination is reached
    while (t <= num_of_iterations)
        % Select solution for next population
        %   Rank population
        e_tmp = E(:, :);
        selected_indices = zeros(5, 1);
        
        for cnt_ind = 1:numel(selected_indices)
            [m, index] = min(e_tmp);
            selected_indices(cnt_ind) = index;
            e_tmp(index) = Inf;
        end
        
        % Perform crossover and mutation
        %   Crossover
        cros_and_mut_values = zeros(5, 1);
        cros_and_mut_values(1) = (P(selected_indices(1)) + P(selected_indices(2)))/2;
        cros_and_mut_values(2) = (P(selected_indices(3)) + P(selected_indices(4)))/2;
        
        xmin = 0.8;
        xmax = 1.2;
        rand_factor = xmin+rand(1)*(xmax-xmin);
        cros_and_mut_values(3) = P(selected_indices(5))*rand_factor;
        cros_and_mut_values(4) = P(selected_indices(1))*rand_factor;
        cros_and_mut_values(5) = P(selected_indices(2))*rand_factor;
        new_population = Inf(10, 1);
        
        for cnt = 1:numel(new_population)
            if cnt <= numel(selected_indices)
                new_population(cnt) = P(selected_indices(cnt));
            else
                new_population(cnt) = cros_and_mut_values(cnt - 5);
            end
        end
        
        % Evaluate population
        E = evaluate_population(new_population);
        P = new_population;
        
        [minE, indE] = min(E);
        fprintf("%d.\t min: %f\t\t x: %f\n", t, min(E), P(indE));
        
        t = t + 1;
    end
    
y = min(E);
end


function result = evaluate_population(P)
    result = zeros(numel(P), 1);
    for i_ev = 1:numel(P)
        result(i_ev) = custom_function(P(i_ev));
    end
end