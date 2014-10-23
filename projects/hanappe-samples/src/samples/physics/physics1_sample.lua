module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------
function onCreate(params)
    physicsWorld = PhysicsWorld()
    
    gameLayer = Layer {
        scene = scene,
        touchEnabled = true,
        -- box2DWorld = physicsWorld,
    }
    
    -- wall
    local viewWidth, viewHeight = gameLayer:getViewSize()
    wallLeft    = physicsWorld:createRect(0, 0, 1, viewHeight, {type = "static"})
    wallTop     = physicsWorld:createRect(0, 0, viewWidth, 1, {type = "static"})
    wallRight   = physicsWorld:createRect(viewWidth, 0, 1, viewHeight, {type = "static"})
    wallBottom  = physicsWorld:createRect(0, viewHeight, viewWidth, 1, {type = "static"})
end

function onStart()
    physicsWorld:start()
end

function onStop()
    physicsWorld:stop()
end

function onTouchDown(e)
    local wx, wy = gameLayer:wndToWorld(e.x, e.y, 0)
    local prop = gameLayer:getPartition():propForPoint(wx, wy, 0)
    if prop and prop.body then
        destroyCathead(prop)
    else
        createCathead(wx, wy)
    end
end

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

function createCathead(x, y)
    local sprite = Sprite {texture = "cathead.png", size = {64, 64}, layer = gameLayer}
    sprite.body = physicsWorld:createBodyFromProp(sprite)
    sprite.body:setPos(x, y)
end

function destroyCathead(sprite)
    sprite:dispose()
    sprite.body:destroy()
end

