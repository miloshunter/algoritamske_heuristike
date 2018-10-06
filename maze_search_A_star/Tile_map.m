classdef Tile_map < handle
    %TILE_MAP Whole map with obstacles, start tile and goal tile
    %   Values that can be used in Grid:
    %       -   '0' is just regular tile
    %       -   '9999' is an obstacle
    %       -   '2' is Start tile
    %       -   '3' is Goal tile
    %       -   '4' is a visited tile
    %       -   '5' is in frontier
    %       -   '6' path

    properties
        grid           % Contains all grid values
        came_from = cell(8, 8);
        size           % Grid is of a size^2
        start_tile
        goal_tile
    end
    methods
        % Constructor
        function obj = Tile_map(size,start_tile, goal_tile)
            obj.size = size;
            obj.grid = zeros(size, size);
            obj.start_tile = start_tile;
            obj.goal_tile = goal_tile;
            
            disp("Tile map created...")
        end
        
        % Setting up of Obstacles
        % Input - Two coordinates for each rectangular obstacle
        function obj = add_rect_obstacles(obj, obstacles_array)
            number_of_obstacles = length(obstacles_array(:, 1));
            fprintf('Adding %d obstacles\n', number_of_obstacles);
            for i = 1:number_of_obstacles
                obstacle = obstacles_array(i, :);
                for x = obstacle(1):obstacle(3)
                    for y = obstacle(2):obstacle(4)
                        % Obrnuto X i Y
                        obj.grid(x, y) = 9999;
                    end
                end
            end
        end
        
        % Draw grid
        function draw_grid(obj)
           high = 100;   %example
           wide = 100;   %example

           axis equal
           view([90 90])
           hold on;
           for i = 1:obj.size
               for j = 1:obj.size
                   if(obj.grid(i, j) == 0)
                       color = [1 1 1];
                   elseif(obj.grid(i, j) == 9999)
                       color = [0 0 0];
                   elseif(obj.grid(i, j) == 4)
                       color = [.8 .8 .8];
                   elseif(obj.grid(i, j) == 6)
                       color = [.5 .5 1];
                   else
                       color = [.8 .2 .2];
                   end
                   rectangle('Position',...
                       [(i-1)*high (j-1)*wide wide high],...
                       'FaceColor', color);
               end
           end
           text((obj.start_tile(2)-1)*100+high*.4,...
                (obj.start_tile(1)-1)*100+high*.4, 'S')
           text((obj.goal_tile(2)-1)*100+wide*.4,...
                (obj.goal_tile(1)-1)*100+wide*.4, 'T')
           %disp("Draw complete...")
        end
        
        function frontier = get_neighbours(obj, tile)
            % Returns list of neighbours that are not in
            %       frontier, visited or obstacles
            frontier = [];
            y = tile(1);
            x = tile(2);
            if (obj.grid(x, y) ~= 2)
                obj.grid(x, y) = 4;
            end
            
            if (y-1) > 0
                if (obj.grid(x, y-1) == 0)
                    % Regular tile
                    frontier = vertcat(frontier, [ y-1 x]);
                    obj.grid(x, y-1) = 5;
                    obj.came_from(x, y-1) = {[x y]};
                end
            end
            if y+1 <= obj.size
                if (obj.grid(x, y+1) == 0)
                    % Regular tile
                    frontier = vertcat(frontier, [y+1 x]);
                    obj.grid(x, y+1) = 5;
                    obj.came_from(x, y+1) = {[x y]};
                end
            end
            if x-1 > 0
                if (obj.grid(x-1, y) == 0)
                    % Regular tile
                    frontier = vertcat(frontier, [y x-1]);
                    obj.grid(x-1, y) = 5;
                    obj.came_from(x-1, y) = {[x y]};
                end
            end
            if x+1 <= obj.size
                if (obj.grid(min(obj.size, x+1), y) == 0)
                    % Regular tile
                    frontier = vertcat(frontier, [y min(obj.size, x+1)]);
                    obj.grid(x+1, y) = 5;
                    obj.came_from(x+1, y) = {[x y]};
                end
            end
        end
    end

end

