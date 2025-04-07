-- values for win_state:
PLAYING = 0
GAME_OVER = 1
WIN = 2

MAX_LEVEL = 8

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

function get_background_tile_full(rand)
    return 19 + min(rand * 20, 9)
end

function get_background_tile_empty(rand)
    return 35 + min(rand * 8, 4)
end

function init_level(opt_depth)
    scene = SCENE_LEVEL
    sfx(0)

    win_state_time = 0
    win_state = PLAYING
    prev_mouse_state = 0
    opening_time = time()
    if opt_depth then
        depth = opt_depth
    else
        depth = 1
    end

    if scene == SCENE_LEVEL then
        generate_level(depth)
    end

    random_background = {}
    for x = 0, 127, CELL_WIDTH do
        for y = 0, 127, CELL_HEIGHT do
            random_background[x .. y] = get_background_tile_full(rnd())
        end
    end
    for x = GRID_OFFSET_X + CELL_WIDTH * (START_X - 2), GRID_OFFSET_X + CELL_WIDTH * START_X, CELL_WIDTH do
        for y = GRID_OFFSET_Y % CELL_HEIGHT - CELL_HEIGHT, GRID_OFFSET_Y, CELL_HEIGHT do
            random_background[x .. y] = get_background_tile_empty(rnd())
        end
    end
end

function check_win_conditions()
    if win_state != PLAYING then
        return -- already won or lost
    end
    for i = 1, GRID_WIDTH do
        if grid[i][GRID_HEIGHT] == EMPTY_FIELD and visibility[i][GRID_HEIGHT] then
            win_state = WIN
            sfx(4)
            return
        end
    end
end

