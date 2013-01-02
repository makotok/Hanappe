----------------------------------------------------------------------------------------------------
-- Flower library is a lightweight library for Moai SDK.
--
-- MEMO:
-- English documentation has been updated.  Please contact github://Cloven with 
-- issues, questions, or problems regarding the documentation.
--
-- @author Makoto
-- @release V1.0
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- Classes
local table
local math
local class
local Executors
local Resources
local ClassFactory
local Event
local EventListener
local EventDispatcher
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
local ScaleImage
local MapImage
local MovieClip
local Label
local Rect
local Font
local Texture
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
-- Open the window.
-- Initializes the library.
-- @param title Title of the window
-- @param width Width of the window
-- @param height Height of the window
-- @param scale Scale of the Viewport to the Screen
--------------------------------------------------------------------------------
function M.openWindow(title, width, height, scale)
    M.screenWidth = width or MOAIEnvironment.horizontalResolution
    M.screenHeight = height or MOAIEnvironment.verticalResolution
    M.viewScale = scale or 1.0
    M.viewWidth = math.floor(M.screenWidth / M.viewScale)
    M.viewHeight = math.floor(M.screenHeight / M.viewScale)
    
    MOAISim.openWindow(title, M.screenWidth, M.screenHeight)
    
    InputMgr:initialize()
    RenderMgr:initialize()
    SceneMgr:initialize()
end

--------------------------------------------------------------------------------
-- Returns the size of the screen.
-- @return width, height
--------------------------------------------------------------------------------
function M.getScreenSize()
    return M.screenWidth, M.screenHeight
end

--------------------------------------------------------------------------------
-- Returns the size of the viewport.
-- @return width, height
--------------------------------------------------------------------------------
function M.getViewSize()
    return M.viewWidth, M.viewHeight
end

--------------------------------------------------------------------------------
-- Returns the texture.
-- Textures are cached.
-- @param path The path of the texture
-- @return Texture instance
--------------------------------------------------------------------------------
function M.getTexture(path)
    return Resources.getTexture(path)
end

--------------------------------------------------------------------------------
-- Reads TexturePacker output files and returns a texture atlas.
-- @param luaFilePath TexturePacker lua file path
-- @param texture (option)Path of the texture or Texture instance
-- @return Texture atlas
--------------------------------------------------------------------------------
function M.getTextureAtlas(luaFilePath, texture)
    return Resources.getTextureAtlas(luaFilePath, texture)
end

--------------------------------------------------------------------------------
-- Returns the font.
-- Fonts are cached.
-- @param path The path of the font.
-- @param charcodes (option)Charcodes of the font
-- @param points (option)Points of the font
-- @param dpi (option)Dpi of the font
-- @return Font instance
--------------------------------------------------------------------------------
function M.getFont(path, charcodes, points, dpi)
    return Resources.getFont(path, charcodes, points, dpi)
end

--------------------------------------------------------------------------------
-- Opens the scene.  This is a convenience function.
-- Delegate to SceneMgr.
-- @param sceneName module name of the Scene
-- @param params (option)Parameters of the Scene
--------------------------------------------------------------------------------
function M.openScene(sceneName, params)
    return SceneMgr:openScene(sceneName, params)
end

--------------------------------------------------------------------------------
-- Goto the Scene.  This is a convenience function.
-- Delegate to SceneMgr.
-- @param sceneName module name of the Scene
-- @param params (option)Parameters of the Scene
--------------------------------------------------------------------------------
function M.gotoScene(sceneName, params)
    return SceneMgr:gotoScene(sceneName, params)
end

--------------------------------------------------------------------------------
-- Close the Scene.  This is a convenience function.
-- Delegate to SceneMgr.
-- @param params (option)Parameters of the Scene
--------------------------------------------------------------------------------
function M.closeScene(params)
    return SceneMgr:closeScene(params)
end

--------------------------------------------------------------------------------
-- Executes a function in a MOAICoroutine.
-- This variant of the function family will run the func immediately 
-- upon the next coroutine.yield().
-- @param func function object
-- @param ... (option)function arguments
--------------------------------------------------------------------------------
function M.callOnce(func, ...)
    return Executors.callOnce(func, ...)
end

----------------------------------------------------------------------------------------------------
-- This implements object-oriented style classes in Lua, including multiple inheritance.
-- This particular variation of class implementation copies the base class
-- functions into this class, which improves speed over other implementations
-- in return for slightly larger class tables.  Please note that the inherited
-- class members are therefore cached and subsequent changes to a superclass
-- may not be reflected in your subclasses.
-- @class table
-- @name class
----------------------------------------------------------------------------------------------------
class = {}
setmetatable(class, class)
M.class = class

--------------------------------------------------------------------------------
-- This allows you to define a class by calling 'class' as a function, 
-- specifying the superclasses as a list.  For example:
-- mynewclass = class(superclass1, superclass2)
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
-- Generic constructor function for classes.
-- Note that new() will call init() if it is available in the class.
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
-- The next group of functions extends the default lua table implementation
-- to include some additional useful methods.
-- @class table
-- @name table
----------------------------------------------------------------------------------------------------
table = setmetatable({}, {__index = _G.table})
M.table = table

