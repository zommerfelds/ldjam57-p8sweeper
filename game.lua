SCENE_MENU = 0
SCENE_LEVEL = 1
scene = SCENE_MENU

if stat(6) == 'debug' then
  write_to_file = true
end
function log(text)
  if write_to_file then
    printh(text, "mylog.txt")
  end
end

function draw_mouse_sprite()
  local mx, my = stat(32), stat(33)
  spr(32, mx, my)
end

-- Track the previous mouse button state
prev_mouse_state = 0

function _init()
  log("\n--- Starting game! ---\n")
  -- white is transparent
  palt(0B0000000100000000)
  -- Enable the hardware mouse cursor
  poke(0x5f2d, 1)

  if scene == SCENE_LEVEL then
    init_level()
  end
end

function _update()
  if scene == SCENE_MENU then
    update_menu()
  elseif scene == SCENE_LEVEL then
    update_level()
  end
end

function _draw()
  if scene == SCENE_MENU then
    draw_menu()
  elseif scene == SCENE_LEVEL then
    draw_level()
  end

  draw_mouse_sprite()
end