----------------------------------------------------------------------------------------------------
-- It is a library to display Tiled Map Editor.(Support:V0.9)
-- http://www.mapeditor.org/
-- 
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- module
local tiled = {}

----------------------------------------------------------------------------------------------------
-- Classes
-- @section Classes
----------------------------------------------------------------------------------------------------

---
-- TileFlag class.
-- @see flower.tiled.TileFlag
tiled.TileFlag = require "flower.tiled.TileFlag"

---
-- TileMap class.
-- @see flower.tiled.TileMap
tiled.TileMap = require "flower.tiled.TileMap"

---
-- Tileset class.
-- @see flower.tiled.Tileset
tiled.Tileset = require "flower.tiled.Tileset"

---
-- TileLayer class.
-- @see flower.tiled.TileLayer
tiled.TileLayer = require "flower.tiled.TileLayer"

---
-- TileObject class.
-- @see flower.tiled.TileObject
tiled.TileObject = require "flower.tiled.TileObject"

---
-- TileObjectGroup class.
-- @see flower.tiled.TileObjectGroup
tiled.TileObjectGroup = require "flower.tiled.TileObjectGroup"

---
-- TileSheetImage class.
-- @see flower.tiled.TileSheetImage
tiled.TileSheetImage = require "flower.tiled.TileSheetImage"

---
-- TileMapImage class.
-- @see flower.tiled.TileMapImage
tiled.TileMapImage = require "flower.tiled.TileMapImage"

---
-- TileLayerRenderer class.
-- @see flower.tiled.TileLayerRenderer
tiled.TileLayerRenderer = require "flower.tiled.TileLayerRenderer"

---
-- IsometricLayerRenderer class.
-- @see flower.tiled.IsometricLayerRenderer
tiled.IsometricLayerRenderer = require "flower.tiled.IsometricLayerRenderer"

---
-- TileObjectRenderer class.
-- @see flower.tiled.TileObjectRenderer
tiled.TileObjectRenderer = require "flower.tiled.TileObjectRenderer"

---
-- TileLayerRendererFactory class.
-- @see flower.tiled.TileLayerRendererFactory
tiled.TileLayerRendererFactory = require "flower.tiled.TileLayerRendererFactory"

---
-- TileObjectRendererFactory class.
-- @see flower.tiled.TileObjectRendererFactory
tiled.TileObjectRendererFactory = require "flower.tiled.TileObjectRendererFactory"


return tiled