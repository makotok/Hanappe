----------------------------------------------------------------------------------------------------
-- Moai SDK のコーディングを楽にするフレームワークです.
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
local Executors
local Resources
local Runtime
local InputMgr
local RenderMgr
local SceneMgr
local DisplayObject
local Group
local Scene
local SceneAnimations
local Layer
local Camera
local Image
local SheetImage
local MapImage
local MovieClip
local Label
local Rect
local Font
local Texture
local Mesh
local TouchHandler

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------

-- Sensors
local pointerSensor     = MOAIInputMgr.device.pointer
local mouseLeftSensor   = MOAIInputMgr.device.mouseLeft
local touchSensor       = MOAIInputMgr.device.touch
local keyboardSensor    = MOAIInputMgr.device.keyboard

----------------------------------------------------------------------------------------------------
-- Public functions
----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Windowを起動します.
--------------------------------------------------------------------------------
function M.openWindow(title, width, height, scale)
    scale = scale or 1    
    MOAISim.openWindow(title, width, height)
    M.screenWidth, M.screenHeight = width, height
    M.viewWidth, M.viewHeight = math.floor(width / scale), math.floor(height / scale)
    M.viewScale = scale
    
    InputMgr:initialize()
    RenderMgr:initialize()
    SceneMgr:initialize()
end

--------------------------------------------------------------------------------
-- テクスチャを返します.
-- テクスチャが引数に指定された場合はそのまま返します.
--------------------------------------------------------------------------------
function M.getTexture(path)
    return Resources.getTexture(path)
end

--------------------------------------------------------------------------------
-- MoaiのTexturePacker形式のデータを読み込んで返します.
--------------------------------------------------------------------------------
function M.getTextureAtlas(luaFilePath, texture)
    return Resources.getTextureAtles(luaFilePath, texture)
end

--------------------------------------------------------------------------------
-- 生成済フォントを返します.
-- 存在しない場合はフォントを生成して返します.
--------------------------------------------------------------------------------
function M.getFont(path, charcodes, points, dpi)
    return Resources.getFont(path, charcodes, points, dpi)
end

--------------------------------------------------------------------------------
-- シーンをロードします.
--------------------------------------------------------------------------------
function M.loadScene(sceneName, params)
    return SceneMgr:loadScene(sceneName, params)
end

--------------------------------------------------------------------------------
-- シーンを起動します.
--------------------------------------------------------------------------------
function M.openScene(sceneName, params)
    return SceneMgr:openScene(sceneName, params)
end

--------------------------------------------------------------------------------
-- 指定したシーンに遷移します.
--------------------------------------------------------------------------------
function M.gotoScene(sceneName, params)
    return SceneMgr:gotoScene(sceneName, params)
end

--------------------------------------------------------------------------------
-- 現在のシーンをクローズします.
--------------------------------------------------------------------------------
function M.closeScene(params)
    return SceneMgr:closeScene(params)
end

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
        table.remove(t, i)
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
-- This is a utility class to execute.<br>
-- @class table
-- @name Executors
----------------------------------------------------------------------------------------------------
Executors = {}
M.Executors = Executors

--------------------------------------------------------------------------------
-- Run the specified function looping <br>
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function Executors.callLoop(func, ...)
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
function Executors.callLater(func, ...)
    Executors.callLaterFrame(0, func, ...)
end

--------------------------------------------------------------------------------
-- Run the specified function delay. <br>
-- @param frame Delay frame count.
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function Executors.callLaterFrame(frame, func, ...)
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
function Executors.callLaterTime(time, func, ...)
    local args = {...}
    local timer = MOAITimer.new()
    timer:setSpan(time)
    timer:setListener(MOAITimer.EVENT_STOP, function() func(unpack(args)) end)
    timer:start()
end

----------------------------------------------------------------------------------------------------
-- This is a utility class to execute.<br>
-- @class table
-- @name Resources
----------------------------------------------------------------------------------------------------
Resources = {}
M.Resources = Resources

-- variables
Resources.textureCache = setmetatable({}, {__mode = "v"})
Resources.fontCache = {}
Resources.atlasCache = {}

