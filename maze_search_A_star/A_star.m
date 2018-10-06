
tile_map = Tile_map(8, start, goal);
figure('Name','A*');
            
tile_map = tile_map.add_rect_obstacles(obstacles);
frontier = tile_map.get_neighbours(start);


prev_y = start(2);
prev_x = start(1);

while ~isequal(frontier(1, :), tile_map.goal_tile)
    tile = frontier(1, :);
    y = tile(1);
    x = tile(2);
    frontier = frontier(2:length(frontier), :);
    tile_map.grid(x, y) = 4;
    
    prev_y = y;
    prev_x = x;
    frontier = vertcat(frontier, tile_map.get_neighbours([y x]));
    
    tile_map.draw_grid();
    pause(0.1);
    
    % Calculate cost f(i) = g(i) + h(i)
    g = abs(start(1)-frontier(:, 1)) + abs(start(2)-frontier(:, 2));
    h = abs(goal(1)-frontier(:, 1)) + abs(goal(2)-frontier(:, 2));
    
    f = g + h;
    
    [m, ind] = min(f);
    
    tmp = frontier(1, :);
    frontier(1, :) = frontier(ind, :);
    frontier(ind, :) = tmp;
end

end_tile = frontier(1, :);
path_y = end_tile(1);
path_x = end_tile(2);
while ~isequal([path_y, path_x], tile_map.start_tile)
    tile_map.grid(path_x, path_y) = 6;
    prev_tile = tile_map.came_from(path_x, path_y);
    path_y = prev_tile{1}(2);
    path_x = prev_tile{1}(1);
end
tile_map.grid(path_x, path_y) = 6;
tile_map.draw_grid();


% BFS algorithm

disp("End...")