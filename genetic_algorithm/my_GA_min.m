function my_GA_min()
    % Choose parameters for running application
    NUM_OF_ITERATIONS = 30; %   How many populations?
    POPULATION_NUMBER = 10; %   Number of individuals in population?
    PLOT = true;            %   Should grapsh be ploted?
    NUMBER_OF_BITS = 8;     %   Bits in Floating number representation?
    VARIABLE_NUMBER = 1;   %   How many variables are in function?
    
    t = 1;
    % Init population
    P(t) = Population(rand(POPULATION_NUMBER, VARIABLE_NUMBER));
    
    % Check if termination is reached
    while (t <= NUM_OF_ITERATIONS)
        %   Evaluate and Rank population
        P(t).evaluate;
        P(t).rank_population;
        fprintf("%d.\t min: %f\t\tmean: %f\t\t x: %f\n", t, P(t).min_fitness, P(t).mean_fitness, P(t).best_individual);
        
        %   Select for next generation
        next_gen = P(t).select_for_next;
        
        % Prepare next generation
        t = t + 1;
        % Perform crossover and mutation
        while length(next_gen) < POPULATION_NUMBER
            % Choose randomly to mutate or cross
            if rand > 0.5
                % Mutation
                element = datasample(next_gen, 1);
                element.mutate;
                
                next_gen = [next_gen, element];
            else
                % Crossover if there are at least 2 elements in array
                if (POPULATION_NUMBER - length(next_gen)) > 2
                    elements = datasample(next_gen, 2);
                    % Do not crossover same elements
                    if elements(1).fitness ~= elements(2).fitness
                        elements = Individual.crossover(elements);
                        next_gen = [next_gen, elements];
                    end
                end
            end
        end
        next_gen = next_gen(1:POPULATION_NUMBER);
        init_gen = zeros(POPULATION_NUMBER);
        for i = 1:POPULATION_NUMBER
            init_gen(i) = next_gen(i).getFloat;
        end
        
        P(t) = Population(init_gen);
        
    end
    
    [min_overall, index] = min([P.min_fitness]);
    best_individual = P(index).best_individual;
    
    fprintf('\nMinimum: %f \tBest individual: %f\n', min_overall, best_individual);
    
    if PLOT 
        plot_figures(P)
    end
    
end

function plot_figures(populations)
    x = 1:(length(populations)-1);

    minimal_fitness = [populations.min_fitness];
    mean_fitness = [populations.mean_fitness];
    best_individuals = [populations.best_individual];

    figure('Name', 'Fitness')
    subplot(2, 1, 1)       % add first plot in 2 x 1 grid
    plot(x, minimal_fitness)
    title('Minimal fitness per population')

    subplot(2, 1, 2)       % add second plot in 2 x 1 grid
    plot(x, mean_fitness)       % plot using + markers
    title('Average population fitness')
    
    figure('Name', 'Individuals')
    plot(x, best_individuals)
    title('Best individuals')
    
    
end

