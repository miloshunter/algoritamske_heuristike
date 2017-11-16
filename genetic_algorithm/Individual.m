classdef Individual < handle
    % Container class for my_GA_min
    properties
        value   % -> String
        fitness     % Float that should be minimized
    end
    methods
        % Constructor
        function obj = Individual(val)
          % Gets floating point value between 0 and 1, converts to string
          obj.value = dec2bin(val*255, 8);
        end

        function r = getFloat(obj)
            r = bin2dec(obj.value)/255;
        end
        
        function r = getBinary(obj)
            r = obj.value;
        end
        
        function obj = setBinary(obj, val)
            obj.value = val;
        end
        
        function obj = mutate(obj)
            % Mutation implemented by flipping random bit
            tmp = obj.getBinary;
            place = randi([1, 8], 1);
            if tmp(place) == '0'
                tmp(place) = '1';
            else
                tmp(place) = '0';
            end
            obj = obj.setBinary(tmp);
        end
        
        function obj = evaluate(obj)
            % Mutation implemented by flipping random bit
            obj.fitness = custom_function(obj.getFloat);
        end
        
    end
    methods (Static)
        function out = crossover(in)
            % Mix chromosomes
            cros_point = randi([2, 6], 1);
            tmp1 = in(1).value(1:cros_point);
            tmp2 = in(2).value((cros_point + 1):8);
            tmp_val = bin2dec(strcat(tmp1, tmp2))/255;
            
            out1 = Individual(tmp_val);
            
            tmp1 = in(2).value(1:cros_point);
            tmp2 = in(1).value((cros_point+1):8);
            tmp_val = bin2dec(strcat(tmp1, tmp2))/255;
            
            out2 = Individual(tmp_val);
            
            out = [out1, out2];
        end
    end

end

