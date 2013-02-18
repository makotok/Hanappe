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
local UpdatingSystem
local MovementSystem
local CameraSystem
local RenderSystem
local ActorController
local PlayerController

-- Constranits
local ACTOR_ANIM_DATAS = {
    {name = "walkDown", frames = {2, 1, 2, 3, 2}, sec = 0.25},
    {name = "walkLeft", frames = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "walkRight", frames = {8, 7, 8, 9, 8}, sec = 0.25},
    {name = "walkUp", frames = {11, 10, 11, 12, 11}, sec = 0.25},
}
local ACTOR_VELOCITY_DATAS = {
    walkDown = {x = 0, y = 2},
    walkLeft = {x = -2, y = 0},
    walkRight = {x = 2, y = 0},
    walkUp = {x = 0, y = -2},
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
        UpdatingSystem(self),
        MovementSystem(self),
        CameraSystem(self),
        RenderSystem(self),
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
    self.objectLayer = self:findMapLayerByName("Object")
    self.collisionLayer = self:findMapLayerByName("Collision")
    if self.collisionLayer then
        self.collisionLayer:setVisible(false)
    end
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
end

function RPGObject:loadData(data)
    TileObject.loadData(self, data)
    self:createController()
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

function RPGObject:getController()
    return self.controller
end

----------------------------------------------------------------------------------------------------
-- @type UpdatingSystem
----------------------------------------------------------------------------------------------------
UpdatingSystem = class()

function UpdatingSystem:init(tileMap)
    self.tileMap = tileMap
end

function UpdatingSystem:onUpdate()
    local objectLayer = self.tileMap.objectLayer
    for i, object in ipairs(objectLayer:getObjects()) do
        if object.controller then
            object:onUpdate()
        end
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
    if not object.controller or not object.controller.linerVelocity then
        return
    end
    
    local velocity = object.controller.linerVelocity
    object:addLoc(velocity.x, velocity.y)
    velocity.count = velocity.count - 1
    
    if velocity.count <= 0 then
        velocity.x = 0
        velocity.y = 0
    end
end

function MovementSystem:isCollisionFoObjects(mapX, mapY)
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
    self.linerVelocity = {}
    
    if self.renderer then
        self.renderer:setAnimDatas(ACTOR_ANIM_DATAS)
    end
end

function ActorController:onUpdate(e)
    
end

function ActorController:walk(direction)
    self.renderer:playAnim(direction)
    
end

function ActorController:walkLeft()
    self:walk("walkLeft")
end

function ActorController:walkUp()
    self:walk("walkUp")
end

function ActorController:walkRight()
    self:walk("walkRight")
end

function ActorController:walkDown()
    self:walk("walkDown")
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