--------------------------------------------------------------------------------
-- テクスチャを返します.
-- テクスチャが引数に指定された場合はそのまま返します.
--------------------------------------------------------------------------------
function Resources.getTexture(path)
    local cache = Resources.textureCache
    if type(path) ~= "string" then
        return path
    end
    if cache[path] == nil then
        local texture = Texture(path)
        cache[path] = texture
    end
    return cache[path]
end

--------------------------------------------------------------------------------
-- 生成済フォントを返します.
-- 存在しない場合はフォントを生成して返します.
--------------------------------------------------------------------------------
function Resources.getFont(path, charcodes, points, dpi)
    local cache = Resources.fontCache
    if type(path) == "userdata" then
        return path
    end
    
    path = path or Font.DEFAULT_FONT
    charcodes = charcodes or Font.DEFAULT_CHARCODES
    points = points or Font.DEFAULT_POINTS

    local uid = path .. "$" .. (charcodes or "") .. "$" .. (points or "") .. "$" .. (dpi or "")
    if cache[uid] == nil then
        local font = Font(path, charcodes, points, dpi)
        font.uid = uid
        cache[uid] = font
    end
    return cache[uid]
end

--------------------------------------------------------------------------------
-- MoaiのTexturePacker形式のデータを読み込みます.
--------------------------------------------------------------------------------
function Resources.getTextureAtlas(luaFilePath, texture)
    local cache = Resources.atlasCache
    if cache[luaFilePath] then
        return cache[luaFilePath]
    end

    local frames = dofile(luaFilePath).frames
    local data = {}
    data.frames = {}
    data.names = {}
    data.texture = texture and Resources.getTexture(texture)

    for i, frame in ipairs(frames) do
        data.names[frame.name] = i
        data.frames[i] = {}

        local uv = frame.uvRect
        local r = frame.spriteColorRect
        local dataFrame = data.frames[i]
        if frame.textureRotated then
            --dataFrame.quad = {uv.u1, uv.v0, uv.u1, uv.v1, uv.u0, uv.v1, uv.u0, uv.v0}
            dataFrame.quad = {uv.u0, uv.v0, uv.u0, uv.v1, uv.u1, uv.v1, uv.u1, uv.v0}
            dataFrame.rect = {0, 0, r.width, r.height}
        else
            --dataFrame.quad = {uv.u0, uv.v0, uv.u1, uv.v0, uv.u1, uv.v1, uv.u0, uv.v1}
            dataFrame.quad = {uv.u0, uv.v1, uv.u1, uv.v1, uv.u1, uv.v0, uv.u0, uv.v0}
            --dataFrame.quad = {uv.u1, uv.v1, uv.u0, uv.v1, uv.u0, uv.v0, uv.u1, uv.v0}
            dataFrame.rect = {0, 0, r.width, r.height}
        end
    end
    cache[luaFilePath] = data
    return data
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
Event.START             = "start"
Event.STOP              = "stop"
Event.LOAD              = "load"
Event.UNLOAD            = "unload"
Event.DOWN              = "down"
Event.UP                = "up"
Event.MOVE              = "move"
Event.CLICK             = "click"
Event.CANCEL            = "cancel"
Event.KEYBOARD          = "keyboard"
Event.COMPLETE          = "complete"
Event.TOUCH             = "touch"
Event.ENTER_FRAME       = "enterFrame"
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

EventDispatcher.eventCache = {}

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
        event = self.eventCache[eventName] or Event(eventName)
        self.eventCache[eventName] = nil
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
        self.eventCache[eventName] = event
    end
end

--------------------------------------------------------------------------------
-- Remove all event listeners.
--------------------------------------------------------------------------------
function EventDispatcher:clearEventListeners()
    self.eventlisteners = {}
end

----------------------------------------------------------------------------------------------------
-- This is a utility class to execute.<br>
-- @class table
-- @name RenderMgr
----------------------------------------------------------------------------------------------------
Runtime = EventDispatcher()
M.Runtime = Runtime

-- enter frame
Executors.callLoop(
    function()
        Runtime:dispatchEvent(Event.ENTER_FRAME)
    end
)