--------------------------------------------------------------------------------
-- Returns the position found by searching for a matching value from an array.
-- @param array table array
-- @param value Search value
-- @return the index number if the value is found, or 0 if not found.
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
-- Author:Nenad Katic
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
-- Copy the table shallowly (i.e. do not create recursive copies of values)
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
-- Copy the table deeply (i.e. create recursive copies of values)
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
-- Adds an element to the table if and only if the value did not already exist.
-- @param t table
-- @param o element
-- @return If it already exists, returns false. If it did not previously exist, returns true.
--------------------------------------------------------------------------------
function table.insertIfAbsent(t, o)
    if table.indexOf(t, o) > 0 then
        return false
    end
    t[#t + 1] = o
    return true
end

--------------------------------------------------------------------------------
-- Removes the element from the table.
-- If the element existed, then returns its index value.
-- If the element did not previously exist, then return 0.
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
-- This set of functions extends the native lua 'math' function set with
-- additional useful methods.
-- @class table
-- @name math
----------------------------------------------------------------------------------------------------
math = setmetatable({}, {__index = _G.math})
M.math = math

--------------------------------------------------------------------------------
-- Calculate the average of the values of the argument.
-- @param ... a variable number of arguments, all of which should be numbers
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
-- @param ... a variable number of arguments, all of which should be numbers
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
-- @param x1 (option)End position (note: default value is 0)
-- @param y1 (option)End position (note: default value is 0)
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
-- Get the normal vector 
-- @param x 
-- @param y
-- @return x/d, y/d
--------------------------------------------------------------------------------
function math.normalize( x, y )
    local d = math.distance( x, y )
    return x/d, y/d
end

----------------------------------------------------------------------------------------------------
-- This is a utility class for asynchronous (coroutine-style) execution.
-- @class table
-- @name Executors
----------------------------------------------------------------------------------------------------
Executors = {}
M.Executors = Executors

--------------------------------------------------------------------------------
-- Run the specified function in a loop in a coroutine, forever.
-- @param func Target function.
-- @param ... Arguments to be passed to the function.
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
-- Run the specified function once, in a coroutine, immediately
-- (upon next coroutine.yield())
-- @param func Target function.
-- @param ... Arguments.
--------------------------------------------------------------------------------
function Executors.callOnce(func, ...)
    Executors.callLaterFrame(0, func, ...)
end

--------------------------------------------------------------------------------
-- Run the specified function once, in a coroutine, after a specified delay in frames.
-- @param frame Delay frame count.
-- @param func Target function.
-- @param ... Arguments.
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
-- Run the specified function once, in a coroutine, after a specified delay in seconds.
-- @param time Delay seconds.
-- @param func Target function.
-- @param ... Arguments.
--------------------------------------------------------------------------------
function Executors.callLaterTime(time, func, ...)
    local args = {...}
    local timer = MOAITimer.new()
    timer:setSpan(time)
    timer:setListener(MOAITimer.EVENT_STOP, function() func(unpack(args)) end)
    timer:start()
end

----------------------------------------------------------------------------------------------------
-- A resource management system that caches loaded resources to maximize performance.
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
-- Loads (or obtains from its cache) a texture and returns it.
-- Textures are cached.
-- @param path The path of the texture
-- @return Texture instance
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
-- Loads (or obtains from its cache) a font and returns it.
-- @param path The path of the font.
-- @param charcodes (option)Charcodes of the font
-- @param points (option)Points of the font
-- @param dpi (option)Dpi of the font
-- @return Font instance
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
-- Reads TexturePacker output files (or obtains the result from its cache) 
-- and returns the texture atlas.
-- @param luaFilePath TexturePacker lua file path
-- @param texture (option)Path of the texture or Texture instance
-- @return Texture atlas
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
            dataFrame.quad = {uv.u0, uv.v0, uv.u0, uv.v1, uv.u1, uv.v1, uv.u1, uv.v0}
            dataFrame.rect = {0, 0, r.width, r.height}
        else
            dataFrame.quad = {uv.u0, uv.v1, uv.u1, uv.v1, uv.u1, uv.v0, uv.u0, uv.v0}
            dataFrame.rect = {0, 0, r.width, r.height}
        end
    end
    cache[luaFilePath] = data
    return data
end

----------------------------------------------------------------------------------------------------
-- Factory that creates an instance of the Class.
-- @class table
-- @name ClassFactory
----------------------------------------------------------------------------------------------------
ClassFactory = class()
M.ClassFactory = ClassFactory

--------------------------------------------------------------------------------
-- Constructor.
-- @param generator (option)It is a class to be generated
-- @param properties (option)Properties that set on the object.
--------------------------------------------------------------------------------
function ClassFactory:init(generator, properties)
    self.generator = generator
    self.properties = properties
    self.fieldAccess = false
end

--------------------------------------------------------------------------------
-- Creates an object from generator.
-- @param ... arguments of generator
-- @return object
--------------------------------------------------------------------------------
function ClassFactory:newInstance(...)
    local obj = self.generator(...)
    return self:copyPropertiesToObject(self.properties, obj, self.fieldAccess)
end

--------------------------------------------------------------------------------
-- INTERNAL USE ONLY
--------------------------------------------------------------------------------
function ClassFactory:copyPropertiesToObject(properties, obj, fieldAccess)
    if not properties then
        return obj
    end

    for k, v in pairs(properties) do
        local setterName = "set" .. k:sub(1, 1):upper() .. (#k > 1 and k:sub(2) or "")
        local setter = obj[setterName]
        
        if not fieldAccess and setter then
            setter(obj, v)
        else
            obj[k] = v
        end
    end
    return obj
end

----------------------------------------------------------------------------------------------------
-- A class for events, which are communicated to, and handled by, event handlers
-- Holds the data of the Event. 
--
-- @author Makoto
-- @class table
-- @name Event
----------------------------------------------------------------------------------------------------
Event = class()
M.Event = Event

-- Constraints
Event.CREATE            = "create"
Event.OPEN              = "open"
Event.CLOSE             = "close"
Event.OPEN_COMPLETE     = "openComplete"
Event.CLOSE_COMPLETE    = "closeComplete"
Event.START             = "start"
Event.STOP              = "stop"
Event.UPDATE            = "update"
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
Event.ENTER_FRAME       = "enterFrame"

--------------------------------------------------------------------------------
-- Event's constructor.
-- @param eventType (option)The type of event.
--------------------------------------------------------------------------------
function Event:init(eventType)
    self.type = eventType
    self.stopFlag = false
end

--------------------------------------------------------------------------------
-- INTERNAL USE ONLY -- Sets the event listener via EventDispatcher. 
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
-- A virtual superclass for EventListeners.
-- Classes which inherit from this class become able to receive events.
-- Currently intended for internal use only.
--
-- @author Makoto
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
-- This class is responsible for event notifications.
--
-- @author Makoto
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
-- Adds an event listener. 
-- will now catch the events that are sent in the dispatchEvent. 
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
-- @param eventType Type of event to be deleted
-- @param callback Callback function of event to be deleted
-- @param source (option)Source of event to be deleted
-- @return True if it can be removed
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
-- @return Returns true if you have an event listener matching the criteria.
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
-- @param event Event object or Event type name.
-- @param data Data that is set in the event.
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
-- This is a utility class which starts immediately upon library load
-- and acts as the single handler for ENTER_FRAME events (which occur
-- whenever Moai yields control to the Lua subsystem on each frame).
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
-- This singleton class manages all input events (touch, key, cursor).
--
-- @author Makoto
-- @class table
-- @name InputMgr
----------------------------------------------------------------------------------------------------
InputMgr = EventDispatcher()
M.InputMgr = InputMgr

-- Touch Events
InputMgr.TOUCH_EVENT = Event()

-- Keyboard
InputMgr.KEYBOARD_EVENT = Event()

-- Touch Event Kinds
InputMgr.TOUCH_EVENT_KINDS = {
    [MOAITouchSensor.TOUCH_DOWN]    = Event.TOUCH_DOWN,
    [MOAITouchSensor.TOUCH_UP]      = Event.TOUCH_UP,
    [MOAITouchSensor.TOUCH_MOVE]    = Event.TOUCH_MOVE,
    [MOAITouchSensor.TOUCH_CANCEL]  = Event.TOUCH_CANCEL,
}

-- pointer data
InputMgr.pointer = {x = 0, y = 0, down = false}

--------------------------------------------------------------------------------
-- Initialize.
-- Called by openWindow function.
--------------------------------------------------------------------------------
function InputMgr:initialize()

    -- Touch Handler
    local onTouch = function(eventType, idx, x, y, tapCount)
        local event = InputMgr.TOUCH_EVENT
        event.type = InputMgr.TOUCH_EVENT_KINDS[eventType]
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
        event.type = down and Event.KEY_DOWN or Event.KEY_UP
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
-- If the user has pressed a key returns true.
-- @param key Key code
-- @return true is a key is down.
--------------------------------------------------------------------------------
function InputMgr:keyIsDown(key)
    if keyboardSensor then
        return keyboardSensor:keyIsDown(key)
    end
end

----------------------------------------------------------------------------------------------------
-- This is a singleton class that manages the rendering object.
--
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
-- @param render Render object
--------------------------------------------------------------------------------
function RenderMgr:addChild(render)
    table.insertIfAbsent(self.renders, render)
    self:invalidate()
end

--------------------------------------------------------------------------------
-- Remove a Render object.
-- @param render Render object
--------------------------------------------------------------------------------
function RenderMgr:removeChild(render)
    table.removeElement(self.renders, render)
    self:invalidate()
end

--------------------------------------------------------------------------------
-- Update Moai's RenderTable with flower's render list.
--------------------------------------------------------------------------------
function RenderMgr:updateRenderTable()
    local renderTable = {}
    for i, v in ipairs(self.renders) do
        local render = v.getRenderTable and v:getRenderTable() or v
        table.insertIfAbsent(renderTable, render)
    end
    MOAIRenderMgr.setRenderTable(renderTable)
end

--------------------------------------------------------------------------------
-- Invalidate the renderTable.
--------------------------------------------------------------------------------
function RenderMgr:invalidate()
    self.invalidFlag = true
end

--------------------------------------------------------------------------------
-- Event handler for the enter frame.  Revalidates the render table if it has
-- been changed since the last frame.
--------------------------------------------------------------------------------
function RenderMgr:onEnterFrame()
    if self.invalidFlag then
        self:updateRenderTable()
        self.invalidFlag = false
    end
end

----------------------------------------------------------------------------------------------------
-- This is a singleton class to manage the scene object.
--
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
SceneMgr.sceneUpdateEnabled = true
SceneMgr.sceneFactory = nil

--------------------------------------------------------------------------------
-- Initialize.
-- Called by openWindow function.
--------------------------------------------------------------------------------
function SceneMgr:initialize()
    InputMgr:addEventListener(Event.TOUCH_DOWN, self.onTouch, self)
    InputMgr:addEventListener(Event.TOUCH_UP, self.onTouch, self)
    InputMgr:addEventListener(Event.TOUCH_MOVE, self.onTouch, self)
    InputMgr:addEventListener(Event.TOUCH_CANCEL, self.onTouch, self)
    Runtime:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
    RenderMgr:addChild(self)
    
    self.sceneFactory = self.sceneFactory or ClassFactory(Scene)
end

--------------------------------------------------------------------------------
-- Goes to a new scene.
-- Will close the current scene.
-- @param sceneName module name of the Scene
-- @param params (option)Parameters of the Scene
--------------------------------------------------------------------------------
function SceneMgr:gotoScene(sceneName, params)
    return self:internalOpenScene(sceneName, params, true)
end

--------------------------------------------------------------------------------
-- Open the Scene.
-- @param sceneName module name of the Scene
-- @param params (option)Parameters of the Scene
--------------------------------------------------------------------------------
function SceneMgr:openScene(sceneName, params)
    return self:internalOpenScene(sceneName, params, false)
end

--------------------------------------------------------------------------------
-- Open the scene for the internal implementation.
-- NOTE: FOR INTERNAL USE ONLY
--------------------------------------------------------------------------------
function SceneMgr:internalOpenScene(sceneName, params, currentCloseFlag)
    params = params or {}

    -- state check
    if self.transitioning then
        return
    end
    if self:getSceneByName(sceneName) then
        return
    end
    self.transitioning = true
    
    -- stop
    if self.currentScene then
        self.currentScene:stop(params)
    end
    
    -- create next scene
    self.nextScene = self:createScene(sceneName, params)
    self.nextScene:open(params)
    
    -- scene animation
    Executors.callOnce(
        function()
            local animation = self:getSceneAnimationByName(params.animation)
            animation(self.currentScene or Scene(), self.nextScene, params)
            
            if self.currentScene and currentCloseFlag then
                self.currentScene:close(params)
            end
            
            self.currentScene = self.nextScene
            self.nextScene = nil
            self.transitioning = false
            self.currentScene:start(params)
            
            self:dispatchEvent(Event.OPEN_COMPLETE)
        end
    )
    
    return self.nextScene
end

--------------------------------------------------------------------------------
-- Close the Scene.
-- @param params (option)Parameters of the Scene
--------------------------------------------------------------------------------
function SceneMgr:closeScene(params)
    params = params or {}

    -- state check
    if self.transitioning or not self.currentScene then
        return
    end
    self.transitioning = true
    
    -- set next scene
    self.nextScene = self.scenes[#self.scenes - 1]
    self.currentScene:stop(params)

    Executors.callOnce(
        function()
            local animation = self:getSceneAnimationByName(params.animation)
            animation(self.currentScene, self.nextScene or Scene(), params) 
            
            self.currentScene:close(params)
            self.currentScene = self.nextScene
            self.nextScene = nil
            self.transitioning = false

            if self.currentScene then
                self.currentScene:start(params)
            end

            self:dispatchEvent(Event.CLOSE_COMPLETE)
        end
    )
    
    return true    
end

--------------------------------------------------------------------------------
-- Create the Scene.
-- NOTE: FOR INTERNAL USE ONLY
--------------------------------------------------------------------------------
function SceneMgr:createScene(sceneName, params)
    local sceneFactory = params.sceneFactory or self.sceneFactory
    return sceneFactory:newInstance(sceneName, params)
end

--------------------------------------------------------------------------------
-- Return the scene transition animation with the specified name.
-- If you do not specify a name, will return to the default animation ('change').
-- @param name Animation name of the SceneAnimations
-- @return animation function
--------------------------------------------------------------------------------
function SceneMgr:getSceneAnimationByName(name)
    local animation = name or "change"
    animation = type(animation) == "string" and SceneAnimations[animation] or animation
    return animation
end

--------------------------------------------------------------------------------
-- Find a scene by its name.
-- @param sceneName name of the Scene.
-- @return Scene object
--------------------------------------------------------------------------------
function SceneMgr:getSceneByName(sceneName)
    for i, scene in ipairs(self.scenes) do
        if scene.name == sceneName then
            return scene
        end
    end
end

--------------------------------------------------------------------------------
-- Add a scene.
-- @param scene scene
-- @return True if this scene didn't already exist in the list.
--------------------------------------------------------------------------------
function SceneMgr:addScene(scene)
    RenderMgr:invalidate()
    return table.insertIfAbsent(self.scenes, scene)
end

--------------------------------------------------------------------------------
-- Remove a scene.
-- @param scene scene
-- @return a number if the scene was removed; false if it wasn't there in the first place.
--------------------------------------------------------------------------------
function SceneMgr:removeScene(scene)
    RenderMgr:invalidate()
    return table.removeElement(self.scenes, scene)
end

--------------------------------------------------------------------------------
-- Returns the render table.
-- Used in RenderMgr.
-- @return Render table
--------------------------------------------------------------------------------
function SceneMgr:getRenderTable()
    local t = {}
    for i, scene in ipairs(self.scenes) do
        if scene.opened then
            table.insertIfAbsent(t, scene:getRenderTable())
        end
    end
    return t
end

--------------------------------------------------------------------------------
-- The event handler is called when you touch the screen.
-- Touch to fire a event to Scene.
-- @param e Touch event
--------------------------------------------------------------------------------
function SceneMgr:onTouch(e)
    local scene = self.currentScene
    if scene then
        scene:dispatchEvent(e)
    end
end

--------------------------------------------------------------------------------
-- The event handler is called when enter frame.
-- Fire a event to Scene.
-- @param e Enter frame event
--------------------------------------------------------------------------------
function SceneMgr:onEnterFrame(e)
    if not self.sceneUpdateEnabled then
        return
    end
    
    for i, scene in ipairs(self.scenes) do
        if scene.sceneUpdateEnabled then
            scene:dispatchEvent(Event.UPDATE)
        end
    end
end

----------------------------------------------------------------------------------------------------
-- The base class of the display object, adding several useful methods.
--
-- @author Makoto
-- @class table
-- @name DisplayObject
----------------------------------------------------------------------------------------------------
DisplayObject = class(EventDispatcher)
DisplayObject.__factory = MOAIProp
M.DisplayObject = DisplayObject

--------------------------------------------------------------------------------
-- Returns the width.
-- @return width
--------------------------------------------------------------------------------
function DisplayObject:getWidth()
    local w, h, d = self:getDims()
    return w
end

--------------------------------------------------------------------------------
-- Returns the height.
-- @return height
--------------------------------------------------------------------------------
function DisplayObject:getHeight()
    local w, h, d = self:getDims()
    return h
end

--------------------------------------------------------------------------------
-- Sets the position.
-- @param left Left position
-- @param left Top position
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
-- Returns the position.
-- @return Left, Top.
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
-- Returns the left position.
-- @return left
--------------------------------------------------------------------------------
function DisplayObject:getLeft()
    local left, top = self:getPos()
    return left
end

--------------------------------------------------------------------------------
-- Returns the top position.
-- @return top
--------------------------------------------------------------------------------
function DisplayObject:getTop()
    local left, top = self:getPos()
    return top
end

--------------------------------------------------------------------------------
-- Returns the right position.
-- @return right
--------------------------------------------------------------------------------
function DisplayObject:getRight()
    local left, top = self:getPos()
    local width, height = self:getDims()
    return left + width
end

--------------------------------------------------------------------------------
-- Returns the bottom position.
-- @return bottom
--------------------------------------------------------------------------------
function DisplayObject:getBottom()
    local left, top = self:getPos()
    local width, height = self:getDims()
    return top + height
end

--------------------------------------------------------------------------------
-- Returns the color.
-- @return red, green, blue, alpha
--------------------------------------------------------------------------------
function DisplayObject:getColor()
    local r = self:getAttr(MOAIColor.ATTR_R_COL)
    local g = self:getAttr(MOAIColor.ATTR_G_COL)
    local b = self:getAttr(MOAIColor.ATTR_B_COL)
    local a = self:getAttr(MOAIColor.ATTR_A_COL)
    return r, g, b, a
end

--------------------------------------------------------------------------------
-- Sets the piv (the anchor around which the object can 'pivot') to the object's center.
--------------------------------------------------------------------------------
function DisplayObject:setPivToCenter()
    local w, h, d = self:getDims()
    local left, top = self:getPos()
    self:setPiv(w / 2, h / 2, 0)
    self:setPos(left, top)
end

--------------------------------------------------------------------------------
-- Returns whether or not the object is currently visible or invisible.
-- @return visible
--------------------------------------------------------------------------------
function DisplayObject:getVisible()
    return self:getAttr(MOAIProp.ATTR_VISIBLE) > 0
end

--------------------------------------------------------------------------------
-- Sets the object's parent, inheriting its color and transform.
-- @param parent parent
--------------------------------------------------------------------------------
function DisplayObject:setParent(parent)
    self.parent = parent
 
    self:clearAttrLink(MOAIColor.INHERIT_COLOR)
    self:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
    if parent then
        self:setAttrLink(MOAIColor.INHERIT_COLOR, parent, MOAIColor.COLOR_TRAIT)
        self:setAttrLink(MOAITransform.INHERIT_TRANSFORM, parent, MOAITransform.TRANSFORM_TRAIT)
    end
end

--------------------------------------------------------------------------------
-- Insert the DisplayObject's prop into a given Moai layer.
-- @param layer
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
-- This is flower's idea of a Layer, which is a superclass of the MOAI concept of Layer.
--
-- @author Makoto
-- @class table
-- @name Layer
----------------------------------------------------------------------------------------------------
Layer = class(DisplayObject)
Layer.__factory = MOAILayer
M.Layer = Layer

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function Layer:init()
    DisplayObject.init(self)

    local partition = MOAIPartition.new()
    self:setPartition(partition)
    self.partition = partition
    
    local viewport = MOAIViewport.new()
    viewport:setSize(M.screenWidth, M.screenHeight)
    viewport:setScale(M.viewWidth, -M.viewHeight)
    viewport:setOffset(-1, 1)

    self:setViewport(viewport)
    self.viewport = viewport
    self.touchEnabled = false
    self.touchHandler = nil
end

--------------------------------------------------------------------------------
-- Enables this layer for touch events.
-- @param value enabled
--------------------------------------------------------------------------------
function Layer:setTouchEnabled(value)
    if self.touchEnabled == value then
        return
    end
    self.touchEnabled = value
    if value  then
        self.touchHandler = self.touchHandler or TouchHandler(self)
    end
end

--------------------------------------------------------------------------------
-- Sets the scene for this layer.
-- @param scene scene
--------------------------------------------------------------------------------
function Layer:setScene(scene)
    if self.scene == scene then
        return
    end

    if self.scene then
        self.scene:removeChild(self)
    end
    
    self.scene = scene

    if self.scene then
        self.scene:addChild(self)
    end
end

----------------------------------------------------------------------------------------------------
-- flower's idea of a Camera, which is a superclass of the Moai Camera.
--
-- @author Makoto
-- @class table
-- @name Camera
----------------------------------------------------------------------------------------------------
Camera = class()
Camera.__factory = MOAICamera
M.Camera = Camera

--------------------------------------------------------------------------------
-- The constructor.
-- @param ortho (option)ortho
-- @param near (option)near plane
-- @param far (option)far plane
--------------------------------------------------------------------------------
function Camera:init(ortho, near, far)
    ortho = ortho ~= nil and ortho or true
    near = near or 1
    far = far or -1

    self:setOrtho(ortho)
    self:setNearPlane(near)
    self:setFarPlane(far)
end

----------------------------------------------------------------------------------------------------
-- A class to manage and control sets of DisplayObjects.
--
-- @author Makoto
-- @class table
-- @name Group
----------------------------------------------------------------------------------------------------
Group = class(DisplayObject)
M.Group = Group

--------------------------------------------------------------------------------
-- The constructor.
-- @param layer (option)layer object
-- @param width (option)width
-- @param height (option)height
--------------------------------------------------------------------------------
function Group:init(layer, width, height)
    DisplayObject.init(self)
    self.children = {}
    self.isGroup = true
    self.layer = layer
    self.width = width or 0
    self.height = height or 0
    
    self:setPivToCenter()
end

--------------------------------------------------------------------------------
-- Sets the size.
-- This is the size of a Group, rather than of the children.
-- @param width width
-- @param height height
--------------------------------------------------------------------------------
function Group:setSize(width, height)
    self.width = width
    self.height = height
end

--------------------------------------------------------------------------------
-- Returns the size.
-- @return width, height, 0
--------------------------------------------------------------------------------
function Group:getDims()
    return self.width, self.height, 0
end

--------------------------------------------------------------------------------
-- Returns the bounds.
-- @return xMin, yMin, zMin, xMax, yMax, zMax
--------------------------------------------------------------------------------
function Group:getBounds()
    return 0, 0, 0, self.width, self.height, 0
end

--------------------------------------------------------------------------------
-- Adds the specified child.
-- @param child DisplayObject
--------------------------------------------------------------------------------
function Group:addChild(child)
    if table.insertIfAbsent(self.children, child) then
        child:setParent(self)

        if child.setLayer then
            child:setLayer(self.layer)
        elseif self.layer then
            self.layer:insertProp(child)
        end

        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Removes a child.
-- @param child DisplayObject
-- @return True if removed.
--------------------------------------------------------------------------------
function Group:removeChild(child)
    if table.removeElement(self.children, child) then
        child:setParent(nil)

        if child.setLayer then
            child:setLayer(nil)
        elseif self.layer then
            self.layer:removeProp(child)
        end
        
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Returns a child by name.
-- @param name child's name
-- @return child
--------------------------------------------------------------------------------
function Group:getChildByName(name)
    for i, child in ipairs(self.children) do
        if child.name == name then
            return child
        end
    end
end

--------------------------------------------------------------------------------
-- Sets the layer for this group to use.
-- @param layer MOAILayer object
--------------------------------------------------------------------------------
function Group:setLayer(layer)
    if self.layer == layer then
        return
    end

    if self.layer then
        for i, v in ipairs(self.children) do
            if v.setLayer then
                v:setLayer(nil)
            else
                self.layer:removeProp(v)
            end
        end
    end

    self.layer = layer

    if self.layer then
        for i, v in ipairs(self.children) do
            if v.setLayer then
                v:setLayer(self.layer)
            else
                self.layer:insertProp(v)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Sets the group's visibility.
-- Also sets the visibility of any children.
-- @param value visible
--------------------------------------------------------------------------------
function Group:setVisible(value)
    local I = MOAIProp.getInterfaceTable()
    I.setVisible(self, value)
    
    for i, v in ipairs(self.children) do
        v:setVisible(value)
    end
end

----------------------------------------------------------------------------------------------------
-- A scene class, handling display on one or more layers and receiving events from the EventMgr.
--
-- Object is controlled by SceneMgr; use that class to manipulate scenes.
-- 
-- @author Makoto
-- @class table
-- @name Scene
----------------------------------------------------------------------------------------------------
Scene = class(Group)
M.Scene = Scene

Scene.TOUCH_EVENT = Event()

--------------------------------------------------------------------------------
-- The constructor.
-- @param sceneName Module name
-- @param params Scene parameters
--------------------------------------------------------------------------------
function Scene:init(sceneName, params)
    Group.init(self, nil, M.screenWidth, M.screenHeight)
    self.name = sceneName
    self.isScene = true
    self.opened = false
    self.started = false
    self.sceneUpdateEnabled = false
    self.controller = self:createController(params)
    self.controller.scene = self
    self:initListeners()
    
    self:dispatchEvent(Event.CREATE, params)
end

--------------------------------------------------------------------------------
-- INTERNAL USE ONLY -- create the scene controller. 
--------------------------------------------------------------------------------
function Scene:createController(params)
    params = params or {}
    
    local sceneController = params.sceneController
    if sceneController then
        return type(sceneController) == "string" and require(sceneController) or sceneController
    end
    
    local sceneName = self.name
    return sceneName and require(sceneName) or {}
end

--------------------------------------------------------------------------------
-- INTERNAL USE ONLY -- initialize event listeners.
--------------------------------------------------------------------------------
function Scene:initListeners()
    local addEventListener = function(type, func, obj)
        if func then
            self:addEventListener(type, func, obj)
        end
    end
    addEventListener(Event.CREATE, self.controller.onCreate)
    addEventListener(Event.OPEN, self.controller.onOpen)
    addEventListener(Event.CLOSE, self.controller.onClose)
    addEventListener(Event.START, self.controller.onStart)
    addEventListener(Event.STOP, self.controller.onStop)
    addEventListener(Event.UPDATE, self.controller.onUpdate)
    addEventListener(Event.TOUCH_DOWN, self.onTouch, self)
    addEventListener(Event.TOUCH_UP, self.onTouch, self)
    addEventListener(Event.TOUCH_MOVE, self.onTouch, self)
    addEventListener(Event.TOUCH_CANCEL, self.onTouch, self)
end

--------------------------------------------------------------------------------
-- Open the scene.
-- Scenes add themselves to the SceneMgr when opened.
-- @param params Scene event parameters.(event.data)
--------------------------------------------------------------------------------
function Scene:open(params)
    if self.opened then
        return
    end
    
    self:dispatchEvent(Event.OPEN, params)
    self.opened = true
    SceneMgr:addScene(self)
end

--------------------------------------------------------------------------------
-- Close the scene, removing it from the SceneMgr.
-- @param params Scene event parameters.(event.data)
--------------------------------------------------------------------------------
function Scene:close(params)
    if not self.opened then
        return
    end
    self:stop()
    self:dispatchEvent(Event.CLOSE, params)
    SceneMgr:removeScene(self)
end

--------------------------------------------------------------------------------
-- Start the scene.
-- Start event is issued.
-- @param params Scene event parameters.(event.data)
--------------------------------------------------------------------------------
function Scene:start(params)
    if self.started or not self.opened then
        return
    end
    self:dispatchEvent(Event.START, params)
    self.started = true
    self.paused = false
    self.sceneUpdateEnabled = true
end

--------------------------------------------------------------------------------
-- Stop the scene.
-- Stop event is issued.
-- @param params Scene event parameters.(event.data)
--------------------------------------------------------------------------------
function Scene:stop(params)
    if not self.started then
        return
    end
    self:dispatchEvent(Event.STOP, params)
    self.started = false
    self.sceneUpdateEnabled = false
end

--------------------------------------------------------------------------------
-- Handle touch events sent by the EventMgr.
--------------------------------------------------------------------------------
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
-- Returns the rendering table.
-- Used by RenderMgr.
-- @return rendering table
--------------------------------------------------------------------------------
function Scene:getRenderTable()
    return self.children
end

----------------------------------------------------------------------------------------------------
-- A class to handle transitions between scenes and defining various animations for those transitions.
-- 
-- @class table
-- @name SceneAnimations
----------------------------------------------------------------------------------------------------
SceneAnimations = {}

function SceneAnimations.change(currentScene, nextScene, params)
    currentScene:setVisible(false)

    nextScene:setScl(1, 1, 1)
    nextScene:setColor(1, 1, 1, 1)
    nextScene:setPos(0, 0)
    nextScene:setVisible(true)
end

function SceneAnimations.overlay(currentScene, nextScene, params)
    nextScene:setScl(1, 1, 1)
    nextScene:setColor(1, 1, 1, 1)
    nextScene:setPos(0, 0)
    nextScene:setVisible(true)
end

function SceneAnimations.fade(currentScene, nextScene, params)
    local sec = params.second or 0.5

    nextScene:setVisible(true)
    nextScene:setColor(0, 0, 0, 0)

    MOAICoroutine.blockOnAction(currentScene:seekColor(0, 0, 0, 0, sec))
    MOAICoroutine.blockOnAction(nextScene:seekColor(1, 1, 1, 1, sec))
    
    currentScene:setVisible(false)
end

function SceneAnimations.crossFade(currentScene, nextScene, params)
    local sec = params.second or 0.5

    nextScene:setVisible(true)
    nextScene:setColor(0, 0, 0, 0)
    
    local action1 = currentScene:seekColor(0, 0, 0, 0, sec)
    local action2 = nextScene:seekColor(1, 1, 1, 1, sec)
    MOAICoroutine.blockOnAction(action1)
    
    currentScene:setVisible(false)
end

function SceneAnimations.popIn(currentScene, nextScene, params)
    local sec = params.second or 0.5
    
    nextScene:setVisible(true)
    nextScene:setScl(0.5, 0.5, 0.5)
    nextScene:setColor(0, 0, 0, 0)

    local action1 = nextScene:seekColor(1, 1, 1, 1, sec)
    local action2 = nextScene:seekScl(1, 1, 1, sec)
    MOAICoroutine.blockOnAction(action1)
end

function SceneAnimations.popOut(currentScene, nextScene, params)
    local sec = params.second or 0.5

    local action1 = currentScene:seekColor(0, 0, 0, 0, sec)
    local action2 = currentScene:seekScl(0.5, 0.5, 0.5, sec)
    MOAICoroutine.blockOnAction(action1)
end

function SceneAnimations.slideLeft(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local sw, sh = M.getScreenSize()

    nextScene:setVisible(true)
    nextScene:setPos(sw, 0)
    
    local action1 = currentScene:moveLoc(-sw, 0, 0, sec)
    local action2 = nextScene:moveLoc(-sw, 0, 0, sec)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    nextScene:setPos(0, 0)
end

function SceneAnimations.slideRight(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local sw, sh = M.getScreenSize()

    nextScene:setVisible(true)
    nextScene:setPos(-sw, 0)
    
    local action1 = currentScene:moveLoc(sw, 0, 0, sec)
    local action2 = nextScene:moveLoc(sw, 0, 0, sec)
    MOAICoroutine.blockOnAction(action1)
    
    currentScene:setVisible(false)
    nextScene:setPos(0, 0)
end

function SceneAnimations.slideTop(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local sw, sh = M.getScreenSize()

    nextScene:setVisible(true)
    nextScene:setPos(0, sh)
    
    local action1 = currentScene:moveLoc(0, -sh, 0, sec)
    local action2 = nextScene:moveLoc(0, -sh, 0, sec)
    MOAICoroutine.blockOnAction(action1)
    
    currentScene:setVisible(false)
    nextScene:setPos(0, 0)
end

function SceneAnimations.slideBottom(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local sw, sh = M.getScreenSize()

    nextScene:setVisible(true)
    nextScene:setPos(0, -sh)
    
    local action1 = currentScene:moveLoc(0, sh, 0, sec)
    local action2 = nextScene:moveLoc(0, sh, 0, sec)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    nextScene:setPos(0, 0)
end

----------------------------------------------------------------------------------------------------
-- Class to display a simple texture.
-- 
-- @class table
-- @name Image
----------------------------------------------------------------------------------------------------
Image = class(DisplayObject)
M.Image = Image

--------------------------------------------------------------------------------
-- Constructor.
-- @param texture Texture path, or texture.
-- @param width (option) Width of image.
-- @param height (option) Height of image.
--------------------------------------------------------------------------------
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
    
    self:setPivToCenter()
end

--------------------------------------------------------------------------------
-- Sets the size.
-- @param width Width of image.
-- @param height Height of image.
--------------------------------------------------------------------------------
function Image:setSize(width, height)
    deck:setRect(0, 0, width, height)
    self:setPivToCenter()
end

--------------------------------------------------------------------------------
-- Sets the texture.
-- @param texture Texture path, or texture
--------------------------------------------------------------------------------
function Image:setTexture(texture)
    self.texture = Resources.getTexture(texture)
    self.deck:setTexture(texture)
    local tw, th = self.texture:getSize()
    self:setSize(tw, th)
end

----------------------------------------------------------------------------------------------------
-- Class that displays an image from a sheet of images, supporting TexturePacker's format.
-- 
-- @class table
-- @name SheetImage
----------------------------------------------------------------------------------------------------
SheetImage = class(DisplayObject)
M.SheetImage = SheetImage

--------------------------------------------------------------------------------
-- Constructor.
-- @param texture Texture path, or texture
-- @param sizeX (option) The size of the sheet
-- @param sizeY (option) The size of the sheet
--------------------------------------------------------------------------------
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
-- Parses TexturePacker atlases and sets up the texture as a deck of images in the atlas.
-- @param atlas Texture atlas
-- @param texture Texture path, or texture
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
-- Sets the size of the sheet (for quad-tiled texture atlas sheets).
-- @param sizeX The size of the sheet
-- @param sizeY The size of the sheet
-- @param spacing (option)Spacing of the tiles
-- @param margin (option)Margin of the sheet
--------------------------------------------------------------------------------
function SheetImage:setSheetSize(sizeX, sizeY, spacing, margin)
    local tw, th = self.texture:getSize()
    local cw, ch = tw / sizeX, th / sizeY
    self:setTileSize(cw, ch, spacing, margin)
end

--------------------------------------------------------------------------------
-- Sets the sheet depending on the size of the tile.
-- @param tileWidth The width of the tile
-- @param tileHeight The height of the tile
-- @param spacing (option)Spacing of the tiles
-- @param margin (option)Margin of the sheet
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
-- Sets the sheet's image index via a given subtexture name (for TexturePacker).
-- @param name Sheet name.
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
-- Class that loads a tiled map of images (see MOAIGrid).
-- 
-- @class table
-- @name MapImage
----------------------------------------------------------------------------------------------------
MapImage = class(SheetImage)
M.MapImage = MapImage

--------------------------------------------------------------------------------
-- Constructor.
-- @param texture Texture path, or texture
-- @param gridWidth (option) The size of the grid
-- @param gridHeight (option) The size of the grid
-- @param tileWidth (option) The size of the tile
-- @param tileHeight (option) The size of the tile
-- @param spacing (option) The spacing of the tile
-- @param margin (option) The margin of the tile
--------------------------------------------------------------------------------
function MapImage:init(texture, gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    SheetImage.init(self, texture)
    
    self.grid = MOAIGrid.new()
    self:setGrid(self.grid)
    
    if gridWidth and gridHeight and tileWidth and tileHeight then
        self:setMapSize(gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    end
end

--------------------------------------------------------------------------------
-- Sets the size of the map grid.
-- @param gridWidth (option) The size of the grid
-- @param gridHeight (option) The size of the grid
-- @param tileWidth (option) The size of the tile
-- @param tileHeight (option) The size of the tile
-- @param spacing (option) The spacing of the tile
-- @param margin (option) The margin of the tile
--------------------------------------------------------------------------------
function MapImage:setMapSize(gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    self.grid:setSize(gridWidth, gridHeight, tileWidth, tileHeight)
    self:setTileSize(tileWidth, tileHeight, spacing, margin)
end

--------------------------------------------------------------------------------
-- Sets the map data by rows.
-- @param rows Multiple rows of data.
--------------------------------------------------------------------------------
function MapImage:setRows(rows)
    for i, row in ipairs(rows) do
        self:setRow(i, unpack(row))
    end
end

--------------------------------------------------------------------------------
-- Sets the map row data.
-- @params ... rows of data.
--------------------------------------------------------------------------------
function MapImage:setRow(...)
    self.grid:setRow(...)
end

--------------------------------------------------------------------------------
-- Sets the map value.
-- @params tile x.
-- @params tile y.
-- @params tile value.
--------------------------------------------------------------------------------
function MapImage:setTile(x, y, value)
    self.grid:setTile(x, y, value)
end

--------------------------------------------------------------------------------
-- Returns the map value.
-- @params tile x.
-- @params tile y.
-- @return tile value.
--------------------------------------------------------------------------------
function MapImage:getTile(x, y)
    return self.grid:getTile(x, y)
end

--------------------------------------------------------------------------------
-- Sets the repeat flag.
-- @param repeatX
-- @param repeatY
--------------------------------------------------------------------------------
function MapImage:setRepeat(repeatX, repeatY)
    self.grid:setRepeat(repeatX, repeatY)
end

----------------------------------------------------------------------------------------------------
-- Class for animated texture atlases ('MovieClip' is the Adobe Flash terminology)
--
-- @class table
-- @name MapImage
----------------------------------------------------------------------------------------------------
MovieClip = class(SheetImage)
M.MovieClip = MovieClip

--------------------------------------------------------------------------------
-- Constructor.
-- @param texture Texture path, or texture
-- @param sizeX (option) The size of the sheet
-- @param sizeY (option) The size of the sheet
--------------------------------------------------------------------------------
function MovieClip:init(texture, sizeX, sizeY)
    SheetImage.init(self, texture, sizeX, sizeY)
    self.animTable = {}
    self.currentAnim = nil
end

--------------------------------------------------------------------------------
-- Sets the custom animation.
-- @params name Name of anim
-- @params anim Anim object
--------------------------------------------------------------------------------
function MovieClip:setAnim(name, anim)
    self.animTable[name] = anim
end

--------------------------------------------------------------------------------
-- Sets the animation data.
-- The frame is interpolated from the data.
-- @param name Name of anim
-- @param data Animation data
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
-- Sets multiple animation data up at the same time (convenience function).
-- @param datas Multiple data
--------------------------------------------------------------------------------
function MovieClip:setAnimDatas(datas)
    for i, data in ipairs(datas) do
        local name = data.name or i
        self:setAnimData(name, data)
    end
end

--------------------------------------------------------------------------------
-- Start the animation.
-- @param name Name of anim
--------------------------------------------------------------------------------
function MovieClip:playAnim(name)
    local currentAnim = self.currentAnim
    local animTable = self.animTable
    
    if currentAnim and currentAnim:isBusy() then
        currentAnim:stop()
    end
    if name and animTable[name] then
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
-- Check the current animation with the specified name.
-- @param name Animation name.
-- @return If the current animation is true.
--------------------------------------------------------------------------------
function MovieClip:isCurrentAnim(name)
    return self.currentAnim == self.animTable[name]
end

--------------------------------------------------------------------------------
-- Returns whether the running.
-- @return True if busy
--------------------------------------------------------------------------------
function MovieClip:isBusy()
    return self.currentAnim and self.currentAnim:isBusy() or false
end

----------------------------------------------------------------------------------------------------
-- Label for text display.
-- Based on MOAITextBox.
-- 
-- @class table
-- @name Label
----------------------------------------------------------------------------------------------------
Label = class(DisplayObject)
Label.__factory = MOAITextBox
M.Label = Label

--------------------------------------------------------------------------------
-- Constructor.
-- @param text Text
-- @param width Width
-- @param height Height
-- @param font (option) Font path, or Font object
-- @param textSize (option) TextSize
--------------------------------------------------------------------------------
function Label:init(text, width, height, font, textSize)
    DisplayObject.init(self)
    
    font = Resources.getFont(font, nil, textSize)

    self:setFont(font)
    self:setRect(0, 0, width, height)
    self:setTextSize(textSize or Font.DEFAULT_POINTS)
    self:setString(text)
end

--------------------------------------------------------------------------------
-- Sets the size.
-- @params width Width
-- @params height Height
--------------------------------------------------------------------------------
function Label:setSize(width, height)
    self:setRect(0, 0, width, height)
end

----------------------------------------------------------------------------------------------------
-- Class to fill a rectangle.
-- NOTE: This uses immediate mode drawing and so has a high performance impact when
-- used on mobile devices.  You may wish to use a 1-pixel high Image instead if you
-- wish to minimize draw calls.
-- 
-- @class table
-- @name Rect
----------------------------------------------------------------------------------------------------
Rect = class(DisplayObject)
M.Rect = Rect

--------------------------------------------------------------------------------
-- Constructor.
-- @param width Width
-- @param height Height
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Sets the size.
-- @params width Width
-- @params height Height
--------------------------------------------------------------------------------
function Rect:setSize(width, height)
    self.deck:setRect(0, 0, width, height)
end

----------------------------------------------------------------------------------------------------
-- Texture class.
-- 
-- @class table
-- @name Texture
----------------------------------------------------------------------------------------------------
Texture = class()
Texture.__factory = MOAITexture
M.Texture = Texture

--------------------------------------------------------------------------------
-- Constructor.
-- @param path Texture path
--------------------------------------------------------------------------------
function Texture:init(path)
    self:load(path)
    self.path = path
end

----------------------------------------------------------------------------------------------------
-- Font class.
-- 
-- @class table
-- @name Font
----------------------------------------------------------------------------------------------------
Font = class()
Font.__factory = MOAIFont

--- Default font
Font.DEFAULT_FONT = "VL-PGothic.ttf"

--- Default font charcodes
Font.DEFAULT_CHARCODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-"

--- Default font points
Font.DEFAULT_POINTS = 24

--------------------------------------------------------------------------------
-- Constructor.
-- @param path Font path
-- @param charcodes (option) Font charcodes
-- @param points (option) Font points
-- @param dpi (option) Font dpi
--------------------------------------------------------------------------------
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
-- Class to perform the handling of touch events emitted from a layer.
--
-- @class table
-- @name TouchHandler
----------------------------------------------------------------------------------------------------
TouchHandler = class()
M.TouchHandler = TouchHandler

-- Constraints
TouchHandler.TOUCH_EVENT = Event()

--------------------------------------------------------------------------------
-- The constructor.
-- @param layer Layer object
--------------------------------------------------------------------------------
function TouchHandler:init(layer)
    self.touchLayer = assert(layer)
    self.touchProps = {}
    
    layer:addEventListener(Event.TOUCH_DOWN, self.onTouch, self)
    layer:addEventListener(Event.TOUCH_UP, self.onTouch, self)
    layer:addEventListener(Event.TOUCH_MOVE, self.onTouch, self)
    layer:addEventListener(Event.TOUCH_CANCEL, self.onTouch, self)
end

--------------------------------------------------------------------------------
-- Event handler when you touch a layer.
-- @param e Event object
--------------------------------------------------------------------------------
function TouchHandler:onTouch(e)
    if not self.touchLayer.touchEnabled then
        return
    end
    
    -- screen to world location.
    local prop = self:getTouchableProp(e)
    local prop2 = self.touchProps[e.idx]
    
    -- touch down prop
    if e.type == Event.TOUCH_DOWN then
        self.touchProps[e.idx] = prop
    elseif e.type == Event.TOUCH_UP then
        self.touchProps[e.idx] = nil
    elseif e.type == Event.TOUCH_CANCEL then
        self.touchProps[e.idx] = nil
    end
    
    -- touch event
    local e2 = table.copy(e, self.TOUCH_EVENT)

    -- dispatch event
    if prop then
        e2.prop = prop
        self:dispatchTouchEvent(e2, prop)
    end
    if prop2 and prop2 ~= prop then
        e2.prop = prop2
        self:dispatchTouchEvent(e2, prop2)
    end
    if prop or prop2 then
        e:stop()
    end
end

function TouchHandler:getTouchableProp(e)
    local layer = self.touchLayer
    local partition = layer:getPartition()
    local sortMode = layer:getSortMode()
    local props = {partition:propListForPoint(e.wx, e.wy, 0, sortMode)}
    for i = #props, 1, -1 do
        local prop = props[i]
        if prop:getAttr(MOAIProp.ATTR_VISIBLE) > 0 then
            return prop
        end
    end
end

--------------------------------------------------------------------------------
-- Fire touch handler events on a given object.
-- @param e Event object
-- @param o Display object
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

--------------------------------------------------------------------------------
-- Remove the handler from the layer, and release resources.
--------------------------------------------------------------------------------
function TouchHandler:dispose()
    local layer = self.touchLayer
    
    layer:removeEventListener(Event.TOUCH_DOWN, self.onTouch, self)
    layer:removeEventListener(Event.TOUCH_UP, self.onTouch, self)
    layer:removeEventListener(Event.TOUCH_MOVE, self.onTouch, self)
    layer:removeEventListener(Event.TOUCH_CANCEL, self.onTouch, self)
end

return M
