module(..., package.seeall)

-- import
local rpg_map = require "libs/rpg_map"
local RPGMap = rpg_map.RPGMap
local RPGObject = rpg_map.RPGObject
local RPGMapControlView = rpg_map.RPGMapControlView

-- variables
local mapControlView
local rpgMap

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    rpgMap = RPGMap()
    rpgMap:setScene(scene)
    loadRPGMap("map_town.lue")

    mapControlView = RPGMapControlView()
    mapControlView:setScene(scene)
    mapControlView:addEventListener("enter", onEnter)
end

function onStart()
    mapControlView:setVisible(true)
end

function onStop()
    mapControlView:setVisible(false)
end

function onUpdate(e)
    updateMap()
    updatePlayer()
end

function onEnter(e)
    print("Enter!")
end

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

function loadRPGMap(mapName)
    rpgMap:loadLueFile(mapName)
    playerObject = rpgMap.objectLayer:findObjectByName("Player")
end


function updateMap()
    rpgMap:onUpdate(e)
end

function updatePlayer()
    local direction = mapControlView:getDirection()
    playerObject:walkMap(direction)
end