----------------------------------------------------------------------------------------------------
-- This class is has a function of event notification. <br>
--
-- @auther Makoto
-- @class table
-- @name InputMgr
----------------------------------------------------------------------------------------------------
InputMgr = EventDispatcher()
M.InputMgr = InputMgr

-- Touch Events
InputMgr.TOUCH_EVENT = Event(Event.TOUCH)

-- Keyboard
InputMgr.KEYBOARD_EVENT = Event(Event.KEYBOARD)

-- Touch Event Kinds
InputMgr.TOUCH_EVENT_KINDS = {
    [MOAITouchSensor.TOUCH_DOWN]    = "down",
    [MOAITouchSensor.TOUCH_UP]      = "up",
    [MOAITouchSensor.TOUCH_MOVE]    = "move",
    [MOAITouchSensor.TOUCH_CANCEL]  = "cancel",
}

-- pointer data
InputMgr.pointer = {x = 0, y = 0, down = false}

--------------------------------------------------------------------------------
-- Initialize.
--------------------------------------------------------------------------------
function InputMgr:initialize()

    -- Touch Handler
    local onTouch = function(eventType, idx, x, y, tapCount)
        local event = InputMgr.TOUCH_EVENT
        event.kind = InputMgr.TOUCH_EVENT_KINDS[eventType]
        event.idx = idx
        event.x = x
        event.y = y
        event.tapCount = tapCount
    
        self:dispatchEvent(event)
    end
    
    -- Pointer Handler
    local onPointer = function(x, y)
        self.pointer.x = x
        self.pointer.y = y
    
        if self.pointer.down then
            onTouch(MOAITouchSensor.TOUCH_MOVE, 1, x, y, 1)
        end
    end
    
    -- Click Handler
    local onClick = function(down)
        self.pointer.down = down
        local eventType = down and MOAITouchSensor.TOUCH_DOWN or MOAITouchSensor.TOUCH_UP
        
        onTouch(eventType, 1, self.pointer.x, self.pointer.y, 1)
    end
    
    -- Keyboard Handler
    local onKeyboard = function(key, down)
        local event = InputMgr.KEYBOARD_EVENT
        event.key = key
        event.down = down
    
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
function InputMgr:keyIsDown(key)
    if keyboardSensor then
        return keyboardSensor:keyIsDown(key)
    end
end

----------------------------------------------------------------------------------------------------
-- This is a utility class to execute.<br>
-- @class table
-- @name RenderMgr
----------------------------------------------------------------------------------------------------
RenderMgr = EventDispatcher()
M.RenderMgr = RenderMgr

-- variables
RenderMgr.renders = {}

--------------------------------------------------------------------------------
-- Initialize the RenderMgr.
--------------------------------------------------------------------------------
function RenderMgr:initialize()
    Runtime:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

--------------------------------------------------------------------------------
-- Add a Render object.
--------------------------------------------------------------------------------
function RenderMgr:addChild(render)
    table.insertElement(self.renders, render)
    self:invalidate()
end

--------------------------------------------------------------------------------
-- Remove a rendereble object.
--------------------------------------------------------------------------------
function RenderMgr:removeChild(render)
    table.removeElement(self.renders, render)
    self:invalidate()
end

--------------------------------------------------------------------------------
-- Reflected on the screen to generate a rendering table.
--------------------------------------------------------------------------------
function RenderMgr:updateRenderTable()
    local renderTable = {}
    for i, v in ipairs(self.renders) do
        local render = v.getRenderTable and v:getRenderTable() or v
        table.insertElement(renderTable, render)
    end
    MOAIRenderMgr.setRenderTable(renderTable)
end

--------------------------------------------------------------------------------
-- レンダリングの更新処理をスケジューリングします.
--------------------------------------------------------------------------------
function RenderMgr:invalidate()
    self.invalidFlag = true
end

--------------------------------------------------------------------------------
-- フレーム毎の処理を行います.
-- レンダリングテーブルを更新する必要がある場合、更新処理を行います.
--------------------------------------------------------------------------------
function RenderMgr:onEnterFrame()
    if self.invalidFlag then
        self:updateRenderTable()
        self.invalidFlag = false
    end
