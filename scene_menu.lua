function update_menu()
    local mouse_state = stat(34)
    local mx, my = stat(32), stat(33)

    -- Check if the mouse is clicked within the menu area
    if mouse_state == 1 then
        scene = SCENE_LEVEL
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
                .. "- \":\" is the same as .5,\n  so 2: is 2.5, : is 0.5\n\n"
                .. "- reach the bottom of each\n  level to proceed\n\n"
                .. "- see also manual\n\n"
                .. "- can you reach depth 10?\n\n",
        13, 32, 0
    )
    --print("\":\" is the same as .5,\nso 2: means 2.5", 16, 66, 0)
    --print("see also manual", 16, 86, 0)
    obprint("click to start", 35, 110, 0, 7, 1)
end