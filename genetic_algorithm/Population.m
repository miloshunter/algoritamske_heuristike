classdef Population < handle
    % Class for implementing Genetic Algorithm
    properties
        arr = []
        rank = []
        max_fitness
        min_fitness
        mean_fitness
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
        end
        
        function obj =  rank_population(obj)
            tmp_eval = [obj.arr.fitness];
            for cnt_ind = 1:numel(tmp_eval)
                [~, index] = min(tmp_eval);
                obj.rank(cnt_ind) = index;
                tmp_eval(index) = Inf;
            end
        end
    end
    
    
    
end

