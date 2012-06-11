module(..., package.seeall)

--------------------------------------------------------------------------------
-- Const
--------------------------------------------------------------------------------

local PLAYER_ANIMS = {
    {name = "left", indexes = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "right", indexes = {8, 7, 8, 9, 8}, sec = 0.25},
}

local PLAYER_MOVE_VALUES = {
    left = -5,
    right = 5
}

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(params)
    ------------------------------
    -- layers
    ------------------------------
    layer = Layer()
    layer:setScene(scene)
    
    hudView = View()
    hudView:setScene(scene)

    ------------------------------
    -- PhysicsWorld
    ------------------------------
    physicsWorld = PhysicsWorld()
    
    ------------------------------
    -- Player
    ------------------------------
    player = SpriteSheet {texture = "samples/assets/actor.png", layer = layer}
    player:setTiledSheets(32, 32)
    player:setSheetAnims(PLAYER_ANIMS)
    player.body = physicsWorld:createBodyFromProp(player)
    player.body:setPos(100, 100)
    player.body:setFixedRotation(true)
    player.body:addEventListener("collision", onPlayerCollision)
    player:playAnim("walkLeft")
    
    ------------------------------
    -- Circle
    ------------------------------
    circle = Graphics {width = 20, height = 20, layer = layer}
    circle:setPenColor(1, 0, 0, 1):fillCircle()
    circle.body = physicsWorld:createBodyFromProp(circle, nil, {shape = "circle"})
    circle.body:setPos(150, 100)
    
    ------------------------------
    -- Floor
    ------------------------------
    floor1 = Mesh.newRect(0, 0, 50, 10, {"#990000", "#330000", 90})
    floor1.body = physicsWorld:createBodyFromProp(floor1, "static")
    floor1.body:setPos(10, 300)
    floor1:setLayer(layer)
    
    floor2 = Mesh.newRect(0, 0, 50, 10, {"#990000", "#330000", 90})
    floor2.body = physicsWorld:createBodyFromProp(floor2, "static")
    floor2.body:setPos(100, 200)
    floor2:setLayer(layer)
    
    ------------------------------
    -- Box
    ------------------------------
    local vw, vh = layer:getViewSize()
    physicsWorld:createRect(0, -1, vw, 1, {type = "static"})
    physicsWorld:createRect(0, vh, vw, 1, {type = "static"})
    physicsWorld:createRect(-1, 0, 1, vh, {type = "static"})
    physicsWorld:createRect(vw, 0, 1, vh, {type = "static"})
    
    ------------------------------
    -- GUI
    ------------------------------
    joystick = Joystick({
        baseTexture = "samples/assets/control_base.png",
        knobTexture = "samples/assets/control_knob.png",
        stickMode = Joystick.MODE_DIGITAL,
    })
    joystick:setLeft(0)
    joystick:setTop(hudView:getViewHeight() - joystick:getHeight())
    joystick:setColor(0.5, 0.5, 0.5, 0.5)
    hudView:addChild(joystick)
    
    abutton = Button({
        upSkin = "samples/assets/button_a.png",
        downSkin = "samples/assets/button_a.png",
        upColor = {red = 1, green = 1, blue = 1, alpha = 1},
        downColor = {red = 0.5, green = 0.5, blue = 0.5, alpha = 1},
    })
    abutton:setColor(0.5, 0.5, 0.5, 0.5)
    abutton:setLeft(hudView:getViewWidth() - abutton:getWidth())
    abutton:setTop(hudView:getViewHeight() - abutton:getHeight())
    abutton:addEventListener("buttonDown", onButtonDown)
    hudView:addChild(abutton)
    
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onStart()
    physicsWorld:start()
end

function onEnterFrame()
    movePlayer()
end

function onButtonDown()
    jumpPlayer()
end

function onPlayerCollision(e)
    if e.phase == "begin" then
        player.jumping = false
    end
end

--------------------------------------------------------------------------------
-- Game Logic
--------------------------------------------------------------------------------

function movePlayer()
    local direction = joystick:getStickDirection()
    local linerX, linerY = player.body:getLinearVelocity()
    linerX = PLAYER_MOVE_VALUES[direction] or 0
    linerX = linerX / 0.06
    
    if linerX ~= 0 then
        player.body:setLinearVelocity(linerX, linerY)
    end
    
    if player:getSheetAnim(direction) and not player:isCurrentAnim(direction) then
        player:playAnim(direction)
    end
end

function jumpPlayer()
    if not player.jumping then
        player.body:setLinearVelocity(0, -10 / 0.06)
        player.jumping = true
    end
end

