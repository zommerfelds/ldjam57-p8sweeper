GRID_OFFSET_X = 10
GRID_OFFSET_Y = 10
GRID_WIDTH = 12
GRID_HEIGHT = 12
CELL_WIDTH = 8
CELL_HEIGHT = 8

-- Define constants for grid values
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
place_random_mines(grid, 20)

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
          if ni >= 1 and ni <= 8 and nj >= 1 and nj <= 8 and (dx != 0 or dy != 0) then
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

function draw_number(grid_x, grid_y, number)
  local fnumber = flr(number)
  local x = GRID_OFFSET_X + (grid_x - 1) * CELL_WIDTH + 3
  local y = GRID_OFFSET_Y + (grid_y - 1) * CELL_HEIGHT + 2
  if number == 0 then return end
  if number == 0.5 then
    sspr(3 * 7, 0, 1, 5, x + 1, y) -- draw the half symbol in the middle
    return
  end
  if fnumber != number then
    x -= 1
    sspr(3 * 7, 0, 1, 5, x + 4, y) -- draw the half symbol
  end
  sspr(3 * fnumber, 0, 3, 5, x, y)
end

function _init()
  -- white is transparent
  palt(0B0000000100000000)
end

function _update()
  -- press x for a random colour
  if (btnp(5)) col = 8 + rnd(8)
end

function _draw()
  cls(1)
  --rectfill(0, 0, 127, 127, 2)
  rectfill(GRID_OFFSET_X, GRID_OFFSET_Y, GRID_OFFSET_X + GRID_WIDTH * CELL_WIDTH, GRID_OFFSET_Y + GRID_HEIGHT * CELL_HEIGHT, 15)
  for i = 1, GRID_WIDTH + 1 do
    local x = GRID_OFFSET_X + (i - 1) * CELL_WIDTH
    for j = 1, GRID_HEIGHT + 1 do
      local y = GRID_OFFSET_Y + (j - 1) * CELL_HEIGHT
      line(x, GRID_OFFSET_Y, x, GRID_OFFSET_Y + CELL_HEIGHT * GRID_HEIGHT, 5) -- vertical lines
      line(GRID_OFFSET_X, y, GRID_OFFSET_X + CELL_WIDTH * GRID_WIDTH, y, 5) -- horizontal lines
      if i <= GRID_WIDTH and j <= GRID_HEIGHT then
        if grid[i][j] == MINE_FIELD then
          spr(16, x + 1, y + 1)
        elseif grid[i][j] == SOLID_FIELD then
          spr(17, x + 1, y + 1)
        else
          draw_number(i, j, neighbor_counts[i][j])
        end
      end
    end
  end
end