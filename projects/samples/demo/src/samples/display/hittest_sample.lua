module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})

    sprite1 = Sprite({texture = "cathead.png", layer = layer, left = 0, top = 0})
    sprite2 = Sprite({texture = "cathead.png", layer = layer, left = 0, top = sprite1:getBottom()})
    sprite3 = Sprite({texture = "cathead.png", layer = layer, left = 0, top = sprite2:getBottom()})
end

function onTouchDown(e)
    --print("touch:", e.idx, e.x, e.y)
    
    -- hanappe hittest 1
    if sprite1:hitTestScreen(e.x, e.y) then
        print("hit sprite1")
    end
    -- moai hittest
    local wx, wy = layer:wndToWorld(e.x, e.y, 0)
    if sprite2:inside(wx, wy, 0) then
        print("hit sprite2")
    end
    -- close scene
    if sprite3:hitTestScreen(e.x, e.y) then
        print("hit sprite3")
        SceneManager:closeScene({animation = "fade"})
    end
end
