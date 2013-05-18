----------------------------------------------------------------------------------------------------
-- Simple example RPGMap.
--
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local tiled = require "tiled"
local widget = require "widget"
local class = flower.class
local table = flower.table
local InputMgr = flower.InputMgr
local SceneMgr = flower.SceneMgr
local Group = flower.Group
local ClassFactory = flower.ClassFactory
local Layer = flower.Layer
local Camera = flower.Camera
local TileMap = tiled.TileMap
local TileObject = tiled.TileObject
local UIView = widget.UIView
local Joystick = widget.Joystick
local Button = widget.Button


-- classes
local RPGMap
local RPGMapControlView
local RPGObject
local MovementSystem
local CameraSystem

-- KeyCode
local KeyCode = {}
KeyCode.LEFT = string.byte("a")
KeyCode.RIGHT = string.byte("d")
KeyCode.UP = string.byte("w")
KeyCode.DOWN = string.byte("s")

-- stick to dir map
local STICK_TO_DIR = {
    top = "up",
    left = "left",
    right = "right",
    bottom = "down"
}

--------------------------------------------------------------------------------
-- @type RPGMap
--------------------------------------------------------------------------------
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
    self.camera = Camera()

    local layer = Layer()
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setCamera(self.camera)
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

function RPGMap:setScene(scene)
    self.scene = scene
    self.layer:setScene(scene)
end

function RPGMap:isCollisionForMap(mapX, mapY)
    if mapX < 0 or self.mapWidth <= mapX then
        return true
    end
    if mapY < 0 or self.mapHeight <= mapY then
        return true
    end

    local gid = self.collisionLayer:getGid(mapX, mapY)
    return gid > 0
end

function RPGMap:isCollisionForObjects(target, mapX, mapY)
    for i, object in ipairs(self.objectLayer:getObjects()) do
        if object ~= target then
            local objX, objY = object:getMapPos()
            if objX == mapX and objY == mapY then
                return true
            end
        end
    end
end

function RPGMap:getViewSize()
    return flower.viewWidth, flower.viewHeight
end

function RPGMap:onLoadedData(e)
    self.objectLayer = assert(self:findMapLayerByName("Object"))
    self.playerObject = assert(self.objectLayer:findObjectByName("Player"))
    self.collisionLayer = assert(self:findMapLayerByName("Collision"))
    self.eventLayer = assert(self:findMapLayerByName("Event"))

    if self.collisionLayer then
        self.collisionLayer:setVisible(false)
    end
    if self.eventLayer then
        self.eventLayer:setVisible(false)
    end
    
    for i, system in ipairs(self.systems) do
        system:onLoadedData(e)
    end
end

function RPGMap:onSavedData(e)

end

function RPGMap:onUpdate(e)
    for i, system in ipairs(self.systems) do
        system:onUpdate()
    end
end

--------------------------------------------------------------------------------
-- @type RPGMapControlView
--------------------------------------------------------------------------------
RPGMapControlView = class(UIView)
M.RPGMapControlView = RPGMapControlView

function RPGMapControlView:_createChildren()
    RPGMapControlView.__super._createChildren(self)

    self.joystick = Joystick {
        parent = self,
        stickMode = "digital",
        color = {0.6, 0.6, 0.6, 0.6},
    }
    
    self.enterButton = Button {
        size = {100, 50},
        color = {0.6, 0.6, 0.6, 0.6},
        text = "Enter",
        parent = self,
        onClick = function(e)
            self:dispatchEvent("enter")
        end,
    }
end

function RPGMapControlView:updateDisplay()
    RPGMapControlView.__super.updateDisplay(self)
    
    local vw, vh = flower.getViewSize()
    local joystick = self.joystick
    local enterButton = self.enterButton
    
    joystick:setPos(10, vh - joystick:getHeight() - 10)
    enterButton:setPos(vw - enterButton:getWidth() - 10, vh - enterButton:getHeight() - 10)
end

function RPGMapControlView:getDirection()
    if InputMgr:keyIsDown(KeyCode.LEFT) then
        return "left"
    end
    if InputMgr:keyIsDown(KeyCode.UP) then
        return "up"
    end
    if InputMgr:keyIsDown(KeyCode.RIGHT) then
        return "right"
    end
    if InputMgr:keyIsDown(KeyCode.DOWN) then
        return "down"
    end
    return STICK_TO_DIR[self.joystick:getStickDirection()]
end

----------------------------------------------------------------------------------------------------
-- @type RPGObject
----------------------------------------------------------------------------------------------------
RPGObject = class(TileObject)
M.RPGObject = RPGObject

-- Constranits
RPGObject.ACTOR_ANIM_DATAS = {
    {name = "walkDown", frames = {2, 1, 2, 3, 2}, sec = 0.25},
    {name = "walkLeft", frames = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "walkRight", frames = {8, 7, 8, 9, 8}, sec = 0.25},
    {name = "walkUp", frames = {11, 10, 11, 12, 11}, sec = 0.25},
}

-- Events
RPGObject.EVENT_MOVE_START = "moveStart"
RPGObject.EVENT_MOVE_END = "moveEnd"

-- Direction
RPGObject.DIR_UP = "up"
RPGObject.DIR_LEFT = "left"
RPGObject.DIR_RIGHT = "right"
RPGObject.DIR_DONW = "down"

-- Move speed
RPGObject.MOVE_SPEED = 4

-- Direction to AnimationName
RPGObject.DIR_TO_ANIM = {
    up = "walkUp",
    left = "walkLeft",
    right = "walkRight",
    down = "walkDown",
}

-- Direction to LinerVelocity
RPGObject.DIR_TO_VELOCITY = {
    up = {x = 0, y = -1},
    left = {x = -1, y = 0},
    right = {x = 1, y = 0},
    down = {x = 0, y = 1},
}

