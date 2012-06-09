module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})

    world = PhysicsWorld()
    
    sprite = Sprite {texture = "samples/assets/cathead.png", layer = layer, width = 64, height = 64}
    body = world:createRectFromProp(sprite)
    body:setPosition(100, 100)
    body:addEventListener("collision", onCollision)
    
    floor = world:createRect(0, 0, layer:getViewWidth(), 1, {type = "static"})
    floor:setPosition(0, layer:getViewHeight())
    --layer:setBox2DWorld(world)
end

function onStart()
    world:start()
end

function onTouchDown(e)
end

function onCollision(e)
    print("hit!", e.phase)
end

