function init_menu()
    scene = SCENE_MENU
    mouse_was_ever_released = false
    sfx(3)
end

function update_menu()
    local mouse_state = stat(34)
    local mx, my = stat(32), stat(33)

    if mouse_state == 0 then
        mouse_was_ever_released = true
    end

    -- Check if the mouse is clicked within the menu area
    if mouse_state == 1 and mouse_was_ever_released then
        init_level()
    end
end

function draw_menu()
    cls(1)
    rectfill(0, 0, 127, 127, 4)
    rectfill(9, 9, 118, 118, 15)
    obprint("p8-sweeper", 25, 15, 0, 9, 2)
    print(
        ""
                .. "- like minesweeper, but\n  diagonals count as 0.5\n\n"
                .. "- \":\" denotes .5,\n  so 2: is 2.5, : is 0.5\n\n"
                .. "- reach the bottom of each\n  level to proceed\n\n"
                .. "- see also manual\n\n"
                .. "- can you reach depth 10?\n\n",
        13, 32, 0
    )
    obprint("click to start", 35, 110, 0, 7, 1)
end