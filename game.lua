grid_offset_x = 10
grid_offset_y = 10
grid_width = 8
grid_height = 8

function draw_number(grid_x, grid_y, number)
  local fnumber = flr(number)
  local x = grid_offset_x + grid_x * grid_width + 3
  local y = grid_offset_y + grid_y * grid_height + 2
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
  for i = 0, 8 do
    local x = grid_offset_x + i * grid_width
    for j = 0, 8 do
      local y = grid_offset_y + j * grid_height
      line(x, grid_offset_y, x, grid_offset_y + grid_width * 8, 5) -- vertical lines
      line(grid_offset_x, y, grid_offset_x + grid_width * 8, y, 5) -- horizontal lines
    end
  end

  for i = 0, 6 do
    draw_number(i, i, i)
  end
  for i = 0, 6 do
    draw_number(6 - i + 1, i, i + 0.5)
  end
end