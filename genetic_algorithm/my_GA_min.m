function y = my_GA_min()

    t = 1;
    num_of_iterations = 15;
    population_number = 10;
    parameter_number = 1;

    % Init population
    P(t) = Population(rand(population_number, parameter_number));

    % Evaluate population
    P(t).evaluate;
    P(t).rank_population;
    
    % Check if termination is reached
    while (t <= num_of_iterations)
        % Select solution for next population
        %   Rank population
        P(t).evaluate;
        
        fprintf("%d.\t min: %f\t\tmean: %f\t\t x: %f\n", t, P(t).min_fitness, P(t).mean_fitness, P(t).best_individual);
        P(t).rank_population;
        next_gen = P(t).select_for_next;
        
        % Prepare next generation
        t = t + 1;
        % Perform crossover and mutation
        while length(next_gen) < population_number
            if rand > 0.5
                %mutation
                element = datasample(next_gen, 1);
                element.mutate;
                
                next_gen = [next_gen, element];
            else
                %crossover
                if (population_number - length(next_gen)) > 3
                    elements = datasample(next_gen, 2);
                    if elements(1).fitness ~= elements(2).fitness
                        elements = Individual.crossover(elements);
                        next_gen = [next_gen, elements];
                    end
                end
            end
        end
        next_gen = next_gen(1:population_number);
        init_gen = zeros(population_number);
        for i = 1:population_number
            init_gen(i) = next_gen(i).getFloat;
        end
        
        P(t) = Population(init_gen);
        
    end
    
    [min_overall, index] = min([P.min_fitness])
    best_individual = P(index).best_individual
    
end

