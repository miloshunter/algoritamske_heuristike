classdef Population < handle
    % Class for implementing Genetic Algorithm
    properties
        arr = []
        rank = []
        max_fitness
        min_fitness
        mean_fitness
        best_individual
    end
    
    methods
        function out = Population(values)
            for i = 1:length(values)
                out = out.addIndividual(Individual(values(i)));
            end
        end
        
        function obj =  addIndividual(obj, individual)
            obj.arr = [obj.arr, individual];
        end
        
        function obj =  getIndividual(obj, i)
            obj = obj.arr(1, i);
        end
        
        function obj =  evaluate(obj)
            for i = 1:length(obj.arr)
                obj.arr(i).evaluate;
            end
            
            obj.min_fitness = min([obj.arr.fitness]);
            obj.max_fitness = max([obj.arr.fitness]);
            obj.mean_fitness = mean([obj.arr.fitness]);
            
            [~, best_index] = min([obj.arr.fitness]);
            obj.best_individual = obj.arr(best_index).getFloat;
        end
        
        function obj =  rank_population(obj)
            tmp_eval = [obj.arr.fitness];
            for cnt_ind = 1:numel(tmp_eval)
                [~, index] = min(tmp_eval);
                obj.rank(cnt_ind) = index;
                tmp_eval(index) = Inf;
            end
        end
        
        function selected_individuals = select_for_next(obj)
            number = round(length(obj.arr)/2);
            probability = zeros(1, length(obj.arr));
            selected = zeros(1, length(obj.arr));
            
            probability(1) = 1/number;
            for i = 2:length(probability)
                probability(i) = (1-sum(probability))/number;
            end
            probability = 1-probability;
            
            tmp = [];
            i = 0;
            while i < number
                prob = rand();
                [~, index] = min(abs(prob-probability));
                if selected(index) == 0
                    tmp = [tmp, obj.arr(obj.rank(index))];
                    probability(index) = Inf;
                    i = i + 1;
                    selected(index) = 1;
                end
            end
            
            selected_individuals = tmp;
        end
    end
    
    
    
end

