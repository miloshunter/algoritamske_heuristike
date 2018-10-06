
tile_map = Tile_map(8, start, goal);
figure('Name','BFS');

        
tile_map = tile_map.add_rect_obstacles(obstacles);
frontier = tile_map.get_neighbours(start);


prev_y = start(1);
prev_x = start(2);

while ~isequal(frontier(1, :), tile_map.goal_tile)
    tile = frontier(1, :);
    y = tile(1);
    x = tile(2);
    frontier = frontier(2:length(frontier), :);
    
    prev_y = y;
    prev_x = x;
    frontier = vertcat(frontier, tile_map.get_neighbours([y x]));
    
    tile_map.draw_grid();
    pause(0.1);
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