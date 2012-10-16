----------------------------------------------------------------------------------------------------
-- 表示オブジェクトに関するラッパーモジュールです.
-- 
--
--
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- Classes
local table
local math
local class
local Event
local EventListener
local EventDispatcher
local Input
local DisplayObject
local Group
local Scene
local Layer
local Camera
local Image
local SheetImage
local MapImage
local MovieClip
local Label
local Font
local Texture
local Rect

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

-- Texture cache
local textureCache = setmetatable({}, {__mode = "v"})

-- Font cache
local fontCache = {}

-- Event cache
local eventCache = {}

-- Screen Size
local screenWidth, screenHeight

-- Viewport Size
local viewWidth, viewHeight

-- Sensors
local pointerSensor     = MOAIInputMgr.device.pointer
local mouseLeftSensor   = MOAIInputMgr.device.mouseLeft
local touchSensor       = MOAIInputMgr.device.touch
local keyboardSensor    = MOAIInputMgr.device.keyboard

-- Input data
local pointer           = {x = 0, y = 0, down = false}

----------------------------------------------------------------------------------------------------
-- Constraints
----------------------------------------------------------------------------------------------------

--- Default font
M.DEFAULT_FONT = "VL-PGothic.ttf"

--- Default font charcodes
M.DEFAULT_FONT_CHARCODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-"

--- Default font points
M.DEFAULT_FONT_POINTS = 24

----------------------------------------------------------------------------------------------------
-- class
-- @class table
-- @name class
----------------------------------------------------------------------------------------------------
class = {}
setmetatable(class, class)
M.class = class

--------------------------------------------------------------------------------
-- Class definition is a function.
-- @param ... Base class list.
-- @return class
--------------------------------------------------------------------------------
function class:__call(...)
    local classObj = table.copy(self)
    local bases = {...}
    for i = #bases, 1, -1 do
        table.copy(bases[i], classObj)
    end
    classObj.__call = function(self, ...)
        return self:new(...)
    end
    return setmetatable(classObj, classObj)
end

--------------------------------------------------------------------------------
-- Instance generating functions.<br>
-- The user can use this function.<br>
-- Calling this function, init function will be called internally.<br>
-- @return Instance
--------------------------------------------------------------------------------
function class:new(...)
    local obj
    if self.__factory then
        obj = self.__factory.new()
        table.copy(self, obj)
    else
        obj = {__index = self}
        setmetatable(obj, obj)
    end
    
    if obj.init then
        obj:init(...)
    end

    obj.new = nil
    obj.init = nil
    
    return obj
end

----------------------------------------------------------------------------------------------------
-- This table extends the functionality of the table.
-- @class table
-- @name table
----------------------------------------------------------------------------------------------------
table = setmetatable({}, {__index = _G.table})
M.table = table

--------------------------------------------------------------------------------
-- Returns the position found by searching for a matching value from the array.
-- @param array table array
-- @param value Search value
-- @return If one is found the index. 0 if not found.
--------------------------------------------------------------------------------
function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

--------------------------------------------------------------------------------
-- Same as indexOf, only for key values (slower)
-- Author:Nenad Katic<br>
--------------------------------------------------------------------------------
function table.keyOf( src, val )
    for k, v in pairs( src ) do
        if v == val then
            return k
        end
    end
    return nil
end

--------------------------------------------------------------------------------
-- The shallow copy of the table.
-- @param src copy
-- @param dest (option)Destination
-- @return dest
--------------------------------------------------------------------------------
function table.copy(src, dest)
    dest = dest or {}
    for i, v in pairs(src) do
        dest[i] = v
    end
    return dest
end

