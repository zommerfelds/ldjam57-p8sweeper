EMPTY_FIELD = 0
SOLID_FIELD = 1
MINE_FIELD = 2

grid = {}
visibility = {}
flags = {}
path = {}
flipped = {}

function reset_grid()
    for i = 1, GRID_WIDTH do
        grid[i] = {}
        visibility[i] = {}
        flags[i] = {}
        path[i] = {}
        flipped[i] = {}
        for j = 1, GRID_HEIGHT do
            grid[i][j] = EMPTY_FIELD -- Default all fields to empty
            visibility[i][j] = false -- Default all fields to covered
            flags[i][j] = false -- Default all fields to unflagged
            path[i][j] = false -- Default all fields to not in path
            flipped[i][j] = { x = rnd() > 0.5, y = rnd() > 0.5 } -- Randomize x and y as booleans
        end
    end
end

function is_in_start_area(x, y)
    return (x >= START_X - 1 and x <= START_X + 1)
            and (y >= START_Y and y <= START_Y + 1)
end

function find_random_path(grid)
    local x, y = START_X, START_Y
    path[x][y] = true
    while y < GRID_HEIGHT do
        local moves = {}
        -- Left
        if x > 1 and not path[x - 1][y] and not path[x - 1][y - 1] then
            add(moves, { x - 1, y }) -- more likely to go left
            add(moves, { x - 1, y })
        end
        -- Right
        if x < GRID_WIDTH and not path[x + 1][y] and not path[x + 1][y - 1] then
            add(moves, { x + 1, y }) -- more likely to go right
            add(moves, { x + 1, y })
        end
        -- Down
        if y < GRID_HEIGHT then
            add(moves, { x, y + 1 })
        end

        local next_move = moves[flr(rnd(#moves)) + 1]
        x, y = next_move[1], next_move[2]
        path[x][y] = true -- Mark the path
    end
end

function place_random_mines(grid, mine_count)
    for _ = 1, mine_count do
        local x, y
        repeat
            x = flr(rnd(GRID_WIDTH)) + 1
            y = flr(rnd(GRID_HEIGHT)) + 1
        until grid[x][y] == EMPTY_FIELD and not path[x][y] and not is_in_start_area(x, y)
        grid[x][y] = MINE_FIELD
    end
end

function place_random_solids(grid, solid_count)
    for _ = 1, solid_count do
        local x, y
        repeat
            x = flr(rnd(GRID_WIDTH)) + 1
            y = flr(rnd(GRID_HEIGHT)) + 1
        until grid[x][y] == EMPTY_FIELD and not path[x][y]
        grid[x][y] = SOLID_FIELD
        -- visibility[x][y] = true
    end
end

function calculate_neighbors(grid)
    local neighbors = {}
    for i = 1, GRID_WIDTH do
        neighbors[i] = {}
        for j = 1, GRID_HEIGHT do
            -- Maybe we should do this in a separate function...
            if is_in_start_area(i, j) then
                visibility[i][j] = true -- Uncover the start area
            end

            local count = 0
            -- Check all adjacent cells
            for dx = -1, 1 do
                for dy = -1, 1 do
                    local ni = i + dx
                    local nj = j + dy
                    if ni >= 1 and ni <= GRID_WIDTH and nj >= 1 and nj <= GRID_HEIGHT
                            and (dx != 0 or dy != 0) then
                        if grid[ni][nj] == MINE_FIELD then
                            if dx == 0 or dy == 0 then
                                count += 1 -- Directly adjacent
                            else
                                count += 0.5 -- Diagonal
                            end
                        end
                    end
                end
            end
            neighbors[i][j] = count
        end
    end
    return neighbors
end

function generate_level(level)
    GRID_WIDTH = ({ 7, 7, 9, 9, 11, 11, 13, 13, 14 })[level]
    GRID_HEIGHT = ({ 7, 8, 9, 10, 11, 12, 13, 13, 13 })[level]
    CELL_WIDTH = 8
    CELL_HEIGHT = 8
    GRID_OFFSET_X = (128 - GRID_WIDTH * CELL_WIDTH - 1) / 2
    GRID_OFFSET_Y = (128 - GRID_HEIGHT * CELL_HEIGHT - 1) / 2
    START_X = flr((GRID_WIDTH + 1) / 2)
    START_Y = 1

    reset_grid()
    find_random_path(grid)
    place_random_mines(grid, GRID_WIDTH * GRID_HEIGHT * 0.26)
    place_random_solids(grid, GRID_WIDTH * GRID_HEIGHT * 0.12)
    neighbor_counts = calculate_neighbors(grid)
end