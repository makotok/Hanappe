module(..., package.seeall)

local KEY_A = string.byte('a')
local KEY_S = string.byte('s')

function onCreate(params)
    scrollView = ScrollView()
    scrollView:setScene(scene)
    
    for y = 1, 10 do
        for x = 1, 10 do
            local sprite = Sprite {texture = "cathead.png"}
            sprite:setPos((sprite:getWidth() + 10) * (x - 1), (10 + sprite:getHeight()) * (y - 1))
            scrollView:addChild(sprite)
        end
    end
end

function onStart()
end

function onKeyDown(e)
    if e.key == KEY_A then
        local enabled = not scrollView:isHScrollEnabled()
        scrollView:setHScrollEnabled(enabled)
    end
    if e.key == KEY_S then
        local enabled = not scrollView:isVScrollEnabled()
        scrollView:setVScrollEnabled(enabled)
    end
end