--------------------------------------------------------------------------------
-- The deep copy of the table.
-- @param src copy
-- @param dest (option)Destination
-- @return dest
--------------------------------------------------------------------------------
function table.deepCopy(src, dest)
    dest = dest or {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = table.deepCopy(v)
        else
            dest[k] = v
        end
    end
    return dest
end

--------------------------------------------------------------------------------
-- The shallow copy of the table.
-- @param src src object.
-- @param dest dest object.
-- @return dest
--------------------------------------------------------------------------------
function table.decorate(src, dest)
    for k, v in pairs(src) do
        if dest[k] == nil then
            dest[k] = v
        end
    end
    return dest
end

--------------------------------------------------------------------------------
-- Adds an element to the table.
-- If the element was present, the element will return false without the need for additional.
-- If the element does not exist, and returns true add an element.
-- @param t table
-- @param o element
-- @return If it already exists, false. If you add is true.
--------------------------------------------------------------------------------
function table.insertElement(t, o)
    if table.indexOf(t, o) > 0 then
        return false
    end
    table.insert(t, o)
    return true
end

--------------------------------------------------------------------------------
-- This removes the element from the table.
-- If you have successfully removed, it returns the index of the yuan.
-- If there is no element, it returns 0.
-- @param t table
-- @param o element
-- @return index
--------------------------------------------------------------------------------
function table.removeElement(t, o)
    local i = table.indexOf(t, o)
    if i > 0 then
        M.remove(t, i)
    end
    return i
end

----------------------------------------------------------------------------------------------------
-- This table extends the functionality of the math.
-- @class table
-- @name math
----------------------------------------------------------------------------------------------------
math = setmetatable({}, {__index = _G.math})
M.math = math

--------------------------------------------------------------------------------
-- Calculate the average of the values of the argument.
-- @param ... The number of variable-length argument
-- @return average
--------------------------------------------------------------------------------
function math.average(...)
    local total = 0
    local array = {...}
    for i, v in ipairs(array) do
        total = total + v
    end
    return total / #array
end

--------------------------------------------------------------------------------
-- Calculate the total values of the argument
-- @param ... The number of variable-length argument
-- @return total
--------------------------------------------------------------------------------
function math.sum(...)
    local total = 0
    local array = {...}
    for i, v in ipairs(array) do
        total = total + v
    end
    return total
end

--------------------------------------------------------------------------------
-- Calculate the distance.
-- @param x0 Start position.
-- @param y0 Start position.
-- @param x1 (option)End position.
-- @param y1 (option)End position.
-- @return distance
--------------------------------------------------------------------------------
function math.distance( x0, y0, x1, y1 )
    if not x1 then x1 = 0 end
    if not y1 then y1 = 0 end
    
    local dX = x1 - x0
    local dY = y1 - y0
    local dist = math.sqrt((dX * dX) + (dY * dY))
    return dist
end

--------------------------------------------------------------------------------
-- Normalized by calculating the distance
-- @param x 
-- @param y
-- @return x/d, y/d
--------------------------------------------------------------------------------
function math.normalize( x, y )
    local d = math.distance( x, y )
    return x/d, y/d
end

--------------------------------------------------------------------------------
-- Calculate the Angle.
-- @param a
-- @param b
-- @param c
-- @return angle
--------------------------------------------------------------------------------
function math.getAngle( a, b, c )
    local result
    if c then
        local ab, bc = { }, { }
        
        ab.x = b.x - a.x;
        ab.y = b.y - a.y;

        bc.x = b.x - c.x;
        bc.y = b.y - c.y;
        
        local angleAB   = math.atan2( ab.y, ab.x )
        local angleBC   = math.atan2( bc.y, bc.x )
        result = angleAB - angleBC
    else
        local ab = { }

        ab.x = b.x - a.x;
        ab.y = b.y - a.y;
        result = math.deg( math.atan2( ab.y, ab.x ) )

    end
    return  result
end

--------------------------------------------------------------------------------
-- If the value is out of range, return a value in the range.
-- @param v
-- @param min
-- @param max
-- @return v (min <= v <= max)
--------------------------------------------------------------------------------
function math.clamp( v, min, max )
    if v < min then
        v = min
    elseif v > max then
        v = max
    end
    return v
end

----------------------------------------------------------------------------------------------------
-- The base class Event. <br>
-- Holds the data of the Event. <br>
--
-- @auther Makoto
-- @class table
-- @name Event
----------------------------------------------------------------------------------------------------
Event = class()
M.Event = Event

-- Constraints
Event.OPEN              = "open"
Event.CLOSE             = "close"
Event.DOWN              = "down"
Event.UP                = "up"
Event.MOVE              = "move"
Event.CLICK             = "click"
Event.CANCEL            = "cancel"
Event.KEY_DOWN          = "keyDown"
Event.KEY_UP            = "keyUp"
Event.COMPLETE          = "complete"
Event.TOUCH_DOWN        = "touchDown"
Event.TOUCH_UP          = "touchUp"
Event.TOUCH_MOVE        = "touchMove"
Event.TOUCH_CANCEL      = "touchCancel"
Event.BUTTON_DOWN       = "buttonDown"
Event.BUTTON_UP         = "buttonUp"

--------------------------------------------------------------------------------
-- The constructor.
-- @param eventType (option)The type of event.
--------------------------------------------------------------------------------
function Event:init(eventType)
    self.type = eventType
    self.stopFlag = false
end

--------------------------------------------------------------------------------
-- Sets the event listener by EventDispatcher. <br>
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function Event:setListener(callback, source)
    self.callback = callback
    self.source = source
end

--------------------------------------------------------------------------------
-- Stop the propagation of the event.
--------------------------------------------------------------------------------
function Event:stop()
    self.stopFlag = true
end

----------------------------------------------------------------------------------------------------
-- This class is an event listener. <br>
-- Framework will be used internally. <br>
--
-- @auther Makoto
-- @class table
-- @name EventListener
----------------------------------------------------------------------------------------------------
EventListener = class()
M.EventListener = EventListener

function EventListener:init(eventType, callback, source, priority)
    self.type = eventType
    self.callback = callback
    self.source = source
    self.priority = priority or 0
end

function EventListener:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end

----------------------------------------------------------------------------------------------------
-- This class is has a function of event notification. <br>
--
-- @auther Makoto
-- @class table
-- @name EventDispatcher
----------------------------------------------------------------------------------------------------
EventDispatcher = class()
M.EventDispatcher = EventDispatcher

--------------------------------------------------------------------------------
-- The constructor.
-- @param eventType (option)The type of event.
--------------------------------------------------------------------------------
function EventDispatcher:init()
    self.eventlisteners = {}
end

--------------------------------------------------------------------------------
-- Adds an event listener. <br>
-- will now catch the events that are sent in the dispatchEvent. <br>
-- @param evenType Target event type.
-- @param callback The callback function.
-- @param source (option)The first argument passed to the callback function.
-- @param priority (option)Notification order.
--------------------------------------------------------------------------------
function EventDispatcher:addEventListener(eventType, callback, source, priority)
    assert(eventType)
    assert(callback)

    if self:hasEventListener(eventType, callback, source) then
        return false
    end

    local listener = EventListener(eventType, callback, source, priority)

    for i, v in ipairs(self.eventlisteners) do
        if listener.priority < v.priority then
            table.insert(self.eventlisteners, i, listener)
            return true
        end
    end

    table.insert(self.eventlisteners, listener)
    return true
end

--------------------------------------------------------------------------------
-- Removes an event listener.
--------------------------------------------------------------------------------
function EventDispatcher:removeEventListener(eventType, callback, source)
    assert(eventType)
    assert(callback)
    
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == eventType and obj.callback == callback and obj.source == source then
            table.remove(self.eventlisteners, key)
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- Returns true if you have an event listener.
-- @param eventType
-- @param callback
-- @param source
-- @return Returns true if you have an event listener.
--------------------------------------------------------------------------------
function EventDispatcher:hasEventListener(eventType, callback, source)
    assert(eventType)
    
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == eventType then
            if callback or source then
                if obj.callback == callback and obj.source == source then
                    return true
                end
            else
                return true
            end
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- Dispatches the event.
-- @param event 
-- @param data
--------------------------------------------------------------------------------
function EventDispatcher:dispatchEvent(event, data)
    local eventName = type(event) == "string" and event
    if eventName then
        event = eventCache[eventName] or Event(eventName)
        eventCache[eventName] = nil
    end
    
    assert(event.type)

    event.data = data or event.data
    event.stopFlag = false
    event.target = self.eventTarget or self
    
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == event.type then
            event:setListener(obj.callback, obj.source)
            obj:call(event)
            if event.stopFlag == true then
                break
            end
        end
    end
    
    if eventName then
        eventCache[eventName] = event
    end
end

--------------------------------------------------------------------------------
-- Remove all event listeners.
--------------------------------------------------------------------------------
function EventDispatcher:clearEventListeners()
    self.eventlisteners = {}
end

----------------------------------------------------------------------------------------------------
-- This class is has a function of event notification. <br>
--
-- @auther Makoto
-- @class table
-- @name Input
----------------------------------------------------------------------------------------------------
Input = EventDispatcher()
M.Input = Input

-- Touch Events
Input.TOUCH_EVENTS = {
    [MOAITouchSensor.TOUCH_DOWN]    = Event(Event.TOUCH_DOWN),
    [MOAITouchSensor.TOUCH_UP]      = Event(Event.TOUCH_UP),
    [MOAITouchSensor.TOUCH_MOVE]    = Event(Event.TOUCH_MOVE),
    [MOAITouchSensor.TOUCH_CANCEL]  = Event(Event.TOUCH_CANCEL),
}

-- Key Events
Input.KEY_DOWN_EVENT    = Event(Event.KEY_DOWN)
Input.KEY_UP_EVENT      = Event(Event.KEY_UP)

--------------------------------------------------------------------------------
-- Initialize.
--------------------------------------------------------------------------------
function Input:initCallbacks()

    -- Touch Handler
    local onTouch = function(eventType, idx, x, y, tapCount)
        local event = Input.TOUCH_EVENTS[eventType]
        event.idx = idx
        event.x = x
        event.y = y
        event.tapCount = tapCount
    
        self:dispatchEvent(event)
    end
    
    -- Pointer Handler
    local onPointer = function(x, y)
        pointer.x = x
        pointer.y = y
    
        if pointer.down then
            onTouch(MOAITouchSensor.TOUCH_MOVE, 1, x, y, 1)
        end
    end
    
    -- Click Handler
    local onClick = function(down)
        pointer.down = down
        local eventType = down and MOAITouchSensor.TOUCH_DOWN or MOAITouchSensor.TOUCH_UP
        
        onTouch(eventType, 1, pointer.x, pointer.y, 1)
    end
    
    -- Keyboard Handler
    local onKeyboard = function(key, down)
        local event = down and Input.KEY_DOWN_EVENT or Input.KEY_UP_EVENT
        event.down = down
        event.key = key
    
        self:dispatchEvent(event)
    end

    -- mouse or touch input
    if pointerSensor then
        pointerSensor:setCallback(onPointer)
        mouseLeftSensor:setCallback(onClick)
    else
        touchSensor:setCallback(onTouch)
    end

    -- keyboard input
    if keyboardSensor then
        keyboardSensor:setCallback(onKeyboard)
    end
end

--------------------------------------------------------------------------------
-- キーを押下しているか返します.
--------------------------------------------------------------------------------
function Input:keyIsDown(key)
    if keyboardSensor then
        return keyboardSensor:keyIsDown(key)
    end
end

----------------------------------------------------------------------------------------------------
-- It is the base class of the display object.
-- Added some useful classes.
--
-- @auther Makoto
-- @class table
-- @name DisplayObject
----------------------------------------------------------------------------------------------------
DisplayObject = class(EventDispatcher)
DisplayObject.__factory = MOAIProp
M.DisplayObject = DisplayObject

--------------------------------------------------------------------------------
-- 左上原点の座標を設定します.
--------------------------------------------------------------------------------
function DisplayObject:setPos(left, top)
    local xMin, yMin, zMin, xMax, yMax, zMax = self:getBounds()
    xMin = math.min(xMin or 0, xMax or 0)
    yMin = math.min(yMin or 0, yMax or 0)
    
    local pivX, pivY, pivZ = self:getPiv()
    local locX, locY, locZ = self:getLoc()
    self:setLoc(left + pivX - xMin, top + pivY - yMin, locZ)
end

--------------------------------------------------------------------------------
-- 左上原点の座標を返します.
--------------------------------------------------------------------------------
function DisplayObject:getPos()
    local xMin, yMin, zMin, xMax, yMax, zMax = self:getBounds()
    xMin = math.min(xMin or 0, xMax or 0)
    yMin = math.min(yMin or 0, yMax or 0)
    
    local pivX, pivY, pivZ = self:getPiv()
    local locX, locY, locZ = self:getLoc()
    return locX - pivX + xMin, locY - pivY + yMin
end

--------------------------------------------------------------------------------
-- 左上原点の座標を返します.
--------------------------------------------------------------------------------
function DisplayObject:getLeft()
    local left, top = self:getPos()
    return left
end

--------------------------------------------------------------------------------
-- 左上原点の座標を返します.
--------------------------------------------------------------------------------
function DisplayObject:getTop()
    local left, top = self:getPos()
    return top
end

--------------------------------------------------------------------------------
-- 左上原点の座標を返します.
--------------------------------------------------------------------------------
function DisplayObject:getRight()
    local left, top = self:getPos()
    local width, height = self:getDims()
    return left + width
end

--------------------------------------------------------------------------------
-- 左上原点の座標を返します.
--------------------------------------------------------------------------------
function DisplayObject:getBottom()
    local left, top = self:getPos()
    local width, height = self:getDims()
    return top + height
end

--------------------------------------------------------------------------------
-- 左上原点の座標を返します.
--------------------------------------------------------------------------------
function DisplayObject:getColor()
    local r = self:getAttr(MOAIColor.ATTR_R_COL)
    local g = self:getAttr(MOAIColor.ATTR_G_COL)
    local b = self:getAttr(MOAIColor.ATTR_B_COL)
    local a = self:getAttr(MOAIColor.ATTR_A_COL)
    return r, g, b, a
end

--------------------------------------------------------------------------------
-- オブジェクトのvisibleを返します.
--------------------------------------------------------------------------------
function DisplayObject:getVisible()
    return self:getAttr(MOAIProp.ATTR_VISIBLE)
end

--------------------------------------------------------------------------------
-- 親オブジェクトを設定します.
-- 親オブジェクトが取得できるように横取りします.
--------------------------------------------------------------------------------
function DisplayObject:setParent(value)
    local interface = MOAIProp.getInterfaceTable()
    interface.setParent(self, value)
    self.parent = value
end

----------------------------------------------------------------------------------------------------
-- Layer
----------------------------------------------------------------------------------------------------
Layer = class(DisplayObject)
Layer.__factory = MOAILayer
M.Layer = Layer

function Layer:init()
    local viewport = MOAIViewport.new()
    viewport:setSize(screenWidth, screenHeight)
    viewport:setScale(viewWidth, -viewHeight)
    viewport:setOffset(-1, 1)
    
    self:setViewport(viewport)
    self.viewport = viewport
end

----------------------------------------------------------------------------------------------------
-- Camera
----------------------------------------------------------------------------------------------------
Camera = class()
Camera.__factory = MOAICamera
M.Camera = Camera

function Camera:init(ortho, near, far)
    ortho = ortho ~= nil and ortho or true
    near = near or 1
    far = far or -1

    self:setOrtho(ortho)
    self:setNearPlane(near)
    self:setFarPlane(far)
end

----------------------------------------------------------------------------------------------------
-- Group
----------------------------------------------------------------------------------------------------
Group = class(DisplayObject)
M.Group = Group

function Group:init(layer)
    DisplayObject.init(self)
    self.children = {}
    self.isGroup = true
    self.layer = layer
end

--------------------------------------------------------------------------------
-- 子オブジェクトを追加します.
--------------------------------------------------------------------------------
function Group:addChild(child)
    if table.insertElement(child) then
        child:setParent(self)
        self.layer:insertProp(child)
    end
end

--------------------------------------------------------------------------------
-- 子オブジェクトを削除します.
--------------------------------------------------------------------------------
function Group:removeChild(child)
    if table.removeElement(child) then
        child:setParent(nil)
        self.layer:removeProp(child)
    end
end

--------------------------------------------------------------------------------
-- グループにレイヤーを設定します.
--------------------------------------------------------------------------------
function Group:setLayer(layer)
    if self.layer then
        for i, v in ipairs(self.children) do
            self.layer:removeProp(v)
        end
    end

    self.layer = layer

    if self.layer then
        for i, v in ipairs(self.children) do
            self.layer:insertProp(v)
        end
    end
end

----------------------------------------------------------------------------------------------------
-- Scene
----------------------------------------------------------------------------------------------------
Scene = class(Group)
M.Scene = Scene

function Scene:init()
    Group.init(self)
    self.loaded = false
end

function Scene:loadScene(params)
    if not self.loaded then
        self:onLoad(params)
        self.loaded = true
    end
end

function Scene:openScene(params)
    self:loadScene()
end

function Scene:closeScene()
    if self.loaded then
        self:onLoad()
        self.loaded = false
    end
end

function Scene:showOverlay()

end

function Scene:onLoad(params)

end

function Scene:onStart()

end

function Scene:onStop()

end

function Scene:onUnload()

end

function Scene:onEnterFrame()

end

----------------------------------------------------------------------------------------------------
-- Image
----------------------------------------------------------------------------------------------------
Image = class(DisplayObject)
M.Image = Image

function Image:init(texture, width, height)
    DisplayObject.init(self)
    
    texture = M.getTexture(texture)
    local tw, th = texture:getSize()

    width = width or tw
    height = height or th

    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    deck:setRect(0, 0, width, height)
    deck:setTexture(texture)
    
    self:setDeck(deck)
    self.deck = deck
    self.texture = texture
end

----------------------------------------------------------------------------------------------------
-- SheetImage
----------------------------------------------------------------------------------------------------
SheetImage = class(DisplayObject)
M.SheetImage = SheetImage

function SheetImage:init(texture, sizeX, sizeY)
    DisplayObject.init(self)
    
    texture = M.getTexture(texture)

    local deck = MOAIGfxQuadDeck2D.new()
    deck:setTexture(texture)
    
    self:setDeck(deck)
    self.deck = deck
    self.texture = texture
    self.sheetSize = 0
    self.sheetNames = {}
    
    if sizeX and sizeY then
        self:setSheetSize(sizeX, sizeY)
    end
end

--------------------------------------------------------------------------------
-- TexturePacker形式のデータを元にフレームデータを設定します.
--------------------------------------------------------------------------------
function SheetImage:setSheetFrames(frames)
    local deck = self.deck
    deck:reserve(#frames)
    
    self.sheetSize = #frames
    self.sheetNames = {}
    
    for i, frame in ipairs ( frames ) do
        local uv = frame.uvRect
        local q = {}
        if not frame.textureRotated then
            q.x0, q.y0 = uv.u0, uv.v0
            q.x1, q.y1 = uv.u1, uv.v0
            q.x2, q.y2 = uv.u1, uv.v1
            q.x3, q.y3 = uv.u0, uv.v1
        else
            q.x3, q.y3 = uv.u0, uv.v0
            q.x0, q.y0 = uv.u1, uv.v0
            q.x1, q.y1 = uv.u1, uv.v1
            q.x2, q.y2 = uv.u0, uv.v1
        end

        if not self.grid then
            deck:setUVQuad(i, q.x0, q.y0, q.x1, q.y1, q.x2, q.y2, q.x3, q.y3)
        end
        deck:setRect(i, r.x, r.y, r.x + r.width, r.y + r.height)
        self.names[frame.name] = i
    end
end

--------------------------------------------------------------------------------
-- フレームデータをテクスチャのカラム数から設定します.
--------------------------------------------------------------------------------
function SheetImage:setSheetSize(sizeX, sizeY)
    local tw, th = self.texture:getSize()
    local cw, ch = tw / sizeX, th / sizeY
    self:setTileSize(cw, ch, 0, 0)
end

--------------------------------------------------------------------------------
-- フレームデータをテクスチャのタイルサイズから設定します.
--------------------------------------------------------------------------------
function SheetImage:setTileSize(tileWidth, tileHeight, spacing, margin)
    spacing = spacing or 0
    margin = margin or 0
    
    local tw, th = self.texture:getSize()
    local tileX = math.floor((tw - margin) / (tileWidth + spacing))
    local tileY = math.floor((th - margin) / (tileHeight + spacing))

    local deck = self.deck
    self.sheetSize = tileX * tileY
    deck:reserve(self.sheetSize)
    
    local i = 1
    for y = 1, tileY do
        for x = 1, tileX do
            local ux0 = (x - 1) * tileWidth / tw
            local uy0 = (y - 1) * tileHeight / th
            local ux1 = x * tileWidth / tw
            local uy1 = y * tileHeight / th

            if not self.grid then
                deck:setRect(i, 0, 0, tileWidth, tileHeight)
            end
            deck:setUVRect(i, ux0, uy0, ux1, uy1)
            i = i + 1
        end
    end
end

--------------------------------------------------------------------------------
-- フレームデータをテクスチャのタイルサイズから設定します.
--------------------------------------------------------------------------------
function SheetImage:setIndexByName(name)
    if type(name) == "string" then
        local index = self.sheetNames[name] or self:getIndex()        
        self:setIndex(index)
    elseif type(name) == "number" then
        self:setIndex(index)
    end
end

----------------------------------------------------------------------------------------------------
-- MapImage
----------------------------------------------------------------------------------------------------
MapImage = class(SheetImage)
M.MapImage = MapImage

function MapImage:init(texture, gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    SheetImage.init(self, texture)
    
    self.grid = MOAIGrid.new()
    self:setGrid(self.grid)
    
    if gridWidth and gridHeight and tileWidth and tileHeight then
        self:setMapSize(gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    end
end

--------------------------------------------------------------------------------
-- マップのグリッドサイズを設定します.
--------------------------------------------------------------------------------
function MapImage:setMapSize(gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    self.grid:setSize(gridWidth, gridHeight, tileWidth, tileHeight)
    self:setTileSize(tileWidth, tileHeight, spacing, margin)
end

--------------------------------------------------------------------------------
-- Set the map data.
-- @param rows Multiple rows of data.
--------------------------------------------------------------------------------
function MapImage:setRows(rows)
    for i, row in ipairs(rows) do
        self:setRow(i, unpack(row))
    end
end

--------------------------------------------------------------------------------
-- Set the map data.
-- @params ... rows of data.
--------------------------------------------------------------------------------
function MapImage:setRow(...)
    self.grid:setRow(...)
end

--------------------------------------------------------------------------------
-- Set the map value.
-- @params tile x.
-- @params tile y.
-- @params tile value.
--------------------------------------------------------------------------------
function MapImage:setTile(x, y, value)
    self.grid:setTile(x, y, value)
end

--------------------------------------------------------------------------------
-- Return the map value.
-- @params tile x.
-- @params tile y.
-- @return tile value.
--------------------------------------------------------------------------------
function MapImage:getTile(x, y)
    return self.grid:getTile(x, y)
end

--------------------------------------------------------------------------------
-- Set the repeat flag.
-- @param repeatX
-- @param repeatY
--------------------------------------------------------------------------------
function MapImage:setRepeat(repeatX, repeatY)
    self.grid:setRepeat(repeatX, repeatY)
end

----------------------------------------------------------------------------------------------------
-- MovieClip
----------------------------------------------------------------------------------------------------
MovieClip = class(SheetImage)
M.MovieClip = MovieClip

function MovieClip:init(texture, sizeX, sizeY)
    SheetImage.init(self, texture, sizeX, sizeY)
    self.animTable = {}
    self.currentAnim = nil
end

function MovieClip:setAnim(name, anim)
    self.animTable[name] = anim
end

function MovieClip:setAnims(anims)
    for i, anim in ipairs(anims) do
        local name = anim.name or i
        self:setAnim(name, anim)
    end
end

function MovieClip:playAnim(name)
    local currentAnim = self.currentAnim
    local animTable = self.animTable
    
    if currentAnim and currentAnim:isBusy() then
        currentAnim:stop()
    end
    if animTable[name] then
        currentAnim = animTable[name]
        self.currentAnim = currentAnim
    end
    if currentAnim then
        currentAnim:start()
    end
end

function MovieClip:stopAnim()
    if self.currentAnim then
        self.currentAnim:stop()
    end
end

function MovieClip:isCurrentAnim(name)
    return self.currentAnim == self.animTable[name]
end

----------------------------------------------------------------------------------------------------
-- Texture
----------------------------------------------------------------------------------------------------
Texture = class()
Texture.__factory = MOAITexture
M.Texture = Texture

function Texture:init(path)
    self:load(path)
    self.path = path
end

----------------------------------------------------------------------------------------------------
-- Font
----------------------------------------------------------------------------------------------------
Font = class()
Font.__factory = MOAIFont

function Font:init(path, charcodes, points, dpi)
    self:load(path)
    self.path = path
    self.charcodes = charcodes
    self.points = points
    self.dpi = dpi
    
    if charcodes and points then
        self:preloadGlyphs(charcodes, points, dpi)
    end
end

----------------------------------------------------------------------------------------------------
-- Text
----------------------------------------------------------------------------------------------------
Label = class(DisplayObject)
Label.__factory = MOAITextBox
M.Label = Label

function Label:init(text, width, height, font, textSize)
    DisplayObject.init(self)
    
    font = M.getFont(font, nil, textSize)

    self:setFont(font)
    self:setRect(0, 0, width, height)
    self:setTextSize(textSize or M.DEFAULT_FONT_POINTS)
    self:setString(text)
end

----------------------------------------------------------------------------------------------------
-- Rect
----------------------------------------------------------------------------------------------------
Rect = class(DisplayObject)
M.Rect = Rect

function Rect:init(width, height)
    DisplayObject.init(self)

    local deck = MOAIScriptDeck.new()
    deck:setRect(0, 0, width, height)
    
    self:setDeck(deck)
    self.deck = deck
    
    deck:setDrawCallback(
        function(index, xOff, yOff, xFlip, yFlip)
            local w, h, d = self:getDims()
            
            MOAIGfxDevice.setPenColor(self:getColor())
            MOAIDraw.fillRect(0, 0, w, h)
        end
    )
end

----------------------------------------------------------------------------------------------------
-- Public functions
----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Windowを起動します.
-- TODO:適切なスケールの計算
--------------------------------------------------------------------------------
function M.openWindow(title, width, height)
    MOAISim.openWindow(title, width, height)
    screenWidth, screenHeight = width, height
    viewWidth, viewHeight = width, height
    
    Input:initCallbacks()
end

--------------------------------------------------------------------------------
-- スクリーンのサイズを返します.
-- @return screenWidth, screenHeight
--------------------------------------------------------------------------------
function M.getScreenSize()
    return screenWidth, screenHeight
end

--------------------------------------------------------------------------------
-- スクリーンのサイズを設定します.
-- @return screenWidth, screenHeight
--------------------------------------------------------------------------------
function M.setScreenSize(width, height)
    screenWidth = width
    screenHeight = height
end

--------------------------------------------------------------------------------
-- ビューポートに設定するスケールサイズを返します.
-- @return viewWidth, viewHeight
--------------------------------------------------------------------------------
function M.getViewSize()
    return viewWidth, viewHeight
end

--------------------------------------------------------------------------------
-- ビューポートに設定するスケールサイズを設定します.
-- @param width Width of Viewport.
-- @param height Height of Viewport.
--------------------------------------------------------------------------------
function M.setViewSize(width, height)
    viewWidth = width
    viewHeight = height
end

--------------------------------------------------------------------------------
-- テクスチャを返します.
-- テクスチャが引数に指定された場合はそのまま返します.
--------------------------------------------------------------------------------
function M.getTexture(path)
    if type(path) ~= "string" then
        return path
    end
    if textureCache[path] == nil then
        local texture = Texture(path)
        textureCache[path] = texture
    end
    return textureCache[path]
end

--------------------------------------------------------------------------------
-- 生成済フォントを返します.
-- 存在しない場合はフォントを生成して返します.
--------------------------------------------------------------------------------
function M.getFont(path, charcodes, points, dpi)
    if type(path) == "userdata" then
        return path
    end
    
    path = path or M.DEFAULT_FONT
    charcodes = charcodes or M.DEFAULT_FONT_CHARCODES
    points = points or M.DEFAULT_FONT_POINTS

    local uid = path .. "$" .. (charcodes or "") .. "$" .. (points or "") .. "$" .. (dpi or "")
    if fontCache[uid] == nil then
        local font = Font(path, charcodes, points, dpi)
        font.uid = uid
        fontCache[uid] = font
    end
    return fontCache[uid]
end

--------------------------------------------------------------------------------
-- Run the specified function looping <br>
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLoop(func, ...)
    local thread = MOAICoroutine.new()
    local args = {...}
    thread:run(
        function()
            while true do
                if func(unpack(args)) then
                    break
                end
                coroutine.yield()
            end
        end
    )
end

--------------------------------------------------------------------------------
-- Run the specified function delay. <br>
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLater(func, ...)
    M.callLaterFrame(0, func, ...)
end

--------------------------------------------------------------------------------
-- Run the specified function delay. <br>
-- @param frame Delay frame count.
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLaterFrame(frame, func, ...)
    local thread = MOAICoroutine.new()
    local args = {...}
    local count = 0
    thread:run(
        function()
            while count < frame do
                count = count + 1
                coroutine.yield()
            end
            func(unpack(args))
        end
    )
end

--------------------------------------------------------------------------------
-- Run the specified function delay. <br>
-- @param time Delay seconds.
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLaterTime(time, func, ...)
    local args = {...}
    local timer = MOAITimer.new()
    timer:setSpan(time)
    timer:setListener(MOAITimer.EVENT_STOP, function() func(unpack(args)) end)
    timer:start()
end

return M
