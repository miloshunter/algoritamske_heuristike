function [ P ] = new_sol( P )
%REORDER Summary of this function goes here
%   Detailed explanation goes here
    p1_ind = randi(length(P(1, :)));
    p2_ind = randi(length(P(2, :)));
    
    tmp = P(1, p1_ind);
    P(1, p1_ind) = P(2, p2_ind);
    P(2, p2_ind) = tmp;

end