function RPGObject:init(tileMap)
    TileObject.init(self, tileMap)
    self.isRPGObject = true
    self.mapX = 0
    self.mapY = 0
    self.linerVelocity = {}
    self.linerVelocity.stepX = 0
    self.linerVelocity.stepX = 0
    self.linerVelocity.stepCount = 0
end

function RPGObject:loadData(data)
    TileObject.loadData(self, data)

    self.mapX = math.floor(data.x / self.tileMap.tileWidth)
    self.mapY = math.floor(data.y / self.tileMap.tileHeight) - 1

    if self.type == "Actor" or self.type == "Player" then
        self:initActor(data)
    end
end

function RPGObject:initActor(data)
    if self.renderer then
        self.renderer:setAnimDatas(RPGObject.ACTOR_ANIM_DATAS)
        self:playAnim(self:getCurrentAnimName())
    end
end

function RPGObject:getMapPos()
    return self.mapX, self.mapY
end

function RPGObject:getNextMapPos()
    local mapX, mapY = self:getMapPos()
    local velocity = RPGObject.DIR_TO_VELOCITY[self.direction]
    return mapX + velocity.x, mapY + velocity.y
end

function RPGObject:isMoving()
    return self.linerVelocity.stepCount > 0
end

function RPGObject:getCurrentAnimName()
    if not self.renderer then
        return
    end

    local index = self.renderer:getIndex()
    if 1 <= index and index <= 3 then
        return "walkDown"
    end
    if 4 <= index and index <= 6 then
        return "walkLeft"
    end
    if 7 <= index and index <= 9 then
        return "walkRight"
    end
    if 10 <= index and index <= 12 then
        return "walkUp"
    end
end

function RPGObject:playAnim(animName)
    if self.renderer and not self.renderer:isCurrentAnim(animName) then
        self.renderer:playAnim(animName)
    end
end

function RPGObject:walkMap(dir)
    if self:isMoving() then
        return
    end
    if not RPGObject.DIR_TO_ANIM[dir] then
        return
    end
    
    self:setDirection(dir)
    
    if self:hitTestFromMap() then
        return
    end
    
    local velocity = RPGObject.DIR_TO_VELOCITY[dir]
    local tileWidth = self.tileMap.tileWidth
    local tileHeight = self.tileMap.tileHeight
    local moveSpeed = RPGObject.MOVE_SPEED
    
    self.mapX = self.mapX + velocity.x
    self.mapY = self.mapY + velocity.y
    self.linerVelocity.stepX = moveSpeed * velocity.x
    self.linerVelocity.stepY = moveSpeed * velocity.y
    self.linerVelocity.stepCount = tileWidth / moveSpeed  -- TODO:TileWidthしか使用していない
    return true
end

function RPGObject:setDirection(dir)
    if not RPGObject.DIR_TO_ANIM[dir] then
        return
    end
    
    local animName = RPGObject.DIR_TO_ANIM[dir]
    self:playAnim(animName)
    self.direction = dir
end

function RPGObject:hitTestFromMap()
    if self.tileMap:isCollisionForMap(self:getNextMapPos()) then
        return true
    end
    if self.tileMap:isCollisionForObjects(self, self:getNextMapPos()) then
        return true
    end
end

function RPGObject:isCollision(mapX, mapY)
    local nowMapX, nowMapY = self:getMapPos()
    return nowMapX == mapX and nowMapY == mapY
end

----------------------------------------------------------------------------------------------------
-- @type CameraSystem
----------------------------------------------------------------------------------------------------
CameraSystem = class()
CameraSystem.MARGIN_HEIGHT = 140

function CameraSystem:init(tileMap)
    self.tileMap = tileMap
end

function CameraSystem:onLoadedData(e)
    self:onUpdate()
end

function CameraSystem:onUpdate()
    local player = self.tileMap.playerObject
    
    local vw, vh = self.tileMap:getViewSize()
    local mw, mh = self.tileMap:getSize()
    local x, y = player:getPos()

    x, y = x - vw / 2, y - vh / 2
    x, y = self:getAdjustCameraLoc(x, y)

    self.tileMap.camera:setLoc(x, y, 0)
end

function CameraSystem:getAdjustCameraLoc(x, y)
    local vw, vh = self.tileMap:getViewSize()
    local mw, mh = self.tileMap:getSize()    

    mh = mh + CameraSystem.MARGIN_HEIGHT
    
    x = math.min(x, mw - vw)
    x = math.max(x, 0)
    x = math.floor(x)
    y = math.min(y, mh - vh)
    y = math.max(y, 0)
    y = math.floor(y)
    
    return x, y
end

----------------------------------------------------------------------------------------------------
-- @type MovementSystem
----------------------------------------------------------------------------------------------------
MovementSystem = class()

function MovementSystem:init(tileMap)
    self.tileMap = tileMap
end

function MovementSystem:onLoadedData(e)

end

function MovementSystem:onUpdate()
    for i, object in ipairs(self.tileMap.objectLayer:getObjects()) do
        self:moveObject(object)
    end
end

function MovementSystem:moveObject(object)
    if not object.linerVelocity
    or not object.linerVelocity.stepCount
    or object.linerVelocity.stepCount == 0 then
        return
    end

    local velocity = object.linerVelocity
    object:addLoc(velocity.stepX, velocity.stepY)
    velocity.stepCount = velocity.stepCount - 1

    if velocity.stepCount <= 0 then
        velocity.stepX = 0
        velocity.stepY = 0
        velocity.stepCount = 0
        
        object:dispatchEvent(RPGObject.EVENT_MOVE_END)
    end
end

return M