end

----------------------------------------------------------------------------------------------------
-- This is a utility class to execute.<br>
-- @class table
-- @name SceneMgr
----------------------------------------------------------------------------------------------------
SceneMgr = EventDispatcher()
M.SceneMgr = SceneMgr

-- variables
SceneMgr.scenes = {}
SceneMgr.currentScene = nil
SceneMgr.nextScene = nil
SceneMgr.transitioning = false

function SceneMgr:initialize()
    InputMgr:addEventListener(Event.TOUCH, self.onTouch, self)
    RenderMgr:addChild(self)
end

function SceneMgr:loadScene(sceneName, params)
    local scene = self:getSceneByName(sceneName) or Scene(sceneName)
    scene:load(params)
    
    table.removeElement(self.scenes, scene)
    table.insertElement(self.scenes, scene)
    
    return scene
end

function SceneMgr:gotoScene(sceneName, params)
    if self.transitioning then
        return
    end

    params = params or {}
    params.closing = true
    return self:openScene(sceneName, params)
end

function SceneMgr:openScene(sceneName, params)
    if self.transitioning then
        return
    end
    
    params = params or {}
    local currentScene = self.currentScene
    local nextScene = self:loadScene(sceneName, params)
    
    if not nextScene or nextScene.opened then
        return
    end
    
    self.nextScene = nextScene
    self.transitioning = true

    nextScene:open(params)
    RenderMgr:invalidate()
            
    Executors.callLater(
        function()
            if nextScene and currentScene then
                local animation = self:getSceneAnimationByName(params.animation)
                animation(currentScene, nextScene, params) 
            end
            
            if params.closing and self.currentScene then
                self.currentScene:close()
                table.removeElement(self.scenes, self.currentScene)
            end
            
            self.currentScene = self.nextScene
            self.nextScene = nil
            self.transitioning = false
            self.currentScene:start(params)
        end
    )
    
    return nextScene
end

