module(..., package.seeall)

function onCreate()
    -- layer
    layer1 = Layer:new({scene = scene})
    layer2 = Layer:new({scene = scene})
    
    -- sprite
    sprite1 = Sprite:new({texture = "samples/assets/cathead.png", layer = layer1, left = 0, top = 0})
    sprite2 = Sprite:new({texture = "samples/assets/cathead.png", layer = layer2, left = 0, top = sprite1:getBottom()})
    
    -- group
    group = Group:new({width = Application.viewWidth, height = Application.viewHeight})
    group:setPiv(sprite1:getWidth() / 2, sprite1:getHeight(), 0)
    group:setLeft(10)
    group:setTop(10)
    
    group:addChild(sprite1)
    group:addChild(sprite2)
end

function onStart()
    group:moveLoc(50, 50, 0, 3)
    group:moveRot(0, 0, 180, 3)
    group:moveColor(-1, -1, -1, 0, 3)
end


