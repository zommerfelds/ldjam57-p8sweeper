revealed_story = 0

function init_story()
    if depth <= revealed_story then
        -- skip if already seen
        init_level(depth + 1)
        return
    end

    revealed_story = depth

    scene = SCENE_STORY
    mouse_was_ever_released = false
    sfx(5)
end

function update_story()
    local mouse_state = stat(34)
    local mx, my = stat(32), stat(33)

    if mouse_state == 0 then
        mouse_was_ever_released = true
    end

    -- Check if the mouse is clicked within the menu area
    if mouse_state == 1 and mouse_was_ever_released and depth < MAX_LEVEL then
        init_level(depth + 1)
    end
end

story = {
    "why this digging? a faint\n\nhope for more drove your\n\nshovel.",
    "metal glinted.\n\nnot treasure,\n\nbut a broken locket.\n\nlost hope.",
    "air grew heavy.\n\ndamp stone.\n\nsweet, unsettling scent.",
    "a low grind echoed.\n\nthe ground shook.\n\nwas this danger?",
    "i can't help but hope luck\n\nis on my side.\n\nit seems i'll need it.",
    "why did i leave all my\n\nfriends behind? i can't\n\nremember anymore.",
    "you felt a tremor in the\n\ndistance.\n\ndust rained down.\n\nescape felt distant.",
    "a chilling whisper entered\n\nyour mind.\n\ngoing back is no option.",
    "a small chamber appears in\n\nfront of you.\n\ncould this be what you\nseek?",
    "home felt strange.\n\nthe mine... explode it?\n\nshould you have...?\n\nafter some sleep you see\nthe world. it's beatiful.\n\nno more mines."
}

function draw_story()
    cls(1)
    rectfill(0, 0, 127, 127, 9)
    rectfill(9, 9, 118, 118, 13)
    print(story[depth], 13, 40, 0)
    if depth < MAX_LEVEL then
        obprint("depth " .. depth, 37, 15, 0, 9, 2)
        obprint("click to continue", 30, 110, 0, 7, 1)
    else
        obprint("you return", 24, 15, 0, 9, 2)
        obprint("the end", 30, 110, 0, 7, 1)
    end
end