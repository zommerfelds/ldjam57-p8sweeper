grid_offset_x = 10
grid_offset_y = 10
grid_width = 8
grid_height = 8

-- Define constants for grid values
EMPTY_FIELD = 0
SOLID_FIELD = 1
MINE_FIELD = 2

-- Initialize the grid
grid = {}
for i = 1, grid_width do
  grid[i] = {}
  for j = 1, grid_height do
    grid[i][j] = EMPTY_FIELD -- Default all fields to empty
  end
end

-- Function to place random mines
function place_random_mines(grid, mine_count)
  for _ = 1, mine_count do
    local x, y
    repeat
      x = flr(rnd(grid_width)) + 1
      y = flr(rnd(grid_height)) + 1
    until grid[x][y] == EMPTY_FIELD -- Ensure the field is empty
    grid[x][y] = MINE_FIELD
  end
end

-- Place 10 random mines
place_random_mines(grid, 10)

-- Function to place random solid fields
function place_random_solids(grid, solid_count)
  for _ = 1, solid_count do
    local x, y
    repeat
      x = flr(rnd(grid_width)) + 1
      y = flr(rnd(grid_height)) + 1
    until grid[x][y] == EMPTY_FIELD -- Ensure the field is empty
    grid[x][y] = SOLID_FIELD
  end
end

-- Place 5 random solid fields
place_random_solids(grid, 5)

-- Function to calculate neighboring mines
function calculate_neighbors(grid)
  local neighbors = {}
  for i = 1, grid_width do
    neighbors[i] = {}
    for j = 1, grid_height do
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
  local x = grid_offset_x + (grid_x - 1) * grid_width + 3
  local y = grid_offset_y + (grid_y - 1) * grid_height + 2
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
  rectfill(grid_offset_x, grid_offset_y, grid_offset_x + grid_width * 8, grid_offset_y + grid_height * 8, 15)
  for i = 1, grid_width + 1 do
    local x = grid_offset_x + (i - 1) * grid_width
    for j = 1, grid_height + 1 do
      local y = grid_offset_y + (j - 1) * grid_height
      line(x, grid_offset_y, x, grid_offset_y + grid_width * 8, 5) -- vertical lines
      line(grid_offset_x, y, grid_offset_x + grid_width * 8, y, 5) -- horizontal lines
      if i <= grid_width and j <= grid_height then
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