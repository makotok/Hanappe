module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}

    local group = Group {
        layer = layer,
        children = {{
            Sprite {name = "mySprite", texture = "cathead.png", pos = {0, 0}},
            Graphics({size = {100, 100}, top = 128}):fillRect(),
        }},
        color = {0.5, 0.5, 0.5, 1},
        scl = {2, 2, 1},
    }
    
    local mySprite = group:getChildByName("mySprite")
    if mySprite then
        print("Hello my sprite!")
    end
end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToBottom"})
end