function SceneMgr:closeScene(params)
    if self.transitioning or not self.currentScene then
        return
    end
    
    params = params or {}
    local currentScene = self.currentScene
    local nextScene = self.scenes[#self.scenes - 1]
    
    self.nextScene = nextScene
    self.transitioning = true
    
    currentScene:stop(params)
    RenderMgr:invalidate()

    Executors.callLater(
        function()
            local animation = self:getSceneAnimationByName(params.animation)
            animation(currentScene, nextScene, params) 
            
            currentScene:close(params)
            table.removeElement(self.scenes, self.currentScene)
            
            self.currentScene = self.nextScene
            self.nextScene = nil
            self.transitioning = false
            if self.currentScene then
                self.currentScene:start(params)
            end
            
            RenderMgr:invalidate()
        end
    )
    
    return true    
end

function SceneMgr:getSceneAnimationByName(name)
    local animation = name or "none"
    animation = type(animation) == "string" and SceneAnimations[animation] or animation
    return animation
end

function SceneMgr:getSceneByName(sceneName)
    for i, scene in ipairs(self.scenes) do
        if scene.name == sceneName then
            return scene
        end
    end
end

function SceneMgr:getRenderTable()
    local t = {}
    for i, scene in ipairs(self.scenes) do
        if scene.opened then
            table.insertElement(t, scene:getRenderTable())
        end
    end
    return t
end

function SceneMgr:onTouch(e)
    local scene = self.currentScene
    if scene then
        scene:dispatchEvent(e)
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
    return self:getAttr(MOAIProp.ATTR_VISIBLE) > 0
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

--------------------------------------------------------------------------------
-- Set the MOAILayer instance.
--------------------------------------------------------------------------------
function DisplayObject:setLayer(layer)
    if self.layer == layer then
        return
    end

    if self.layer then
        self.layer:removeProp(self)
    end

    self.layer = layer

    if self.layer then
        layer:insertProp(self)
    end
end

----------------------------------------------------------------------------------------------------
-- Layer
----------------------------------------------------------------------------------------------------
Layer = class(DisplayObject)
Layer.__factory = MOAILayer
M.Layer = Layer

function Layer:init()
    DisplayObject.init(self)
    local viewport = MOAIViewport.new()
    viewport:setSize(M.screenWidth, M.screenHeight)
    viewport:setScale(M.viewWidth, -M.viewHeight)
    viewport:setOffset(-1, 1)
    
    self:setViewport(viewport)
    self.viewport = viewport
    self.touchEnabled = false
    self.touchHandler = nil
end

function Layer:setTouchEnabled(value)
    if self.touchEnabled == value then
        return
    end
    self.touchEnabled = value
    if value  then
        self.touchHandler = self.touchHandler or TouchHandler(self)
    end
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
    if table.insertElement(self.children, child) then
        child:setParent(self)
        if self.layer then
            self.layer:insertProp(child)
        end
    end
end

--------------------------------------------------------------------------------
-- 子オブジェクトを削除します.
--------------------------------------------------------------------------------
function Group:removeChild(child)
    if table.removeElement(self.children, child) then
        child:setParent(nil)
        if self.layer then
            self.layer:removeProp(child)
        end
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

Scene.TOUCH_EVENT = Event(Event.TOUCH)

--------------------------------------------------------------------------------
-- コンストラクタ
--------------------------------------------------------------------------------
function Scene:init(sceneName)
    Group.init(self)
    self.loaded = false
    self.opened = false
    self.started = false
    self.name = sceneName
    self.isScene = true
    self.controller = require(sceneName)
    self.controller.scene = self
    self:initListeners()
end

function Scene:initListeners()
    local addEventListener = function(type, func, obj)
        if func then
            self:addEventListener(type, func, obj)
        end
    end
    addEventListener(Event.LOAD, self.controller.onLoad)
    addEventListener(Event.UNLOAD, self.controller.onUnload)
    addEventListener(Event.OPEN, self.controller.onOpen)
    addEventListener(Event.CLOSE, self.controller.onClose)
    addEventListener(Event.START, self.controller.onStart)
    addEventListener(Event.STOP, self.controller.onStop)
    addEventListener(Event.TOUCH, self.onTouch, self)
end

function Scene:load(params)
    if self.loaded then
        return
    end
    
    self:dispatchEvent(Event.LOAD, params)
    self.loaded = true
end

function Scene:dispose(params)
    if not self.loaded then
        return
    end

    self:dispatchEvent(Event.UNLOAD, params)
    self.loaded = false
end

function Scene:open(params)
    if self.opened then
        return
    end
    
    self:load(params)
    self:dispatchEvent(Event.OPEN, params)
    self.opened = true
end

function Scene:close(params)
    if self.opened then
        return
    end
    self:stop()
    self:dispatchEvent(Event.CLOSE, params)
    self.opened = false
end

function Scene:start(params)
    if self.started then
        return
    end
    self:open(params)
    self:dispatchEvent(Event.START, params)
    self.started = true
end

function Scene:stop(params)
    if not self.started then
        return
    end
    self:dispatchEvent(Event.STOP, params)
    self.started = false
end

function Scene:onTouch(e)
    local e2 = table.copy(e, Scene.TOUCH_EVENT)
    for i = #self.children, 1, -1 do
        local layer = self.children[i]
        if layer.touchEnabled and layer:getVisible() then
            e2.wx, e2.wy = layer:wndToWorld(e.x, e.y, 0)
            layer:dispatchEvent(e2)
        end
        if e2.stopFlag then
            e:stop()
            break
        end
    end
end

--------------------------------------------------------------------------------
-- 描画テーブルを返します.
--------------------------------------------------------------------------------
function Scene:getRenderTable()
    return self.children
end

----------------------------------------------------------------------------------------------------
-- This is a utility class to execute.<br>
-- @class table
-- @name SceneAnimations
----------------------------------------------------------------------------------------------------
SceneAnimations = {}

function SceneAnimations.none(currentScene, nextScene, params)
    nextScene:setScl(1, 1, 1)
    nextScene:setColor(1, 1, 1, 1)
    nextScene:setVisible(true)
end

function SceneAnimations.fade(currentScene, nextScene, params)
    local sec = params.second or 0.5
    nextScene:setColor(0, 0, 0, 0)
    
    MOAICoroutine.blockOnAction(currentScene:seekColor(0, 0, 0, 0, sec))
    MOAICoroutine.blockOnAction(nextScene:seekColor(1, 1, 1, 1, sec))
end

function SceneAnimations.crossFade(currentScene, nextScene, params)
    local sec = params.second or 0.5
    nextScene:setColor(0, 0, 0, 0)
    
    local action1 = currentScene:seekColor(0, 0, 0, 0, sec)
    local action2 = nextScene:seekColor(1, 1, 1, 1, sec)
    
    MOAICoroutine.blockOnAction(action1)
    MOAICoroutine.blockOnAction(action2)
end

function SceneAnimations.popIn(currentScene, nextScene, params)
    local sec = params.second or 0.5
    nextScene:setScl(0.5, 0.5, 0.5)
    nextScene:setColor(0, 0, 0, 0)

    local action1 = nextScene:seekColor(1, 1, 1, 1, sec)
    local action2 = nextScene:seekScl(1, 1, 1, sec)
    MOAICoroutine.blockOnAction(action1)
    MOAICoroutine.blockOnAction(action2)
end

function SceneAnimations.popOut(currentScene, nextScene, params)
    local sec = params.second or 0.5

    local action1 = nextScene:seekColor(0, 0, 0, 0, sec)
    local action2 = nextScene:seekScl(0.5, 0.5, 0.5, sec)
    MOAICoroutine.blockOnAction(action1)
    MOAICoroutine.blockOnAction(action2)
end

function SceneAnimations.slideLeft(currentScene, nextScene, params)
    local sec = params.second or 0.5
    MOAICoroutine.blockOnAction(nextScene:seekLoc(-display.screenWidth, 0))
end

----------------------------------------------------------------------------------------------------
-- Image
----------------------------------------------------------------------------------------------------
Image = class(DisplayObject)
M.Image = Image

function Image:init(texture, width, height)
    DisplayObject.init(self)
    
    texture = Resources.getTexture(texture)
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
    
    texture = Resources.getTexture(texture)

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
function SheetImage:setTextureAtlas(atlas, texture)
    if type(atlas) == "string" then
        atlas = Resources.getTextureAtlas(atlas, texture)
    end
    self.sheetSize = #atlas.frames
    self.sheetNames = atlas.names
    
    local deck = self.deck
    deck:reserve(self.sheetSize)
    if atlas.texture then
        deck:setTexture(atlas.texture)
        self.texture = atlas.texture
    end
    
    for i, frame in ipairs ( atlas.frames ) do
        if not self.grid then
            deck:setRect(i, unpack(frame.rect))
        end
        deck:setUVQuad(i, unpack(frame.quad))
    end
end

--------------------------------------------------------------------------------
-- フレームデータをテクスチャのカラム数から設定します.
--------------------------------------------------------------------------------
function SheetImage:setSheetSize(sizeX, sizeY, spacing, margin)
    local tw, th = self.texture:getSize()
    local cw, ch = tw / sizeX, th / sizeY
    self:setTileSize(cw, ch, spacing, margin)
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

--------------------------------------------------------------------------------
-- フレームアニメーションを設定します.
--------------------------------------------------------------------------------
function MovieClip:setAnimData(name, data)
    local curve = MOAIAnimCurve.new()
    local anim = MOAIAnim.new()

    local frames = data.frames
    local size = #frames
    curve:reserveKeys(size)
    for i = 1, size do
        curve:setKey(i, (i - 1) * data.sec, frames[i], MOAIEaseType.FLAT )
    end

    local mode = data.mode or MOAITimer.LOOP
    anim:reserveLinks(1)
    anim:setMode(mode)
    anim:setLink(1, curve, self, MOAIProp.ATTR_INDEX )
    anim:setCurve(curve)
    
    self.animTable[name] = anim
end

--------------------------------------------------------------------------------
-- 複数のフレームフレームアニメーションを設定します.
--------------------------------------------------------------------------------
function MovieClip:setAnimDatas(datas)
    for i, data in ipairs(datas) do
        local name = data.name or i
        self:setAnimData(name, data)
    end
end

--------------------------------------------------------------------------------
-- Start the animation.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Stop the animation.
--------------------------------------------------------------------------------
function MovieClip:stopAnim()
    if self.currentAnim then
        self.currentAnim:stop()
    end
end

--------------------------------------------------------------------------------
-- Check the current animation with the specified name.<br>
-- @param name Animation name.
-- @return If the current animation is true.
--------------------------------------------------------------------------------
function MovieClip:isCurrentAnim(name)
    return self.currentAnim == self.animTable[name]
end

----------------------------------------------------------------------------------------------------
-- Text
----------------------------------------------------------------------------------------------------
Label = class(DisplayObject)
Label.__factory = MOAITextBox
M.Label = Label

function Label:init(text, width, height, font, textSize)
    DisplayObject.init(self)
    
    font = Resources.getFont(font, nil, textSize)

    self:setFont(font)
    self:setRect(0, 0, width, height)
    self:setTextSize(textSize or Font.DEFAULT_POINTS)
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
-- Mesh
----------------------------------------------------------------------------------------------------
Mesh = class()
Mesh.__factory = MOAIMesh
M.Mesh = Mesh

function Mesh:init(vcoords, colors, primType)
    primType = primType or MOAIMesh.GL_TRIANGLE_FAN
    
    local vertexFormat = MOAIVertexFormat.new ()
    vertexFormat:declareCoord ( 1, MOAIVertexFormat.GL_FLOAT, 2 )
    vertexFormat:declareColor ( 2, MOAIVertexFormat.GL_UNSIGNED_BYTE )

    local vbo = MOAIVertexBuffer.new ()
    vbo:setFormat(vertexFormat)
    vbo:reserveVerts (#vcoords)
    for i=1, #vcoords do
        vbo:writeFloat(vcoords[i][1], vcoords[i][2])
        vbo:writeColor32(colors[i][1], colors[i][2], colors[i][3])
    end
    vbo:bless ()

    self:setVertexBuffer(vbo)
    self:setPrimType(primType)
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

--- Default font
Font.DEFAULT_FONT = "VL-PGothic.ttf"

--- Default font charcodes
Font.DEFAULT_CHARCODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-"

--- Default font points
Font.DEFAULT_POINTS = 24

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
-- TouchHandler
----------------------------------------------------------------------------------------------------
TouchHandler = class()
M.TouchHandler = TouchHandler
TouchHandler.TOUCH_EVENT = Event(Event.TOUCH)

--------------------------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function TouchHandler:init(layer)
    self.touchLayer = assert(layer)
    self.touchProps = {}
    
    layer:addEventListener(Event.TOUCH, self.onTouch, self)
end

--------------------------------------------------------------------------------
-- タッチした時のイベント処理を行います.
--------------------------------------------------------------------------------
function TouchHandler:onTouch(e)
    if not self.touchLayer.touchEnabled then
        return
    end
    
    -- screen to world location.
    local layer = self.touchLayer
    local partition = layer:getPartition()
    local prop = partition:propForPoint(e.wx, e.wy, 0)
    local prop2 = self.touchProps[e.idx]
    
    -- touch down prop
    if e.kind == "down" then
        self.touchProps[e.idx] = prop
    elseif e.kind == "up" then
        self.touchProps[e.idx] = nil
    end
    
    -- touch event
    local e2 = table.copy(e, self.TOUCH_EVENT)
    e2.prop = prop

    -- dispatch event
    if prop then
        self:dispatchTouchEvent(e2, prop)
    end
    if prop2 and prop2 ~= prop then
        self:dispatchTouchEvent(e2, prop2)
    end
    if prop or prop2 then
        e:stop()
    end
end

--------------------------------------------------------------------------------
-- タッチイベントを発出します.
--------------------------------------------------------------------------------
function TouchHandler:dispatchTouchEvent(e, o)
    local layer = self.touchLayer
    while o do
        if o.dispatchEvent then
            o:dispatchEvent(e)
        end
        o = o.parent
    end
end

return M
