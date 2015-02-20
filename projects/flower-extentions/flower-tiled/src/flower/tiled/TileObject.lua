----------------------------------------------------------------------------------------------------
-- This class holds information TileObject.
-- If you can see the tile, creating and showing a renderer.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.Group.html">Group</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Group = require "flower.Group"

-- class
local TileObject = class(Group)

---
-- The constructor.
-- @param tileMap TileMap
function TileObject:init(tileMap, objectData)
    TileObject.__super.init(self)
    self.tileMap = assert(tileMap)
    self.name = ""
    self.type = ""
    self.shape = ""
    self.gid = nil
    self.properties = {}
    self.renderer = nil
    self.rendererFactory = tileMap.objectRendererFactory
end

---
-- Load the tile object data.
-- @param data tile object data
function TileObject:loadData(data)
    self.data = data
    self.name = data.name
    self.type = data.type
    self.shape = data.shape
    self.gid = data.gid
    self.properties = data.properties

    self:setPosByAuto(data.x, data.y)
    self:setSize(data.width, data.height)
    self:createRenderer()
    self:setVisible(data.visible)
end

---
-- Save the tile object data.
-- @return tile object data
function TileObject:saveData()
    local data = self.data or {}
    seld.data = data
    data.name = self.name
    data.type = self.type
    data.shape = self.shape
    data.x = self:getLeft()
    data.y = self:getTop()
    data.width = self:getWidth()
    data.height = self:getHeight()
    data.gid = self.gid
    data.visible = self:getVisible()
    data.properties = self.properties
    return data
end

---
-- Create a renderer.
-- There is no need to call directly basically.
-- @return Tile object renderer
function TileObject:createRenderer()
    if self.renderer then
        self:removeChild(self.renderer)
    end

    self.rendererFactory = self.rendererFactory
    self.renderer = self.rendererFactory:newInstance(self)

    if self.renderer then
        self:addChild(self.renderer)
    end
end

---
-- Update a priority.
function TileObject:updatePriority()
    if self.parent then
        local parentPriority = self.parent:getPriority() or 0
        self:setPriority(parentPriority + self:getTop())
    end    
end

---
-- Sets a position.
-- @param x x-position
-- @param y y-position
function TileObject:setPosByAuto(x, y)
    local tileMap = self.tileMap

    if tileMap:isOrthogonal() then
        self:setPos(x, y)
    elseif tileMap:isIsometric() then
        self:setIsoPos(x, y)
    end
end

---
-- Sets a position and update render priority.
-- @param x x-position
-- @param y y-position
-- @param z z-position.
function TileObject:setLoc(x, y, z)
    TileObject.__index.setLoc(self, x, y, z)
    self:updatePriority()
end

---
-- Adds a position and update render priority.
-- @param x x-position
-- @param y y-position
-- @param z z-position.
function TileObject:addLoc(x, y, z)
    TileObject.__index.addLoc(self, x, y, z)
    self:updatePriority()
end

---
-- Sets a position for isometric.
-- @param x x-position
-- @param y y-position
function TileObject:setIsoPos(x, y)
    local posX = x - y
    local posY = (x + y) / 2
    posX = posX + self.tileMap.tileWidth / 2
    posY = posY + self.tileMap.tileHeight / 2
    self:setPos(posX, posY)
end

---
-- Returns a position for isometric.
-- @param x x-position
-- @param y y-position
function TileObject:getIsoPos()
    local posX, posY = self:getPos()
    posX = posX - self.tileMap.tileWidth / 2
    posY = posY -self.tileMap.tileHeight / 2
    local y = posY - posX / 2
    local x = posX + y
    return x, y
end

function TileObject:getProperty(key)
    return self.properties[key]
end

function TileObject:getPropertyAsNumber(key)
    local value = self:getProperty(key)
    if value then
        return tonumber(value)
    end
end

return TileObject