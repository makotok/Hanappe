----------------------------------------------------------------------------------------------------
-- テストシーンモジュールです.
--
----------------------------------------------------------------------------------------------------

module(..., package.seeall)

-- import
local tiled = require "tiled"
local dungeon = require "dungeon"
local rpg_map = require "libs/rpg_map"
local dungeonParameters = dofile("assets/dungeon/dungeon_data_1.lua")
local DungeonMapGenerator = dungeon.DungeonMapGenerator
local DungeonTiledGenerator = dungeon.DungeonTiledGenerator
local RPGMap = rpg_map.RPGMap
local RPGObject = rpg_map.RPGObject
local RPGMapControlView = rpg_map.RPGMapControlView

--------------------------------------------------------------------------------
-- Function
--------------------------------------------------------------------------------

function createDungeon()
    local dungeonMapGenerator = DungeonMapGenerator(dungeonParameters)
    local dungeonMapData = dungeonMapGenerator:generate()
    local tiledGenerator = DungeonTiledGenerator(dungeonMapData, dungeonParameters)
    local tileMapData = tiledGenerator:generate(dungeonMapData)

    rpgMap = RPGMap()
    rpgMap:setScene(scene)
    rpgMap:loadMapData(tileMapData)

    mapControlView = RPGMapControlView()
    mapControlView:setScene(scene)
    
    playerObject = rpgMap.objectLayer:findObjectByName("Player")
end

function updateMap()
    rpgMap:onUpdate(e)
end

function updatePlayer()
    local direction = mapControlView:getDirection()
    playerObject:walkMap(direction)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    createDungeon()
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

