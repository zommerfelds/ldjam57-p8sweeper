grid_offset_x = 10
grid_offset_y = 10
grid_width = 8
grid_height = 8

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
  for i = 0, 8 do
    local x = grid_offset_x + i * grid_width
    for j = 0, 8 do
      local y = grid_offset_y + j * grid_height
      line(x, grid_offset_y, x, grid_offset_y + grid_width * 8, 5) -- vertical lines
      line(grid_offset_x, y, grid_offset_x + grid_width * 8, y, 5) -- horizontal lines
    end
  end

  for i = 0, 10 do
    draw_number(i, i, i)
  end
end

function draw_number(grid_x, grid_y, number)
  local x = grid_offset_x + grid_x * grid_width + 4
  local y = grid_offset_y + grid_y * grid_height + 2
  sspr(3 * number, 0, 3, 5, x, y)
end