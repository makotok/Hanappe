module(..., package.seeall)

--------------------------------------------------------------------------------
-- requires
--------------------------------------------------------------------------------
local RPGMapView    = require "hp/rpg/RPGMapView"
local RPGSprite     = require "hp/rpg/RPGSprite"

--------------------------------------------------------------------------------
-- constraints
--------------------------------------------------------------------------------
local STICK_TO_DIR_MAP          = {}
STICK_TO_DIR_MAP["center"]      = 0
STICK_TO_DIR_MAP["left"]        = RPGSprite.DIR_LEFT
STICK_TO_DIR_MAP["top"]         = RPGSprite.DIR_UP
STICK_TO_DIR_MAP["right"]       = RPGSprite.DIR_RIGHT
STICK_TO_DIR_MAP["bottom"]      = RPGSprite.DIR_DOWN

local A_BUTTON_STYLES = {
    normal = {
        skin = "button_a.png",
        skinColor = {1, 1, 1, 0.8},
    },
    selected = {
        skin = "button_a.png",
        skinColor = {0.5, 0.5, 0.5, 0.8},
    },
    over = {
        skin = "button_a.png",
        skinColor = {0.5, 0.5, 0.5, 0.8},
    },
    disabled = {
        skinColor = "button_a.png",
    },
}

--------------------------------------------------------------------------------
-- variables
--------------------------------------------------------------------------------

-- player
local player
local playerMoveDir = 0

--------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------

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
    
    -- view
    view = View {
        scene = scene
    }
    joystick = Joystick {
        parent = view,
        stickMode = "digital",
        left = 0, bottom = view:getHeight(),
        color = {0.8, 0.8, 0.8, 0.8},
        onStickChanged = onStickChanged,
    }
    abutton = Button {
        parent = view,
        styles = {A_BUTTON_STYLES},
        skinResizable = false,
        onButtonDown = onButtonDown,
        right = view:getWidth() - 10,
        bottom = view:getHeight() - 10,
    }
end

function onEnterFrame()
    mapView:onEnterFrame()
    player:moveMap(playerMoveDir)
end

function onButtonDown(e)
    
end

function onPlayerMoveStarted(e)
    --print("onPlayerMoveStarted")
end

function onPlayerMoveFinished(e)
    --print("onPlayerMoveFinished")
end

function onPlayerMoveCollision(e)
    --print("onPlayerMoveCollision", e.collisionMapX, e.collisionMapY)
end

function onStickChanged(e)
    playerMoveDir = STICK_TO_DIR_MAP[e.direction]
end
