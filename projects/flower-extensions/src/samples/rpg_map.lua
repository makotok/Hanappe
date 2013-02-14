----------------------------------------------------------------------------------------------------
-- Simple example RPGMap.
--
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local tiled = require "flower_tiled"
local class = flower.class
local table = flower.table
local Layer = flower.Layer
local Camera = flower.Camera
local TileMap = tiled.TileMap
local TileObject = tiled.TileObject

-- class
local RPGMap
local RPGObject
local MovementSystem
local CameraSystem
local ActorController
local PlayerController

-- Constranits
local ACTOR_ANIM_DATAS = {
    {name = "walkDown", frames = {2, 1, 2, 3, 2}, sec = 0.25},
    {name = "walkLeft", frames = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "walkRight", frames = {8, 7, 8, 9, 8}, sec = 0.25},
    {name = "walkUp", frames = {11, 10, 11, 12, 11}, sec = 0.25},
}

----------------------------------------------------------------------------------------------------
-- @type RPGMap
----------------------------------------------------------------------------------------------------
RPGMap = class(TileMap)
M.RPGMap = RPGMap

function RPGMap:init()
    TileMap.init(self)
    self.objectFactory = ClassFactory(RPGObject)
    
    self:initLayer()
    self:initSystems()
    self:initEventListeners()
end

function RPGMap:initLayer()
    local layer = Layer()
    local camera = Camera()
    layer:setCamera(camera)
    self:setLayer(layer)
end

function RPGMap:initSystems()
    self.systems = {
        MovementSystem(self),
        CameraSystem(self),
    }
end

function RPGMap:initEventListeners()
    self:addEventListener("loadedData", self.onLoadedData, self)
    self:addEventListener("savedData", self.onSavedData, self)
end

function RPGMap:isCollison(x, y)
    local gid = self.collisionLayer:getGid(x, y)
    return gid > 0
end

function RPGMap:onLoadedData(e)
    self.collisionLayer = self:findMapLayerByName("Collision")
end

function RPGMap:onSavedData(e)
    
end

function RPGMap:onUpdate(e)
    for i, system in ipairs(self.systems) do
        system:onUpdate()
    end
end

----------------------------------------------------------------------------------------------------
-- @type RPGObject
----------------------------------------------------------------------------------------------------
RPGObject = class(TileObject)
M.RPGObject = RPGObject

function RPGObject:init(tileMap)
    TileObject.init(self, tileMap)
    self.linerVelocity = {x = 0, y = 0}
end

function RPGObject:loadData(data)
    TileObject.loadData(self, data)
    self:createController()
end

function RPGObject:walk(walkType)
    if self.renderer then
        self.renderer:playAnim(walkType)
    end
    
    
    
end

function RPGObject:getMapPos()

end

function RPGObject:getMapNextPos()

end

function RPGObject:createController()
    local controllerName = self:getProperty("controller") or "Dummy"
    local controllerClass = M[controllerClass]
    
    if controllerClass then
        self.controller = controllerClass(self)
    end
end

----------------------------------------------------------------------------------------------------
-- @type MovementSystem
----------------------------------------------------------------------------------------------------
MovementSystem = class()

function MovementSystem:init(tileMap)
    self.tileMap = tileMap
    self.objectLayer = nil
end

function MovementSystem:onUpdate()
    for i, object in ipairs(self.objectLayer:getObjects()) do
        self:moveObject(object)
    end
end

function MovementSystem:moveObject(object)
    if not object.linerVelocity then
        return
    end
    
    local velocity = object.linerVelocity
    object:addLoc(velocity.x, velocity.y)
    velocity.count = velocity.count - 1
    
    if velocity.count <= 0 then
    end
end

function MovementSystem:isCollisionForMap(mapX, mapY)
    if self.collisionLayer then
        local gid = self.collisionLayer:getGid(mapX, mapY)
        return gid > 0
    end
end

function MovementSystem:isCollisionForMap(mapX, mapY)
    local gid = self.collisionLayer:getGid(mapX, mapY)
    return gid > 0
end

function MovementSystem:isCollisionForObject(object, mapX, mapY)
    for i, object in ipairs(self.objectLayer:getObjects()) do
        self:moveObject(object)
    end
end

----------------------------------------------------------------------------------------------------
-- @type ActorController
----------------------------------------------------------------------------------------------------
ActorController = class()

function ActorController:init(tileObject)
    self.tileObject = assert(tileObject)
    self.renderer = tileObject.renderer
    
    if self.renderer then
        self.renderer:setAnimDatas(ACTOR_ANIM_DATAS)
    end
end

function ActorController:onUpdate(e)
    
end

function ActorController:moveMap(direction)
end

----------------------------------------------------------------------------------------------------
-- @type PlayerController
----------------------------------------------------------------------------------------------------
PlayerController = class()

function PlayerController:init(playerObject)
    self.playerObject = assert(playerObject)
end

function PlayerController:onUpdate(e)
    
end


return M