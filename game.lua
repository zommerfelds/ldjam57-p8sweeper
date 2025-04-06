GRID_WIDTH = 13
GRID_HEIGHT = 13
CELL_WIDTH = 8
CELL_HEIGHT = 8
GRID_OFFSET_X = (128 - GRID_WIDTH * CELL_WIDTH - 1) / 2
GRID_OFFSET_Y = (128 - GRID_HEIGHT * CELL_HEIGHT - 1) / 2

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
place_random_mines(grid, 20)

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

-- Function to convert mouse coordinates to grid coordinates
function mouse_to_grid(mx, my)
  local gx = flr((mx - GRID_OFFSET_X) / CELL_WIDTH) + 1
  local gy = flr((my - GRID_OFFSET_Y) / CELL_HEIGHT) + 1
  if gx >= 1 and gx <= GRID_WIDTH and gy >= 1 and gy <= GRID_HEIGHT then
    return gx, gy
  else
    return nil, nil -- Mouse is outside the grid
  end
end

function draw_mouse_sprite()
  local mx, my = stat(32), stat(33)
  spr(32, mx, my)
end

function log(text)
  printh(text, "mylog.txt")
end

-- Track the previous mouse button state
prev_mouse_state = 0

function _init()
  log("\n--- Starting game! ---\n")
  -- white is transparent
  palt(0B0000000100000000)
  -- Enable the hardware mouse cursor
  poke(0x5f2d, 1)
end

function _update()
  -- Get the current mouse button state
  local mouse_state = stat(34)
  local mx, my = stat(32), stat(33)
  -- Get mouse x and y positions
  local gx, gy = mouse_to_grid(mx, my)

  -- Left click
  if mouse_state == 1 then
    -- and prev_mouse_state == 0 then
    if gx and gy then
      printh("Mouse clicked on grid: (" .. gx .. ", " .. gy .. ")", "mylog.txt")
      flags[gx][gy] = false -- Remove flag if it was set
      visibility[gx][gy] = true -- Uncover the clicked cell
      if grid[gx][gy] == MINE_FIELD then
        -- TODO: Game over logic here (e.g., show game over screen)
        log("Game Over! You clicked on a mine!")
      end
    end
  end

  -- Right click
  if mouse_state == 2 and prev_mouse_state == 0 then
    if gx and gy and not visibility[gx][gy] then
      flags[gx][gy] = not flags[gx][gy] -- Toggle flag state
      printh("Flag toggled on grid: (" .. gx .. ", " .. gy .. ")", "mylog.txt")
    end
  end

  -- Update the previous mouse state
  prev_mouse_state = mouse_state
end

function _draw()
  cls(1)
  rectfill(GRID_OFFSET_X, GRID_OFFSET_Y, GRID_OFFSET_X + GRID_WIDTH * CELL_WIDTH, GRID_OFFSET_Y + GRID_HEIGHT * CELL_HEIGHT, 15)
  for i = 1, GRID_WIDTH + 1 do
    local x = GRID_OFFSET_X + (i - 1) * CELL_WIDTH
    for j = 1, GRID_HEIGHT + 1 do
      local y = GRID_OFFSET_Y + (j - 1) * CELL_HEIGHT
      line(x, GRID_OFFSET_Y, x, GRID_OFFSET_Y + CELL_HEIGHT * GRID_HEIGHT, 5) -- vertical lines
      line(GRID_OFFSET_X, y, GRID_OFFSET_X + CELL_WIDTH * GRID_WIDTH, y, 5) -- horizontal lines
      if i <= GRID_WIDTH and j <= GRID_HEIGHT then
        if grid[i][j] == SOLID_FIELD then
          spr(17, x + 1, y + 1)
        else
          if visibility[i][j] then
            if grid[i][j] == MINE_FIELD then
              spr(16, x + 1, y + 1)
            else
              draw_number(i, j, neighbor_counts[i][j])
            end
          else
            rectfill(x + 1, y + 1, x + CELL_WIDTH - 1, y + CELL_HEIGHT - 1, 4)
            if flags[i][j] then
              spr(18, x + 1, y + 1) -- Draw flag sprite
            end
          end
        end
      end
    end
  end

  draw_mouse_sprite()
end