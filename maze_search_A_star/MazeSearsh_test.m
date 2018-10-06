% Define the Obstacles that are used in the Maze search
%   Each row contains one rectangle, define by top-left and bottom-right
%Few examples of obstacles array:

%obstacles = [[3, 2], [3, 6];...
%            [3, 7], [5, 7];];

obstacles = [[2, 4], [3, 4];...
            [4, 3], [5, 5];...
            [3, 7], [6, 7];];
        
        
% Define the size of the maze
maze_size = 8;

% Position of the start and goal tile on the map
start = [3, 6];
goal =  [5, 2];


while 1    
    disp("Please choose the algorithm from the following options:")
    disp("1. Breadth first search")
    disp("2. Greedy best first search")
    disp("3. A* algorithm")
    disp("4. A* with different cost function")
    disp("9. Exit the application")
    clc;
    algorithm = input('Enter the number: ');

    if algorithm == 0
        return
    else
        switch algorithm
            case 1
                BFS
            case 2
                greedy
            case 3
                A_star
            case 4
                A_star_maxH
            otherwise
                return
        end
    end
end





