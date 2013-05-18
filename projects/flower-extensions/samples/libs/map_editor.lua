----------------------------------------------------------------------------------------------------
-- Simple example TileEditor.
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
local TileEditorMap
local TileEditSystem
local MovementSystem

--------------------------------------------------------------------------------
-- @type MapEditorView
--------------------------------------------------------------------------------
TileEditorMap = class(TileMap)
M.TileEditorMap = TileEditorMap

TileEditorMap.MODE_MOVE = "move"

TileEditorMap.MODE_EDIT = "edit"

function TileEditorMap:init()
    TileMap.init(self)

    self:initLayer()
    self:initSystems()
    self:initEventListeners()
    
    self:setMode(TileEditorMap.MODE_MOVE)
end

function TileEditorMap:initLayer()
    self.camera = Camera()

    local layer = Layer()
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    layer:setTouchEnabled(true)
    layer:setCamera(self.camera)
    self:setLayer(layer)
end

function TileEditorMap:initSystems()
    self.systems = {
        TileEditSystem(self),
        MovementSystem(self),
    }
end

function TileEditorMap:initEventListeners()
end

function TileEditorMap:setScene(scene)
    self.scene = scene
    self.layer:setScene(scene)
end

function TileEditorMap:setMode(mode)
    self.mode = mode
    for i, system in ipairs(self.systems) do
        system:setMode(mode)
    end
end

----------------------------------------------------------------------------------------------------
-- @type TileEditSystem
----------------------------------------------------------------------------------------------------
TileEditSystem = class()

function TileEditSystem:init(tileMap)
    self.tileMap = tileMap
    self.enabled = false
    self.editLayerName = "Collision"

    math.randomseed(os.time())
end

function TileEditSystem:setMode(mode)
    self.enabled = mode == TileEditorMap.MODE_EDIT
    if self.enabled then
        self.tileMap:addEventListener("touchDown", self.onTouchDown, self)
        self.tileMap:addEventListener("touchMove", self.onTouchMove, self)
    else
        self.tileMap:removeEventListener("touchDown", self.onTouchDown, self)
        self.tileMap:removeEventListener("touchMove", self.onTouchMove, self)
    end
end

function TileEditSystem:generateGid()
    local tileMap = self.tileMap
    local tilesetMaxNo = #tileMap.tilesets
    local tilesetNo = math.random(tilesetMaxNo)
    local tileset = tileMap.tilesets[tilesetNo]
    return tileset.firstgid
end

function TileEditSystem:onTouchDown(e)
    local mx, my = self.tileMap:getPos()
    local wx, wy = e.wx - mx, e.wy - my
    self.editGid = self:generateGid()
    self:setGid(wx, wy, self.editGid)
end


function TileEditSystem:onTouchMove(e)
    local mx, my = self.tileMap:getPos()
    local wx, wy = e.wx - mx, e.wy - my
    self:setGid(wx, wy, self.editGid)
end

function TileEditSystem:setGid(worldX, worldY, gid)
    local tileMap = self.tileMap
    local editLayer = tileMap:findMapLayerByName(self.editLayerName)
    local tileW, tileH = tileMap.tileWidth, tileMap.tileHeight
    local tileX, tileY = math.floor(worldX / tileW), math.floor(worldY / tileH)
    editLayer:setGid(tileX, tileY, gid)
end

----------------------------------------------------------------------------------------------------
-- @type MovementSystem
----------------------------------------------------------------------------------------------------
MovementSystem = class()

function MovementSystem:init(tileMap)
    self.tileMap = tileMap
    self.enabled = false
    self:initEventListeners()
end

function MovementSystem:initEventListeners()
    local tileMap = self.tileMap
    tileMap:addEventListener("touchDown", self.onTouchDown, self)
    tileMap:addEventListener("touchUp", self.onTouchUp, self)
    tileMap:addEventListener("touchMove", self.onTouchMove, self)
    tileMap:addEventListener("touchCancel", self.onTouchUp, self)
end

function MovementSystem:setMode(mode)
    self.enabled = mode == TileEditorMap.MODE_MOVE
    if self.enabled then
        self.tileMap:addEventListener("touchDown", self.onTouchDown, self)
        self.tileMap:addEventListener("touchUp", self.onTouchUp, self)
        self.tileMap:addEventListener("touchMove", self.onTouchMove, self)
        self.tileMap:addEventListener("touchCancel", self.onTouchUp, self)
    else
        self.tileMap:removeEventListener("touchDown", self.onTouchDown, self)
        self.tileMap:removeEventListener("touchUp", self.onTouchUp, self)
        self.tileMap:removeEventListener("touchMove", self.onTouchMove, self)
        self.tileMap:removeEventListener("touchCancel", self.onTouchUp, self)
    end
end

function MovementSystem:onTouchDown(e)
    if self.lastTouchIdx then
        return
    end
    self.lastTouchIdx = e.idx
    self.lastTouchWX = e.wx
    self.lastTouchWY = e.wy    
end

function MovementSystem:onTouchUp(e)
    if self.lastTouchIdx ~= e.idx then
        return
    end
    self.lastTouchIdx = nil
    self.lastTouchWX = nil
    self.lastTouchWY = nil    
end

function MovementSystem:onTouchMove(e)
    if self.lastTouchIdx ~= e.idx then
        return
    end
    local tileMap = self.tileMap
    local moveX = e.wx - self.lastTouchWX
    local moveY = e.wy - self.lastTouchWY
    local left, top = tileMap:getPos()
    left = math.max(math.min(0, left + moveX), -math.max(tileMap:getWidth() - flower.viewWidth, 0))
    top = math.max(math.min(0, top + moveY), -math.max(tileMap:getHeight() - flower.viewHeight, 0))
    tileMap:setPos(left, top)

    self.lastTouchWX = e.wx
    self.lastTouchWY = e.wy
end


return M