function update_level()
    local mouse_state = stat(34)
    local mx, my = stat(32), stat(33)

    t = time()
    if GRID_OFFSET_Y > (t - opening_time) * 20 then
        -- super hacky
        if (((t + 1 / 20 - opening_time) * 20) % CELL_HEIGHT) < (((t - opening_time) * 20) % CELL_HEIGHT) then
            sfx(2, 1)
        end
        return
    end

    if win_state == GAME_OVER then
        if mouse_state == 1 and my >= 118 then
            init_menu()
        end
        return
    elseif win_state == WIN then
        if mouse_state == 1 and my >= 118 then
            if depth < MAX_LEVEL then
                init_level(depth + 1)
            else
                depth += 1
            end
        end
        return
    end

    local gx, gy = mouse_to_grid(mx, my)

    -- Left click
    if mouse_state == 1 then
        if gx and gy and not visibility[gx][gy] then
            flags[gx][gy] = false
            -- Check if there is a directly adjacent uncovered cell (only vertical and horizontal)
            local can_uncover = false
            for _, offset in ipairs({ { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }) do
                local nx, ny = gx + offset[1], gy + offset[2]
                if nx >= 1 and nx <= GRID_WIDTH and ny >= 1 and ny <= GRID_HEIGHT then
                    if visibility[nx][ny] and grid[nx][ny] == EMPTY_FIELD then
                        can_uncover = true
                        break
                    end
                end
            end

            if can_uncover then
                visibility[gx][gy] = true -- Uncover the clicked cell

                if grid[gx][gy] == MINE_FIELD then
                    sfx(1)
                    -- reveal all mines
                    win_state = GAME_OVER
                    for x = 1, GRID_WIDTH do
                        for y = 1, GRID_HEIGHT do
                            if grid[x][y] == MINE_FIELD then
                                visibility[x][y] = true
                            end
                        end
                    end
                else
                    sfx(2)
                end
            end
        end
    end

    -- Right click
    if mouse_state == 2 and prev_mouse_state == 0 then
        if gx and gy and not visibility[gx][gy] then
            flags[gx][gy] = not flags[gx][gy] -- Toggle flag state
        end
    end

    prev_mouse_state = mouse_state

    check_win_conditions()
    if win_state_time == nil then
        win_state_time = time()
    end
end

function draw_level()
    cls(1)

    -- Draw the background
    for x = 0, 127, CELL_WIDTH do
        for y = 0, 127, CELL_HEIGHT do
            spr(random_background[x .. y], x, y)
        end
    end

    print("depth: " .. depth, 3, 3, 15)

    -- Draw the beginning of the hole
    for x = GRID_OFFSET_X + CELL_WIDTH * (START_X - 2), GRID_OFFSET_X + CELL_WIDTH * START_X, CELL_WIDTH do
        for y = GRID_OFFSET_Y % CELL_HEIGHT - CELL_HEIGHT, min(GRID_OFFSET_Y, (time() - opening_time) * 20), CELL_HEIGHT do
            spr(random_background[x .. y], x, y)
        end
    end

    if GRID_OFFSET_Y > (time() - opening_time) * 20 then
        return
    end

    line(
        GRID_OFFSET_X + CELL_WIDTH * (START_X - 2), 0,
        GRID_OFFSET_X + CELL_WIDTH * (START_X - 2), GRID_OFFSET_Y, 0
    )
    line(
        GRID_OFFSET_X + CELL_WIDTH * (START_X + 1), 0,
        GRID_OFFSET_X + CELL_WIDTH * (START_X + 1), GRID_OFFSET_Y, 0
    )

    for i = 1, GRID_WIDTH do
        local x = GRID_OFFSET_X + (i - 1) * CELL_WIDTH
        for j = 1, GRID_HEIGHT do
            local y = GRID_OFFSET_Y + (j - 1) * CELL_HEIGHT
            -- Visualize the generated path to the goal.
            --[[if path[i][j] then
                rectfill(x, y, x + CELL_WIDTH, y + CELL_HEIGHT, 6)
            end--]]

            if grid[i][j] == SOLID_FIELD then
                -- rect(x, y, x + CELL_WIDTH, y + CELL_HEIGHT, 0)
                spr(17, x + 1, y + 1, 1, 1, flipped[i][j].x, flipped[i][j].y)
            else
                if visibility[i][j] then
                    if grid[i][j] == MINE_FIELD then
                        spr(16, x + 1, y + 1)
                    else
                        spr(get_background_tile_empty(rand[i][j]), x, y, 1, 1, flipped[i][j].x, flipped[i][j].y)
                        draw_number(i, j, neighbor_counts[i][j])
                    end
                else
                    --rectfill(x, y, x + CELL_WIDTH, y + CELL_HEIGHT, 4)
                    spr(get_background_tile_full(rand[i][j]), x, y, 1, 1, flipped[i][j].x, flipped[i][j].y)
                end
                if flags[i][j] then
                    spr(18, x + 1, y + 1) -- Draw flag sprite
                end
            end
        end
    end

    for i = 1, GRID_WIDTH do
        local x = GRID_OFFSET_X + (i - 1) * CELL_WIDTH
        for j = 1, GRID_HEIGHT do
            local y = GRID_OFFSET_Y + (j - 1) * CELL_HEIGHT

            local explored = visibility[i][j] and grid[i][j] != MINE_FIELD
            local is_rock = grid[i][j] == SOLID_FIELD

            for _, offset in ipairs({ { -1, 0 }, { 0, -1 } }) do
                local ni, nj = i + offset[1], j + offset[2]
                if ni >= 1 and ni <= GRID_WIDTH and nj >= 1 and nj <= GRID_HEIGHT then
                    local explored_neighbor = visibility[ni][nj] and grid[ni][nj] != MINE_FIELD
                    local is_rock_neigbor = grid[ni][nj] == SOLID_FIELD

                    local x1 = x
                    local y1 = y
                    local x2 = x1
                    if nj != j then
                        x1 += 1
                        x2 += CELL_WIDTH - 1
                    end
                    local y2 = y
                    if ni != i then
                        y1 += 1
                        y2 += CELL_WIDTH - 1
                    end

                    -- Draw a line between the two cells
                    if is_rock and is_rock_neigbor then
                        -- skip (keep continuous rock)
                    elseif explored != explored_neighbor or is_rock != is_rock_neigbor then
                        -- black line
                        line(x1, y1, x2, y2, 0)
                    elseif explored or explored_neighbor then
                        -- light line
                        line(x1, y1, x2, y2, 9)
                    end
                end
            end
        end
    end

    line(GRID_OFFSET_X, GRID_OFFSET_Y, GRID_OFFSET_X, GRID_OFFSET_Y + CELL_HEIGHT * GRID_HEIGHT, 9)
    line(GRID_OFFSET_X + CELL_WIDTH * GRID_WIDTH, GRID_OFFSET_Y, GRID_OFFSET_X + CELL_WIDTH * GRID_WIDTH, GRID_OFFSET_Y + CELL_HEIGHT * GRID_HEIGHT, 9)
    line(GRID_OFFSET_X, GRID_OFFSET_Y, GRID_OFFSET_X + CELL_WIDTH * GRID_WIDTH, GRID_OFFSET_Y, 9)
    line(GRID_OFFSET_X, GRID_OFFSET_Y + CELL_HEIGHT * GRID_HEIGHT, GRID_OFFSET_X + CELL_WIDTH * GRID_WIDTH, GRID_OFFSET_Y + CELL_HEIGHT * GRID_HEIGHT, 9)

    local blink = ((time() - win_state_time) * 3) % 2 < 1.2
    -- Toggle visibility every 0.5 seconds
    if win_state == WIN and blink then
        if depth <= MAX_LEVEL then
            obprint("nice", 48, 55, 7, 0, 2)
            obprint("keep digging!", 14, 75, 7, 0, 2)
        else
            obprint("you've done it!", 12, 55, 7, 0, 2)
            obprint("the end...", 30, 75, 7, 0, 2)
        end
    elseif win_state == GAME_OVER and blink then
        obprint("game over!", 25, 55, 7, 0, 2)
    end

    if win_state == WIN and depth <= MAX_LEVEL then
        obprint("click here to continue", 20, 120, 0, 7, 1)
    elseif win_state == GAME_OVER then
        obprint("click here to restart", 20, 120, 0, 7, 1)
    end
end