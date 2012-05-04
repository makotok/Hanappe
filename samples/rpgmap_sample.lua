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
    mapLoader = TMXMapLoader:new()
    mapData = mapLoader:loadFile("samples/assets/rpg_map.tmx")
    mapView = RPGMapView:new("samples/assets/")
    mapView:loadMap(mapData)
    mapView:setScene(scene)
    
    -- player setting
    player = mapView:findPlayerObject()
    player.moveSpeed = 4
    
    -- widget
    widgetLayer = Layer:new({scene = scene})
    joystick = Joystick:new({
        baseTexture = "samples/assets/control_base.png",
        knobTexture = "samples/assets/control_knob.png",
        stickMode = Joystick.MODE_DIGITAL,
        layer = widgetLayer,
    })
    joystick:setLeft(0)
    joystick:setTop(widgetLayer.viewHeight - joystick:getHeight())
    joystick:setColor(0.8, 0.8, 0.8, 0.8)
    joystick:setScene(scene)
    joystick:addEventListener("stickChanged", onStickChanged)
    
end

function onEnterFrame()
    mapView:onEnterFrame()
    player:moveMap(playerMoveDir)
end

function onStickChanged(e)
    playerMoveDir = STICK_TO_DIR_MAP[e.direction]
end
