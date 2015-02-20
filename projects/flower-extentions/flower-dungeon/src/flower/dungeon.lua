----------------------------------------------------------------------------------------------------
-- ダンジョンを生成する為のライブラリです.
-- ダンジョンとは、以下の要素で構成されます.
--
-- * エリア : ダンジョンの分割エリア.
-- * 部屋 : 分割エリア内の部屋.
-- * 通路 : 部屋と部屋を繋ぐための道.
-- * アイテム : 静的に配置されるアイテムオブジェクト.
-- * オブジェクト : 動的に移動できるオブジェクト.
--
-- 上記の構成要素を特定のアルゴリズムで生成するライブラリを提供します.
----------------------------------------------------------------------------------------------------

-- module
local dungeon = {}

-- initialize
math.randomseed(os.time())

----------------------------------------------------------------------------------------------------
-- Classes
-- @section Classes
----------------------------------------------------------------------------------------------------

---
-- DungeonRect Class.
-- @see flower.dungeon.DungeonRect
dungeon.DungeonRect = require "flower.dungeon.DungeonRect"

---
-- DungeonMap Class.
-- @see flower.dungeon.DungeonMap
dungeon.DungeonMap = require "flower.dungeon.DungeonMap"

---
-- DungeonMapView Class.
-- @see flower.dungeon.DungeonMapView
dungeon.DungeonMapView = require "flower.dungeon.DungeonMapView"

---
-- DungeonMapGenerator Class.
-- @see flower.dungeon.DungeonMapGenerator
dungeon.DungeonMapGenerator = require "flower.dungeon.DungeonMapGenerator"

---
-- DungeonTiledGenerator Class.
-- @see flower.dungeon.DungeonTiledGenerator
dungeon.DungeonTiledGenerator = require "flower.dungeon.DungeonTiledGenerator"

---
-- DungeonArea Class.
-- @see flower.dungeon.DungeonArea
dungeon.DungeonArea = require "flower.dungeon.DungeonArea"

---
-- DungeonRoom Class.
-- @see flower.dungeon.DungeonRoom
dungeon.DungeonRoom = require "flower.dungeon.DungeonRoom"

---
-- DungeonRoad Class.
-- @see flower.dungeon.DungeonRoad
dungeon.DungeonRoad = require "flower.dungeon.DungeonRoad"

---
-- DungeonItem Class.
-- @see flower.dungeon.DungeonItem
dungeon.DungeonItem = require "flower.dungeon.DungeonItem"

---
-- DungeonObject Class.
-- @see flower.dungeon.DungeonObject
dungeon.DungeonObject = require "flower.dungeon.DungeonObject"

return dungeon