function update_menu()
    local mouse_state = stat(34)
    local mx, my = stat(32), stat(33)

    -- Check if the mouse is clicked within the menu area
    if mouse_state == 1 and mx >= 16 and mx <= 111 and my >= 16 and my <= 111 then
        scene = SCENE_LEVEL
        init_level()
    end
end

function draw_menu()
    cls(1)
    rectfill(0, 0, 127, 127, 4)
    rectfill(16, 16, 111, 111, 15)
    obprint("p8-sweeper", 25, 30, 0, 9, 2)
    print("make sure to read the\ninstructions before\nplaying", 20, 64, 0)
    obprint("click to start", 35, 100, 0, 7, 1)
end