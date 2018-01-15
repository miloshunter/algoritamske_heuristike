classdef Individual < handle
    % Container class for my_GA_min
    properties
        value       % -> String
        fitness     % Float that should be minimized
        num_of_bits % Number of bits that are being used
    end
    methods
        % Constructor
        function obj = Individual(val, num_of_bits)
          % Gets floating point value between 0 and 1, converts to string
          obj.value = dec2bin(val*(2^num_of_bits - 1), num_of_bits);
          obj.num_of_bits = num_of_bits;
        end

        function r = getFloat(obj)
            r = double(double(bin2dec(obj.value))/(2^obj.num_of_bits - 1));
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
            place = randi([1, obj.num_of_bits], 1);
            if tmp(place) == '0'
                tmp(place) = '1';
            else
                tmp(place) = '0';
            end
            obj = obj.setBinary(tmp);
        end
        
        function obj = evaluate(obj)
            obj.fitness = double(custom_function(obj.getFloat));
        end
        
    end
    methods (Static)
        function out = crossover(in)
            % Mix chromosomes
            num_of_bits = in(1).num_of_bits;
            cros_point = randi([2, num_of_bits], 1);
            tmp1 = in(1).value(1:cros_point);
            tmp2 = in(2).value((cros_point + 1):num_of_bits);
            tmp_val = bin2dec(strcat(tmp1, tmp2))/(2^num_of_bits-1);
            
            out1 = Individual(tmp_val, num_of_bits);
            
            tmp1 = in(2).value(1:cros_point);
            tmp2 = in(1).value((cros_point+1):num_of_bits);
            tmp_val = bin2dec(strcat(tmp1, tmp2))/(2^num_of_bits-1);
            
            out2 = Individual(tmp_val, num_of_bits);
            
            out = [out1, out2];
        end
    end

end

