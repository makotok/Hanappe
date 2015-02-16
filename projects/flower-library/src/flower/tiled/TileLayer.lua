----------------------------------------------------------------------------------------------------
-- This class to display a tile layer.
-- Inherit from the Group class is the name of a class that layer.
-- You can also be dynamically added to create a TileLayer.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.core.Group.html">Group</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Group = require "flower.core.Group"

-- class
local TileLayer = class(Group)

---
-- The constructor.
-- @param tileMap TileMap
function TileLayer:init(tileMap)
    TileLayer.__super.init(self)
    self.tileMap = assert(tileMap)
    self.type = "tilelayer"
    self.name = ""
    self.mapWidth = 0
    self.mapHeight = 0
    self.opacity = 0
    self.properties = {}
    self.tiles = {}
    self.tilesetToRendererMap = {}
    self.renderer = nil
    self.rendererFactory = tileMap.layerRendererFactory
end

---
-- Load the layer data.
-- @param data layer data
function TileLayer:loadData(data)
    self.data = data
    self.name = data.name
    self.mapWidth = data.width
    self.mapHeight = data.height
    self.opacity = data.opacity
    self.tiles = data.data
    self.properties = data.properties

    self:setPos(data.x, data.y)
    self:createRenderer()
    self:setVisible(data.visible)
end

---
-- Save the layer data.
-- @return layer data
function TileLayer:saveData()
    local data = self.data or {}
    self.data = data
    data.name = self.name
    data.name = self.name
    data.x = self:getLeft()
    data.y = self:getTop()
    data.width = self.mapWidth
    data.height = self.mapHeight
    data.opacity = self.opacity
    data.encoding = "Lua"
    data.data = self.tiles
    data.visible = self:getVisible()
    data.properties = data.properties
    return data
end

---
-- Create a renderer.
-- There is no need to call directly basically.
-- @return layer data
function TileLayer:createRenderer()
    if not self.renderer then
        self.renderer = self.rendererFactory:newInstance(self)
        self:addChild(self.renderer)
        return self.renderer
    end
end

---
-- Returns the property.
-- @param key key.
-- @return value.
function TileLayer:getProperty(key)
    return self.properties[key]
end

---
-- Returns the property.
-- @param key key.
-- @return value.
function TileLayer:getPropertyAsNumber(key)
    local value = self:getProperty(key)
    if value then
        return tonumber(value)
    end
end

---
-- Returns the gid of the specified position.
-- If is out of range, return nil.
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
-- @return gid.
function TileLayer:getGid(x, y)
    if not self:checkBounds(x, y) then
        return nil
    end
    return self.tiles[y * self.mapWidth + x + 1]
end

---
-- Sets gid of the specified position.
-- If you set the position is out of range to error.
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
-- @param gid global id.
function TileLayer:setGid(x, y, gid)
    if not self:checkBounds(x, y) then
        error("Index out of bounds!")
    end
    self.tiles[y * self.mapWidth + x + 1] = gid

    self:createRenderer()
    self.renderer:setGid(x, y, gid)
end

---
-- Tests whether the position is within the range specified.
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
-- @return True if in the range.
function TileLayer:checkBounds(x, y)
    if x < 0 or self.mapWidth <= x then
        return false
    end
    if y < 0 or self.mapHeight <= y then
        return false
    end
    return true
end

return TileLayer