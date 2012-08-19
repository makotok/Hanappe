module(..., package.seeall)

--------------------------------------------------------------------------------
-- constraints
--------------------------------------------------------------------------------
local STICK_TO_DIR_MAP = {}
STICK_TO_DIR_MAP["center"] = 0
STICK_TO_DIR_MAP["left"] = RPGSprite.DIR_LEFT
STICK_TO_DIR_MAP["top"] = RPGSprite.DIR_UP
STICK_TO_DIR_MAP["right"] = RPGSprite.DIR_RIGHT
STICK_TO_DIR_MAP["bottom"] = RPGSprite.DIR_DOWN

--------------------------------------------------------------------------------
-- variables
--------------------------------------------------------------------------------

-- player
local player
local playerMoveDir = 0

----------------------------------------------------------------
-- functions
----------------------------------------------------------------

function onCreate(params)
    -- map view load
    -- You might want to read from the params.
    mapLoader = TMXMapLoader()
    mapData = mapLoader:loadFile("rpg_map.tmx")
    mapView = RPGMapView()
    mapView:loadMap(mapData)
    mapView:setScene(scene)
    
    -- player setting
    player = mapView:findPlayerObject()
    player.moveSpeed = 4
    player:addEventListener("moveStarted", onPlayerMoveStarted)
    player:addEventListener("moveFinished", onPlayerMoveFinished)
    player:addEventListener("moveCollision", onPlayerMoveCollision)
    
    -- widget
    view = View()
    view:setScene(scene)
    joystick = Joystick({
        baseTexture = "control_base.png",
        knobTexture = "control_knob.png",
        stickMode = Joystick.MODE_DIGITAL,
    })
    joystick:setLeft(0)
    joystick:setTop(view.viewHeight - joystick:getHeight())
    joystick:setColor(0.8, 0.8, 0.8, 0.8)
    joystick:addEventListener("stickChanged", onStickChanged)
    view:addChild(joystick)
    
    buttonA = Button({
        upSkin = "button_a.png",
        downSkin = "button_a.png",
        upColor = {red = 1, green = 1, blue = 1, alpha = 1},
        downColor = {red = 0.5, green = 0.5, blue = 0.5, alpha = 1},
    })
    buttonA:setLeft(view.viewWidth - buttonA:getWidth() - 10)
    buttonA:setTop(view.viewHeight - buttonA:getHeight() - 10)
    buttonA:setColor(0.8, 0.8, 0.8, 0.8)
    buttonA:addEventListener("buttonDown", onButtonATouchDown)
    view:addChild(buttonA)

end

function onEnterFrame()
    mapView:onEnterFrame()
    player:moveMap(playerMoveDir)
end

function onButtonATouchDown(e)
    
end

function onPlayerMoveStarted(e)
    print("onPlayerMoveStarted")
end

function onPlayerMoveFinished(e)
    print("onPlayerMoveFinished")
end

function onPlayerMoveCollision(e)
    print("onPlayerMoveCollision", e.collisionMapX, e.collisionMapY)
end

function onStickChanged(e)
    playerMoveDir = STICK_TO_DIR_MAP[e.direction]
end
