GRID_WIDTH = 13
GRID_HEIGHT = 13
CELL_WIDTH = 8
CELL_HEIGHT = 8
GRID_OFFSET_X = (128 - GRID_WIDTH * CELL_WIDTH - 1) / 2
GRID_OFFSET_Y = (128 - GRID_HEIGHT * CELL_HEIGHT - 1) / 2

EMPTY_FIELD = 0
SOLID_FIELD = 1
MINE_FIELD = 2

-- Initialize the grid
grid = {}
for i = 1, GRID_WIDTH do
    grid[i] = {}
    for j = 1, GRID_HEIGHT do
        grid[i][j] = EMPTY_FIELD -- Default all fields to empty
    end
end

-- Initialize the visibility state of the grid
visibility = {}
for i = 1, GRID_WIDTH do
    visibility[i] = {}
    for j = 1, GRID_HEIGHT do
        visibility[i][j] = false -- Default all fields to covered (not uncovered)
    end
end

-- Initialize the flags state of the grid
flags = {}
for i = 1, GRID_WIDTH do
    flags[i] = {}
    for j = 1, GRID_HEIGHT do
        flags[i][j] = false -- Default all fields to unflagged
    end
end

-- Function to place random mines
function place_random_mines(grid, mine_count)
    for _ = 1, mine_count do
        local x, y
        repeat
            x = flr(rnd(GRID_WIDTH)) + 1
            y = flr(rnd(GRID_HEIGHT)) + 1
        until grid[x][y] == EMPTY_FIELD -- Ensure the field is empty
        grid[x][y] = MINE_FIELD
    end
end

-- Place 10 random mines
place_random_mines(grid, 30)

-- Uncover a 3x3 area at the top middle of the grid
local start_x = flr(GRID_WIDTH / 2)
local start_y = 1
for i = start_x, start_x + 2 do
    for j = start_y, start_y + 2 do
        visibility[i][j] = true
        if grid[i][j] == MINE_FIELD then
            grid[i][j] = EMPTY_FIELD -- Ensure no mines in this area
        end
    end
end

-- Function to place random solid fields
function place_random_solids(grid, solid_count)
    for _ = 1, solid_count do
        local x, y
        repeat
            x = flr(rnd(GRID_WIDTH)) + 1
            y = flr(rnd(GRID_HEIGHT)) + 1
        until grid[x][y] == EMPTY_FIELD -- Ensure the field is empty
        grid[x][y] = SOLID_FIELD
    end
end

-- Place 5 random solid fields
place_random_solids(grid, 20)

-- Function to calculate neighboring mines
function calculate_neighbors(grid)
    local neighbors = {}
    for i = 1, GRID_WIDTH do
        neighbors[i] = {}
        for j = 1, GRID_HEIGHT do
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

-- Calculate neighbors for the current grid
neighbor_counts = calculate_neighbors(grid)