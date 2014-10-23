----------------------------------------------------------------------------------------------------
-- テストシーンモジュールです.
--
----------------------------------------------------------------------------------------------------

module(..., package.seeall)

-- import
local tiled = require "tiled"
local dungeon = require "dungeon"
local dungeonParameters = dofile("assets/dungeon/dungeon_data_1.lua")
local DungeonMapGenerator = dungeon.DungeonMapGenerator
local DungeonTiledGenerator = dungeon.DungeonTiledGenerator
local TileMap = tiled.TileMap

--------------------------------------------------------------------------------
-- Function
--------------------------------------------------------------------------------

function createDungeon()
    local dungeonMapGenerator = DungeonMapGenerator(dungeonParameters)
    local dungeonMapData = dungeonMapGenerator:generate()
    local tiledGenerator = DungeonTiledGenerator(dungeonMapData, dungeonParameters)
    local tileMapData = tiledGenerator:generate(dungeonMapData)

    layer = flower.Layer()
    layer:setScene(scene)
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setTouchEnabled(true)
    
    tileMap = TileMap()
    tileMap:loadMapData(tileMapData)
    tileMap:setLayer(layer)

    tileMap:addEventListener("touchDown", onTouchDown)
    tileMap:addEventListener("touchUp", onTouchUp)
    tileMap:addEventListener("touchMove", onTouchMove)
    tileMap:addEventListener("touchCancel", onTouchUp)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    createDungeon()
end

function onStart(e)

end

function onUpdate(e)
end

function onTouchDown(e)
    if tileMap.lastTouchEvent then
        return
    end
    tileMap.lastTouchIdx = e.idx
    tileMap.lastTouchWX = e.wx
    tileMap.lastTouchWY = e.wy    
end

function onTouchUp(e)
    if not tileMap.lastTouchIdx then
        return
    end
    if tileMap.lastTouchIdx ~= e.idx then
        return
    end
    tileMap.lastTouchIdx = nil
    tileMap.lastTouchWX = nil
    tileMap.lastTouchWY = nil    
end

function onTouchMove(e)
    if not tileMap.lastTouchIdx then
        return
    end
    if tileMap.lastTouchIdx ~= e.idx then
        return
    end
    
    local moveX = e.wx - tileMap.lastTouchWX
    local moveY = e.wy - tileMap.lastTouchWY
    local left, top = tileMap:getPos()
    left = math.max(math.min(0, left + moveX), -math.max(tileMap:getWidth() - flower.viewWidth, 0))
    top = math.max(math.min(0, top + moveY), -math.max(tileMap:getHeight() - flower.viewHeight, 0))
    tileMap:setPos(left, top)

    tileMap.lastTouchWX = e.wx
    tileMap.lastTouchWY = e.wy
end
