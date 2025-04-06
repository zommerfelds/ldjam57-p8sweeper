function _init()
  -- always start on white
  col = 7
end

function _update()
  -- press x for a random colour
  if (btnp(5)) col = 8 + rnd(8)
end

function _draw()
  cls(1)
  circfill(64, 64, 32, col)
end