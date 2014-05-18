----------------------------------------------------------------------------------------------------
-- テストシーンモジュールです.
--
----------------------------------------------------------------------------------------------------

module(..., package.seeall)

-- import
local dungeon = require "dungeon"
local dungeonParameters = dofile("assets/dungeon/dungeon_data_1.lua")
local DungeonMapView = dungeon.DungeonMapView
local DungeonMapGenerator = dungeon.DungeonMapGenerator

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

---
-- シーン生成時のイベントハンドラです.
function onCreate(e)
    createLayer()
    createDungeon()
end

---
-- シーン開始時のイベントハンドラです.
function onStart(e)

end

---
-- シーン更新時のイベントハンドラです.
function onUpdate(e)
end

---
-- タッチした時のイベントハンドラです.
function onTouchDown(e)
    print("Recreate Dungeon")
    
    createDungeon()
end

function createLayer()
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setTouchEnabled(true)
    layer:addEventListener("touchDown", onTouchDown)
end

function createDungeon()
    if dungeonMapView then
        dungeonMapView:setLayer(nil)
    end

    dungeonGenerator = DungeonMapGenerator(dungeonParameters)
    dungeonMap = dungeonGenerator:generate()
    dungeonMapView = DungeonMapView(dungeonMap)
    dungeonMapView:setLayer(layer) 
end
