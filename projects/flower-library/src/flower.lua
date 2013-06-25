----------------------------------------------------------------------------------------------------
-- Flower library is a lightweight library for Moai SDK.
-- https://github.com/makotok/Hanappe
--
-- MEMO:
-- English documentation has been updated.  Please contact github://Cloven with
-- issues, questions, or problems regarding the documentation.
--
-- @author Makoto
-- @release V2.1.2
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- Classes
local table
local math
local class
local Executors
local Resources
local PropertyUtils
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
local MapImage
local MovieClip
local NineImage
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

-- interfaces
local MOAIPropInterface = MOAIProp.getInterfaceTable()
local MOAILayerInterface = MOAILayer.getInterfaceTable()
local MOAICameraInterface = MOAICamera.getInterfaceTable()
local MOAITextureInterface = MOAITexture.getInterfaceTable()
local MOAITextBoxInterface = MOAITextBox.getInterfaceTable()
local MOAIFontInterface = MOAIFont.getInterfaceTable()

----------------------------------------------------------------------------------------------------
-- Public Const
----------------------------------------------------------------------------------------------------

--- default width of the screen
M.DEFAULT_SCREEN_WIDTH = MOAIEnvironment.horizontalResolution or 320

--- default height of the screen
M.DEFAULT_SCREEN_HEIGHT = MOAIEnvironment.verticalResolution or 480

--- default scale of the viewport
M.DEFAULT_VIEWPORT_SCALE = 1

----------------------------------------------------------------------------------------------------
-- Public functions
----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Open the window.
-- Initializes the library.
-- @param title Title of the window
-- @param width Width of the window
-- @param height Height of the window
-- @param scale (Option)Scale of the Viewport to the Screen
--------------------------------------------------------------------------------
function M.openWindow(title, width, height, scale)
    width = width or M.DEFAULT_SCREEN_WIDTH
    height = height or M.DEFAULT_SCREEN_HEIGHT
    scale = scale or M.DEFAULT_VIEWPORT_SCALE

    M.updateDisplaySize(width, height, scale)

    Runtime:initialize()
    InputMgr:initialize()
    RenderMgr:initialize()
    SceneMgr:initialize()

    MOAISim.openWindow(title, M.screenWidth, M.screenHeight)
end

--------------------------------------------------------------------------------
-- Update the screen and view size.
-- Please call if you have to recalculate.
-- @param width Width of the screen
-- @param height Height of the screen
-- @param scale (Option)Scale of the Viewport to the Screen
--------------------------------------------------------------------------------
function M.updateDisplaySize(width, height, scale)
    M.screenWidth = width
    M.screenHeight = height
    M.viewScale = scale or M.viewScale
    M.viewWidth = M.screenWidth / M.viewScale
    M.viewHeight = M.screenHeight / M.viewScale

    M.viewport = M.viewport or MOAIViewport.new()
    M.viewport:setSize(M.screenWidth, M.screenHeight)
    M.viewport:setScale(M.viewWidth, -M.viewHeight)
    M.viewport:setOffset(-1, 1)
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
-- Returns the Viewport to be used in layers.
-- If you change the Viewport, it affects all layers.
-- @return width, height
--------------------------------------------------------------------------------
function M.getViewport()
    return M.viewport
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
-- @type class
--
-- This implements object-oriented style classes in Lua, including multiple inheritance.
-- This particular variation of class implementation copies the base class
-- functions into this class, which improves speed over other implementations
-- in return for slightly larger class tables.  Please note that the inherited
-- class members are therefore cached and subsequent changes to a superclass
-- may not be reflected in your subclasses.
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
    local clazz = table.copy(self)
    local bases = {...}
    for i = #bases, 1, -1 do
        table.copy(bases[i], clazz)
    end
    clazz.__super = bases[1]
    clazz.__call = function(self, ...)
        return self:__new(...)
    end
    return setmetatable(clazz, clazz)
end

--------------------------------------------------------------------------------
-- Generic constructor function for classes.
-- Note that __new() will call init() if it is available in the class.
-- @return Instance
--------------------------------------------------------------------------------
function class:__new(...)
    local obj = self:__object_factory()

    if obj.init then
        obj:init(...)
    end

    return obj
end

--------------------------------------------------------------------------------
-- Returns the new object.
-- @return object
--------------------------------------------------------------------------------
function class:__object_factory()
    local moai_class = self.__moai_class

    if moai_class then
        local obj = moai_class.new()
        obj.__class = self
        obj:setInterface(self)
        return obj
    end

    local obj = {__index = self, __class = self}
    return setmetatable(obj, obj)
end

----------------------------------------------------------------------------------------------------
-- @type table
--
-- The next group of functions extends the default lua table implementation
-- to include some additional useful methods.
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
-- Adds an element to the table.
-- @param t table
-- @param o element
-- @return true
--------------------------------------------------------------------------------
function table.insertElement(t, o)
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
-- @type math
--
-- This set of functions extends the native lua 'math' function set with
-- additional useful methods.
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
-- @type Executors
--
-- This is a utility class for asynchronous (coroutine-style) execution.
----------------------------------------------------------------------------------------------------
Executors = {}
M.Executors = Executors

--------------------------------------------------------------------------------
-- Run the specified function in a loop in a coroutine, forever.
-- If there is a return value of a function of argument, the loop is terminated.
-- @param func Target function.
-- @param ... Arguments to be passed to the function.
-- @return MOAICoroutine object
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
    return thread
end

--------------------------------------------------------------------------------
-- Run the specified function once, in a coroutine, immediately
-- (upon next coroutine.yield())
-- @param func Target function.
-- @param ... Arguments.
-- @return MOAICoroutine object
--------------------------------------------------------------------------------
function Executors.callOnce(func, ...)
    return Executors.callLaterFrame(0, func, ...)
end

--------------------------------------------------------------------------------
-- Run the specified function once, in a coroutine, after a specified delay in frames.
-- @param frame Delay frame count.
-- @param func Target function.
-- @param ... Arguments.
-- @return MOAICoroutine object
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
    return thread
end

--------------------------------------------------------------------------------
-- Run the specified function once, in a coroutine, after a specified delay in seconds.
-- @param time Delay seconds.
-- @param func Target function.
-- @param ... Arguments.
-- @return MOAITimer object
--------------------------------------------------------------------------------
function Executors.callLaterTime(time, func, ...)
    local args = {...}
    local timer = MOAITimer.new()
    timer:setSpan(time)
    timer:setListener(MOAITimer.EVENT_STOP, function() func(unpack(args)) end)
    timer:start()
    return timer
end

--------------------------------------------------------------------------------
-- Run the specified function in loop by a span time over and over again
-- @param time loop seconds.
-- @param func Target function.
-- @param ... Arguments.
-- @return MOAITimer object
--------------------------------------------------------------------------------
function Executors.callLoopTime(time, func, ...)
    local args = {...}
    local timer = MOAITimer.new()
    timer:setMode(MOAITimer.LOOP)
    timer:setSpan(time) -- EVENT_TIMER_LOOP
    timer:setListener(MOAITimer.EVENT_TIMER_BEGIN_SPAN, function() func(unpack(args)) end)
    timer:start()
    return timer
end

----------------------------------------------------------------------------------------------------
-- @type Resources
--
-- A resource management system that caches loaded resources to maximize performance.
----------------------------------------------------------------------------------------------------
Resources = {}
M.Resources = Resources

-- variables
Resources.resourceDirectories = {}
Resources.textureCache = setmetatable({}, {__mode = "v"})
Resources.fontCache = {}
Resources.atlasCache = {}
Resources.nineImageDeckCache = {}

--------------------------------------------------------------------------------
-- Add the resource directory path.
-- You can omit the file path by adding.
-- It is assumed that the file is switched by the resolution and the environment.
-- @param path resource directory path
--------------------------------------------------------------------------------
function Resources.addResourceDirectory(path)
    table.insertElement(Resources.resourceDirectories, path)
end

--------------------------------------------------------------------------------
-- Returns the filePath from fileName.
-- @param fileName
-- @return file path
--------------------------------------------------------------------------------
function Resources.getResourceFilePath(fileName)
    if MOAIFileSystem.checkFileExists(fileName) then
        return fileName
    end
    for i, path in ipairs(Resources.resourceDirectories) do
        local filePath = path .. "/" .. fileName
        if MOAIFileSystem.checkFileExists(filePath) then
            return filePath
        end
    end
    return fileName
end

--------------------------------------------------------------------------------
-- Loads (or obtains from its cache) a texture and returns it.
-- Textures are cached.
-- @param path The path of the texture
-- @return Texture instance
--------------------------------------------------------------------------------
function Resources.getTexture(path)
    if type(path) == "userdata" then
        return path
    end

    local cache = Resources.textureCache
    local filepath = Resources.getResourceFilePath(path)
    if cache[filepath] == nil then
        local texture = Texture(filepath)
        cache[filepath] = texture
    end
    return cache[filepath]
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
    if type(path) == "userdata" then
        return path
    end

    local cache = Resources.fontCache
    path = path or Font.DEFAULT_FONT
    path = Resources.getResourceFilePath(path)
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
    local filePath = Resources.getResourceFilePath(luaFilePath)
    local cache = Resources.atlasCache
    if cache[filePath] then
        return cache[filePath]
    end

    local frames = dofile(filePath).frames
    local data = {}
    data.frames = {}
    data.names = {}
    data.texture = texture and Resources.getTexture(texture)
    data.useBounds = false

    for i, frame in ipairs(frames) do
        data.names[frame.name] = i
        data.frames[i] = {}

        local uv = frame.uvRect
        local r = frame.spriteColorRect
        local b = frame.spriteSourceSize
        local dataFrame = data.frames[i]
        if frame.textureRotated then
            dataFrame.quad = {uv.u0, uv.v0, uv.u0, uv.v1, uv.u1, uv.v1, uv.u1, uv.v0}
        else
            dataFrame.quad = {uv.u0, uv.v1, uv.u1, uv.v1, uv.u1, uv.v0, uv.u0, uv.v0}
        end
        dataFrame.rect = {r.x, r.y, r.x + r.width, r.y + r.height}
        dataFrame.bounds = {0, 0, 0, b.width, b.height, 0}
        data.useBounds = data.useBounds or frame.spriteTrimmed
    end
    cache[filePath] = data
    return data
end

--------------------------------------------------------------------------------
-- Returns the Deck to draw NineImage.
-- For caching, you must not change the Deck.
-- @param fileName fileName
-- @return MOAIStretchPatch2D instance
--------------------------------------------------------------------------------
function Resources.getNineImageDeck(fileName)
    local filePath = Resources.getResourceFilePath(fileName)
    local cache = Resources.nineImageDeckCache

    if not cache[filePath] then
        cache[filePath] = Resources.createNineImageDeck(filePath)
    end

    return cache[filePath]
end

--------------------------------------------------------------------------------
-- Create the Deck to draw NineImage.
-- @param fileName fileName
-- @return MOAIStretchPatch2D instance
--------------------------------------------------------------------------------
function Resources.createNineImageDeck(fileName)
    local filePath = Resources.getResourceFilePath(fileName)

    local image = MOAIImage.new()
    image:load(filePath)

    local imageWidth, imageHeight = image:getSize()
    local displayWidth, displayHeight = imageWidth - 2, imageHeight - 2
    local stretchRows = Resources.createStretchRowsOrColumns(image, true)
    local stretchColumns = Resources.createStretchRowsOrColumns(image, false)
    local contentPadding = Resources.getNineImageContentPadding(image)
    local texture = Resources.getTexture(filePath)
    local uvRect = {1 / imageWidth, 1 / imageHeight, (imageWidth - 1) / imageWidth, (imageHeight - 1) / imageHeight}

    local deck = MOAIStretchPatch2D.new()
    deck.imageWidth = imageWidth
    deck.imageHeight = imageHeight
    deck.displayWidth = displayWidth
    deck.displayHeight = displayHeight
    deck.contentPadding = contentPadding
    deck:reserveUVRects(1)
    deck:setTexture(texture)
    deck:setRect(0, 0, displayWidth, displayHeight)
    deck:setUVRect(1, unpack(uvRect))
    deck:reserveRows(#stretchRows)
    deck:reserveColumns(#stretchColumns)

    for i, row in ipairs(stretchRows) do
        deck:setRow(i, row.weight, row.stretch)
    end
    for i, column in ipairs(stretchColumns) do
        deck:setColumn(i, column.weight, column.stretch)
    end

    return deck
end

function Resources.createStretchRowsOrColumns(image, isRow)
    local stretchs = {}
    local imageWidth, imageHeight = image:getSize()
    local targetSize = isRow and imageHeight or imageWidth
    local stretchSize = 0
    local pr, pg, pb, pa = image:getRGBA(0, 1)

    for i = 1, targetSize - 2 do
        local r, g, b, a = image:getRGBA(isRow and 0 or i, isRow and i or 0)
        stretchSize = stretchSize + 1

        if pa ~= a then
            table.insert(stretchs, {weight = stretchSize / (targetSize - 2), stretch = pa > 0})
            pa, stretchSize = a, 0
        end
    end
    if stretchSize > 0 then
        table.insert(stretchs, {weight = stretchSize / (targetSize - 2), stretch = pa > 0})
    end

    return stretchs
end

function Resources.getNineImageContentPadding(image)
    local imageWidth, imageHeight = image:getSize()
    local paddingLeft = 0
    local paddingTop = 0
    local paddingRight = 0
    local paddingBottom = 0

    for x = 0, imageWidth - 2 do
        local r, g, b, a = image:getRGBA(x + 1, imageHeight - 1)
        if a > 0 then
            paddingLeft = x
            break
        end
    end
    for x = 0, imageWidth - 2 do
        local r, g, b, a = image:getRGBA(imageWidth - x - 2, imageHeight - 1)
        if a > 0 then
            paddingRight = x
            break
        end
    end
    for y = 0, imageHeight - 2 do
        local r, g, b, a = image:getRGBA(imageWidth - 1, y + 1)
        if a > 0 then
            paddingTop = y
            break
        end
    end
    for y = 0, imageHeight - 2 do
        local r, g, b, a = image:getRGBA(imageWidth - 1, imageHeight - y - 2)
        if a > 0 then
            paddingBottom = y
            break
        end
    end

    return {paddingLeft, paddingTop, paddingRight, paddingBottom}
end

--------------------------------------------------------------------------------
-- Returns the file data.
-- @param fileName file name
-- @return file data
--------------------------------------------------------------------------------
function Resources.readFile(fileName)
    local path = Resources.getResourceFilePath(fileName)
    local input = assert(io.input(path))
    local data = input:read("*a")
    input:close()
    return data
end

--------------------------------------------------------------------------------
-- Returns the result of executing the dofile.
-- Browse to the directory of the resource.
-- @param fileName lua file name
-- @return results of running the dofile
--------------------------------------------------------------------------------
function Resources.dofile(fileName)
    local filePath = Resources.getResourceFilePath(fileName)
    return dofile(filePath)
end

--------------------------------------------------------------------------------
-- Destroys the reference when the module.
-- @param m module
--------------------------------------------------------------------------------
function Resources.destroyModule(m)
    if m and m._M and m._NAME and package.loaded[m._NAME] then
        package.loaded[m._NAME] = nil
        _G[m._NAME] = nil
    end
end

----------------------------------------------------------------------------------------------------
-- @type PropertyUtils
-- It is a property utility class.
----------------------------------------------------------------------------------------------------
PropertyUtils = {}
M.PropertyUtils = PropertyUtils

PropertyUtils.SETTER_NAMES = {}

--------------------------------------------------------------------------------
-- Sets the properties to object.
-- @param obj target object
-- @param properties source properties
-- @param unpackFlag Expand in the case of a simple table
--------------------------------------------------------------------------------
function PropertyUtils.setProperties(obj, properties, unpackFlag)
    for name, value in pairs(properties) do
        PropertyUtils.setProperty(obj, name, value, unpackFlag)
    end
end

--------------------------------------------------------------------------------
-- Sets the property to object.
-- @param obj target object
-- @param name property name
-- @param value property value
-- @param unpackFlag Expand in the case of a simple table
--------------------------------------------------------------------------------
function PropertyUtils.setProperty(obj, name, value, unpackFlag)
    local setterNames = PropertyUtils.SETTER_NAMES
    if not setterNames[name] then
        local setterName = "set" .. name:sub(1, 1):upper() .. (#name > 1 and name:sub(2) or "")
        setterNames[name] = setterName
    end

    local setterName = setterNames[name]
    local setter = assert(obj[setterName], "Not Found Property!" .. name)
    if not unpackFlag or type(value) ~= "table" or getmetatable(value) ~= nil then
        return setter(obj, value)
    else
        return setter(obj, unpack(value))
    end
end

----------------------------------------------------------------------------------------------------
-- @type ClassFactory
--
-- Factory that creates an instance of the Class.
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
-- @type Event
--
-- A class for events, which are communicated to, and handled by, event handlers
-- Holds the data of the Event.
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
Event.RESIZE            = "resize"

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
-- @type EventListener
--
-- A virtual superclass for EventListeners.
-- Classes which inherit from this class become able to receive events.
-- Currently intended for internal use only.
----------------------------------------------------------------------------------------------------
EventListener = class()
M.EventListener = EventListener

--------------------------------------------------------------------------------
-- The constructor.
-- @param eventType The type of event.
-- @param callback The callback function.
-- @param source The source.
-- @param priority The priority.
--------------------------------------------------------------------------------
function EventListener:init(eventType, callback, source, priority)
    self.type = eventType
    self.callback = callback
    self.source = source
    self.priority = priority or 0
end

--------------------------------------------------------------------------------
-- Call the event listener.
-- @param event Event
--------------------------------------------------------------------------------
function EventListener:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end

----------------------------------------------------------------------------------------------------
-- @type EventDispatcher
--
-- This class is responsible for event notifications.
----------------------------------------------------------------------------------------------------
EventDispatcher = class()
M.EventDispatcher = EventDispatcher

EventDispatcher.EVENT_CACHE = {}

--------------------------------------------------------------------------------
-- The constructor.
-- @param eventType (option)The type of event.
--------------------------------------------------------------------------------
function EventDispatcher:init()
    self.eventListenersMap = {}
end

--------------------------------------------------------------------------------
-- Adds an event listener.
-- will now catch the events that are sent in the dispatchEvent.
-- @param eventType Target event type.
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
    if not self.eventListenersMap[eventType] then
        self.eventListenersMap[eventType] = {}
    end

    local listeners = self.eventListenersMap[eventType]
    local listener = EventListener(eventType, callback, source, priority)

    for i, v in ipairs(listeners) do
        if listener.priority < v.priority then
            table.insert(listeners, i, listener)
            return true
        end
    end

    table.insert(listeners, listener)
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

    local listeners = self.eventListenersMap[eventType] or {}

    for i, listener in ipairs(listeners) do
        if listener.type == eventType and listener.callback == callback and listener.source == source then
            table.remove(listeners, i)
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

    local listeners = self.eventListenersMap[eventType]
    if not listeners or #listeners == 0 then
        return false
    end

    if callback == nil and source == nil then
        return true
    end

    for i, listener in ipairs(listeners) do
        if listener.callback == callback and listener.source == source then
            return true
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
        event = EventDispatcher.EVENT_CACHE[eventName] or Event(eventName)
        EventDispatcher.EVENT_CACHE[eventName] = nil
    end

    assert(event.type)

    event.stopFlag = false
    event.target = self.eventTarget or self
    if data ~= nil then
        event.data = data
    end

    local listeners = self.eventListenersMap[event.type] or {}

    for key, obj in ipairs(listeners) do
        if obj.type == event.type then
            event:setListener(obj.callback, obj.source)
            obj:call(event)
            if event.stopFlag == true then
                break
            end
        end
    end

    if eventName then
        EventDispatcher.EVENT_CACHE[eventName] = event
    end
end

--------------------------------------------------------------------------------
-- Remove all event listeners.
--------------------------------------------------------------------------------
function EventDispatcher:clearEventListeners()
    self.eventlistenersMap = {}
end

----------------------------------------------------------------------------------------------------
-- @type Runtime
--
-- This is a utility class which starts immediately upon library load
-- and acts as the single handler for ENTER_FRAME events (which occur
-- whenever Moai yields control to the Lua subsystem on each frame).
----------------------------------------------------------------------------------------------------
Runtime = EventDispatcher()
M.Runtime = Runtime

-- initialize
function Runtime:initialize()
    Executors.callLoop(self.onEnterFrame)
    MOAIGfxDevice.setListener(MOAIGfxDevice.EVENT_RESIZE, self.onResize)
end

-- enter frame
function Runtime.onEnterFrame()
    Runtime:dispatchEvent(Event.ENTER_FRAME)
end


-- view resize
function Runtime.onResize(width, height)
    M.updateDisplaySize(width, height)

    local e = Event(Event.RESIZE)
    e.width = width
    e.height = height
    Runtime:dispatchEvent(e)
end

----------------------------------------------------------------------------------------------------
-- @type InputMgr
--
-- This singleton class manages all input events (touch, key, cursor).
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
-- @type RenderMgr
--
-- This is a singleton class that manages the rendering object.
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
-- @type SceneMgr
--
-- This is a singleton class to manage the scene object.
----------------------------------------------------------------------------------------------------
SceneMgr = EventDispatcher()
M.SceneMgr = SceneMgr

-- variables
SceneMgr.scenes = {}
SceneMgr.currentScene = nil
SceneMgr.nextScene = nil
SceneMgr.nextSceneIndex = nil
SceneMgr.closingSceneSize = nil
SceneMgr.closingSceneGroup = nil
SceneMgr.transitioning = false
SceneMgr.sceneUpdateEnabled = true
SceneMgr.sceneTouchEnabled = true
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
-- variable that can be specified in params are as follows.
-- <ul>
--   <li>animation: Scene animation of transition. </li>
--   <li>second: Time to scene animation. </li>
--   <li>easeType: EaseType to animation scene. </li>
-- </ul>
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
-- variable that can be specified in params are as follows.
-- <ul>
--   <li>animation: Scene animation of transition. </li>
--   <li>second: Time to scene animation. </li>
--   <li>easeType: EaseType to animation scene. </li>
--   <li>backScene: The name of the scene you want to back. </li>
--   <li>backSceneCount: Number of scene you want to back. </li>
-- </ul>
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
    local backSceneName = params.backScene
    local backSceneCount = params.backSceneCount or 1
    self.nextScene = backSceneName and assert(self:getSceneByName(backSceneName)) or self.scenes[#self.scenes - backSceneCount]
    self.nextSceneIndex = table.indexOf(self.scenes, self.nextScene)

    -- set closing scenes
    self.closingSceneSize = #self.scenes - self.nextSceneIndex
    self.closingSceneGroup = Scene()
    for i = 0, self.closingSceneSize - 1 do
        local scene = self.scenes[#self.scenes - i]
        self.closingSceneGroup:addChild(scene)
    end

    -- stop current scene
    self.currentScene:stop(params)

    Executors.callOnce(
    function()
        local animation = self:getSceneAnimationByName(params.animation)
        animation(self.closingSceneGroup, self.nextScene or Scene(), params)

        -- close scens
        for i, scene in ipairs(self.closingSceneGroup.children) do
            scene:close(params)
        end

        self.closingSceneGroup = nil
        self.closingSceneSize = nil
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
    if not self.sceneTouchEnabled then
        return
    end

    local scene = self.currentScene
    if scene and scene.sceneTouchEnabled then
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
-- @type DisplayObject
--
-- The base class of the display object, adding several useful methods.
----------------------------------------------------------------------------------------------------
DisplayObject = class(EventDispatcher)
DisplayObject.__index = MOAIPropInterface
DisplayObject.__moai_class = MOAIProp
M.DisplayObject = DisplayObject

--------------------------------------------------------------------------------
-- Returns the size.
-- If there is a function that returns a negative getDims.
-- getSize function always returns the size of the positive.
-- @return width, height, depth
--------------------------------------------------------------------------------
function DisplayObject:getSize()
    local w, h, d = self:getDims()
    w = w or 0
    h = h or 0
    d = d or 0
    return math.abs(w), math.abs(h), math.abs(d)
end

--------------------------------------------------------------------------------
-- Returns the width.
-- @return width
--------------------------------------------------------------------------------
function DisplayObject:getWidth()
    local w, h, d = self:getSize()
    return w
end

--------------------------------------------------------------------------------
-- Returns the height.
-- @return height
--------------------------------------------------------------------------------
function DisplayObject:getHeight()
    local w, h, d = self:getSize()
    return h
end

--------------------------------------------------------------------------------
-- Sets the position.
-- Without depending on the Pivot, move the top left corner as the origin.
-- @param left Left position
-- @param top Top position
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
-- @return Left
-- @return Top
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
    local width, height = self:getSize()
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
    local w, h, d = self:getSize()
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
-- Sets the visibility.
-- TODO:I avoid the bug of display settings MOAIProp.(2013/05/20 last build)
-- @param value visible
--------------------------------------------------------------------------------
function DisplayObject:setVisible(visible)
    MOAIPropInterface.setVisible(self, visible)
    self:forceUpdate()
end

--------------------------------------------------------------------------------
-- Sets the object's parent, inheriting its color and transform.
-- @param parent parent
--------------------------------------------------------------------------------
function DisplayObject:setParent(parent)
    self.parent = parent

    self:clearAttrLink(MOAIColor.INHERIT_COLOR)
    self:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)

    -- Conditions compatibility
    if MOAIProp.INHERIT_VISIBLE then
        self:clearAttrLink(MOAIProp.INHERIT_VISIBLE)
    end

    if parent then
        self:setAttrLink(MOAIColor.INHERIT_COLOR, parent, MOAIColor.COLOR_TRAIT)
        self:setAttrLink(MOAITransform.INHERIT_TRANSFORM, parent, MOAITransform.TRANSFORM_TRAIT)

        -- Conditions compatibility
        if MOAIProp.INHERIT_VISIBLE then
            self:setAttrLink(MOAIProp.INHERIT_VISIBLE, parent, MOAIProp.ATTR_VISIBLE)
        end
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
-- @type Layer
--
-- This is flower's idea of a Layer, which is a superclass of the MOAI concept of Layer.
----------------------------------------------------------------------------------------------------
Layer = class(DisplayObject)
Layer.__index = MOAILayerInterface
Layer.__moai_class = MOAILayer
M.Layer = Layer

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function Layer:init(viewport)
    DisplayObject.init(self)

    local partition = MOAIPartition.new()
    self:setPartition(partition)
    self.partition = partition

    self:setViewport(viewport or M.viewport)
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

--------------------------------------------------------------------------------
-- Unsupport nested layer.
-- @param layer layer
--------------------------------------------------------------------------------
function Layer:setLayer(layer)
end

----------------------------------------------------------------------------------------------------
-- @type Camera
--
-- flower's idea of a Camera, which is a superclass of the Moai Camera.
----------------------------------------------------------------------------------------------------
Camera = class()
Camera.__index = MOAICameraInterface
Camera.__moai_class = MOAICamera
M.Camera = Camera

--------------------------------------------------------------------------------
-- The constructor.
-- @param ortho (option)ortho
-- @param near (option)near plane
-- @param far (option)far plane
--------------------------------------------------------------------------------
function Camera:init(ortho, near, far)
    ortho = ortho == nil and true or ortho
    near = near or 1
    far = far or -1

    self:setOrtho(ortho)
    self:setNearPlane(near)
    self:setFarPlane(far)
end

----------------------------------------------------------------------------------------------------
-- @type Group
--
-- A class to manage and control sets of DisplayObjects.
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
    self:setSize(width or 0, height or 0)

    self:setPivToCenter()
end

--------------------------------------------------------------------------------
-- Sets the size.
-- This is the size of a Group, rather than of the children.
-- @param width width
-- @param height height
--------------------------------------------------------------------------------
function Group:setSize(width, height)
    self:setBounds(0, 0, 0, width, height, 0)
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
-- Remove the children.
--------------------------------------------------------------------------------
function Group:removeChildren()
    local children = table.copy(self.children)
    for i, child in ipairs(children) do
        self:removeChild(child)
    end
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
    DisplayObject.setVisible(self, value)

    -- Compatibility
    if not MOAIProp.INHERIT_VISIBLE then
        for i, v in ipairs(self.children) do
            v:setVisible(value)
        end
    end
end

--------------------------------------------------------------------------------
-- Sets the group's priority.
-- Also sets the priority of any children.
-- @param priority priority
--------------------------------------------------------------------------------
function Group:setPriority(priority)
    MOAIPropInterface.setPriority(self, priority)

    for i, v in ipairs(self.children) do
        v:setPriority(priority)
    end
end

----------------------------------------------------------------------------------------------------
-- @type Scene
--
-- A scene class, handling display on one or more layers and receiving events from the EventMgr.
-- Object is controlled by SceneMgr; use that class to manipulate scenes.
----------------------------------------------------------------------------------------------------
Scene = class(Group)
M.Scene = Scene

--- Touch Event Cache
Scene.TOUCH_EVENT = Event()

--- Default scene destroy enabled
Scene.DEFAULT_DESTROY_ENABLED = true


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
    self.sceneTouchEnabled = false
    self.sceneDestroyEnabled = Scene.DEFAULT_DESTROY_ENABLED
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
    self.opened = false
    self:dispatchEvent(Event.CLOSE, params)
    SceneMgr:removeScene(self)

    if self.sceneDestroyEnabled then
        Resources.destroyModule(self.controller)
    end
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
    self.sceneTouchEnabled = true
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
    self.sceneTouchEnabled = false
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
-- @type SceneAnimations
-- A class to handle transitions between scenes and defining various animations for those transitions.
----------------------------------------------------------------------------------------------------
SceneAnimations = {}

--- Scene animation
function SceneAnimations.change(currentScene, nextScene, params)
    currentScene:setVisible(false)

    nextScene:setScl(1, 1, 1)
    nextScene:setColor(1, 1, 1, 1)
    nextScene:setPos(0, 0)
    nextScene:setVisible(true)
end

--- Scene animation
function SceneAnimations.overlay(currentScene, nextScene, params)
    nextScene:setScl(1, 1, 1)
    nextScene:setColor(1, 1, 1, 1)
    nextScene:setPos(0, 0)
    nextScene:setVisible(true)
end

--- Scene animation
function SceneAnimations.fade(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType

    nextScene:setVisible(true)
    nextScene:setColor(0, 0, 0, 0)

    MOAICoroutine.blockOnAction(currentScene:seekColor(0, 0, 0, 0, sec, easeType))
    MOAICoroutine.blockOnAction(nextScene:seekColor(1, 1, 1, 1, sec, easeType))

    currentScene:setVisible(false)
end

--- Scene animation
function SceneAnimations.crossFade(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType

    nextScene:setVisible(true)
    nextScene:setColor(0, 0, 0, 0)

    local action1 = currentScene:seekColor(0, 0, 0, 0, sec, easeType)
    local action2 = nextScene:seekColor(1, 1, 1, 1, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
end

--- Scene animation
function SceneAnimations.popIn(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType

    nextScene:setVisible(true)
    nextScene:setScl(0.5, 0.5, 0.5)
    nextScene:setColor(0, 0, 0, 0)

    local action1 = nextScene:seekColor(1, 1, 1, 1, sec, easeType)
    local action2 = nextScene:seekScl(1, 1, 1, sec, easeType)
    MOAICoroutine.blockOnAction(action1)
end

--- Scene animation
function SceneAnimations.popOut(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType

    local action1 = currentScene:seekColor(0, 0, 0, 0, sec, easeType)
    local action2 = currentScene:seekScl(0.5, 0.5, 0.5, sec, easeType)
    MOAICoroutine.blockOnAction(action1)
end

--- Scene animation
function SceneAnimations.slideLeft(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType
    local sw, sh = M.getScreenSize()

    nextScene:setVisible(true)
    nextScene:setPos(sw, 0)

    local action1 = currentScene:moveLoc(-sw, 0, 0, sec, easeType)
    local action2 = nextScene:moveLoc(-sw, 0, 0, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    nextScene:setPos(0, 0)
end

--- Scene animation
function SceneAnimations.slideRight(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType
    local sw, sh = M.getScreenSize()

    nextScene:setVisible(true)
    nextScene:setPos(-sw, 0)

    local action1 = currentScene:moveLoc(sw, 0, 0, sec, easeType)
    local action2 = nextScene:moveLoc(sw, 0, 0, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    nextScene:setPos(0, 0)
end

--- Scene animation
function SceneAnimations.slideTop(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType
    local sw, sh = M.getScreenSize()

    nextScene:setVisible(true)
    nextScene:setPos(0, sh)

    local action1 = currentScene:moveLoc(0, -sh, 0, sec, easeType)
    local action2 = nextScene:moveLoc(0, -sh, 0, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    nextScene:setPos(0, 0)
end

--- Scene animation
function SceneAnimations.slideBottom(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType
    local sw, sh = M.getScreenSize()

    nextScene:setVisible(true)
    nextScene:setPos(0, -sh)

    local action1 = currentScene:moveLoc(0, sh, 0, sec, easeType)
    local action2 = nextScene:moveLoc(0, sh, 0, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    nextScene:setPos(0, 0)
end

----------------------------------------------------------------------------------------------------
-- @type Image
-- Class to display a simple texture.
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
    self.deck:setRect(0, 0, width, height)
    self:setPivToCenter()
end

--------------------------------------------------------------------------------
-- Sets the texture.
-- @param texture Texture path, or texture
--------------------------------------------------------------------------------
function Image:setTexture(texture)
    self.texture = Resources.getTexture(texture)
    self.deck:setTexture(self.texture)
    local tw, th = self.texture:getSize()
    self:setSize(tw, th)
end

----------------------------------------------------------------------------------------------------
-- @type SheetImage
--
-- Class that displays an image from a sheet of images, supporting TexturePacker's format.
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
-- Sets the texture.
-- @param texture Texture path, or texture
--------------------------------------------------------------------------------
function SheetImage:setTexture(texture)
    self.texture = Resources.getTexture(texture)
    self.deck:setTexture(self.texture)
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

    local boundsDeck = nil
    if atlas.useBounds then
        boundsDeck = MOAIBoundsDeck.new()
        boundsDeck:reserveBounds(self.sheetSize)
        boundsDeck:reserveIndices(self.sheetSize)
    end
    deck:setBoundsDeck(boundsDeck)

    for i, frame in ipairs ( atlas.frames ) do
        if not self.grid then
            deck:setRect(i, unpack(frame.rect))
        end
        deck:setUVQuad(i, unpack(frame.quad))
        if boundsDeck then
            boundsDeck:setBounds(i, unpack(frame.bounds))
            boundsDeck:setIndex(i, i)
        end
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
            local sx = (x - 1) * (tileWidth + spacing) + margin
            local sy = (y - 1) * (tileHeight + spacing) + margin
            local ux0 = sx / tw
            local uy0 = sy / th
            local ux1 = (sx + tileWidth) / tw
            local uy1 = (sy + tileHeight) / th

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

--------------------------------------------------------------------------------
-- Sets the sheet's image width and height.
-- @param width
-- @param height
--------------------------------------------------------------------------------
function SheetImage:setSize(width, height)
    self.deck:setRect(self:getIndex(), 0, 0, width, height)
end

----------------------------------------------------------------------------------------------------
-- @type MapImage
--
-- Class that loads a tiled map of images (see MOAIGrid).
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
-- @param gridWidth The size of the grid
-- @param gridHeight The size of the grid
-- @param tileWidth The size of the tile
-- @param tileHeight The size of the tile
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
-- @param ... rows of data.
--------------------------------------------------------------------------------
function MapImage:setRow(...)
    self.grid:setRow(...)
end

--------------------------------------------------------------------------------
-- Sets the map value.
-- @param x x position of the grid
-- @param y y position of the grid
-- @param value tile value.
--------------------------------------------------------------------------------
function MapImage:setTile(x, y, value)
    self.grid:setTile(x, y, value)
end

--------------------------------------------------------------------------------
-- Returns the map value.
-- @param x x position of the grid
-- @param y y position of the grid
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
-- @type MovieClip
-- Class for animated texture atlases ('MovieClip' is the Adobe Flash terminology)
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
-- @param name Name of anim
-- @param anim Anim object
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
-- @type NineImage
--
-- This class displays the NinePatch of Android.
-- The following restrictions exist.
-- In many cases, to solve by wrapping it in Group class.
--
-- <ol>
--   <li>setPiv function does not work.</li>
--   <li>Scale should not be set directly.<li>
-- </ol>
----------------------------------------------------------------------------------------------------
NineImage = class(DisplayObject)
M.NineImage = NineImage

--------------------------------------------------------------------------------
-- Constructor.
-- @param imagePath File path NinePach.
-- @param width (option) Width of image.
-- @param height (option) Height of image.
--------------------------------------------------------------------------------
function NineImage:init(imagePath, width, height)
    DisplayObject.init(self)
    self._scaledWidth = nil
    self._scaledHeight = nil

    self:setImage(imagePath, width, height)
    if not width or not height then
        self:setSize(width or self.deck.displayWidth, height or self.deck.displayHeight)
    end
end

--------------------------------------------------------------------------------
-- Set the NineImageDeck.
-- @param imagePath File path or NineImageDeck.
-- @param width (option) Width of image.
-- @param height (option) Height of image.
--------------------------------------------------------------------------------
function NineImage:setImage(imagePath, width, height)
    if type(imagePath) == "string" then
        self.deck = Resources.getNineImageDeck(imagePath)
    else
        self.deck = imagePath
    end

    local orgWidth, orgHeight = self:getSize()
    width = width or orgWidth
    height = height or orgHeight

    self:setDeck(self.deck)
    self:setSize(width, height)
end

--------------------------------------------------------------------------------
-- Set the scale to match the size.
-- Is set as the size artificially.
-- @param width Width of image.
-- @param height Height of image.
--------------------------------------------------------------------------------
function NineImage:setSize(width, height)
    local iw, ih = self.deck.displayWidth, self.deck.displayHeight
    local left, top = self:getPos()
    local sclX, sclY, sclZ = width / iw, height / ih, 1

    self._scaledWidth = width
    self._scaledHeight = height
    self:setScl(sclX, sclY, sclZ)
end

--------------------------------------------------------------------------------
-- Returns the dummey dimensions.
-- @return sacled width
-- @return scaled height
-- @return 0
--------------------------------------------------------------------------------
function NineImage:getDims()
    return self._scaledWidth, self._scaledHeight, 0
end

--------------------------------------------------------------------------------
-- Returns the dummey bounds.
-- @return xMin(0)
-- @return yMin(0)
-- @return zMin(0)
-- @return xMax(sacled width)
-- @return yMax(scaled height)
-- @return 0
--------------------------------------------------------------------------------
function NineImage:getBounds()
    return 0, 0, 0, self._scaledWidth, self._scaledHeight, 0
end

--------------------------------------------------------------------------------
-- Unsupported pivot.
--------------------------------------------------------------------------------
function NineImage:setPiv(xPiv, yPiv, zPiv)
    print("Unsupported!")
end

--------------------------------------------------------------------------------
-- Returns the content rect from NinePatch.
-- @return xMin
-- @return yMin
-- @return xMax
-- @return yMax
--------------------------------------------------------------------------------
function NineImage:getContentRect()
    local width, height = self:getSize()
    local padding = self.deck.contentPadding
    local xMin = padding[1]
    local yMin = padding[2]
    local xMax = width - padding[3]
    local yMax = height - padding[4]
    return xMin, yMin, xMax, yMax
end

--------------------------------------------------------------------------------
-- Returns the content padding from NinePatch.
-- @return paddingLeft
-- @return paddingTop
-- @return paddingRight
-- @return paddingBottom
--------------------------------------------------------------------------------
function NineImage:getContentPadding()
    local padding = self.deck.contentPadding
    return unpack(padding)
end

----------------------------------------------------------------------------------------------------
-- @type Label
--
-- Label for text display.
-- Based on MOAITextBox.
----------------------------------------------------------------------------------------------------
Label = class(DisplayObject)
Label.__index = MOAITextBoxInterface
Label.__moai_class = MOAITextBox
M.Label = Label

--- Max width for fit size.
Label.MAX_FIT_WIDTH = 10000000

--- Max height for fit size.
Label.MAX_FIT_HEIGHT = 10000000

--- default fit length.
Label.DEFAULT_FIT_LENGTH = 10000000

--- default fit padding.
Label.DEFAULT_FIT_PADDING = 2

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
    self:setRect(0, 0, width or 10, height or 10)
    self:setTextSize(textSize or Font.DEFAULT_POINTS)
    self:setString(text)

    if not width or not height then
        self:fitSize(#text)
    end
end

--------------------------------------------------------------------------------
-- Sets the size.
-- @param width Width
-- @param height Height
--------------------------------------------------------------------------------
function Label:setSize(width, height)
    self:setRect(0, 0, width, height)
end

--------------------------------------------------------------------------------
-- Sets the fit size.
-- @param lenfth (Option)Length of the text.
-- @param maxWidth (Option)maxWidth of the text.
-- @param maxHeight (Option)maxHeight of the text.
-- @param padding (Option)padding of the text.
--------------------------------------------------------------------------------
function Label:fitSize(length, maxWidth, maxHeight, padding)
    length = length or Label.DEFAULT_FIT_LENGTH
    maxWidth = maxWidth or Label.MAX_FIT_WIDTH
    maxHeight = maxHeight or Label.MAX_FIT_HEIGHT
    padding = padding or Label.DEFAULT_FIT_PADDING

    self:setSize(maxWidth, maxHeight)
    local left, top, right, bottom = self:getStringBounds(1, length)
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local width, height = right - left + padding, bottom - top + padding

    self:setSize(width, height)
end

--------------------------------------------------------------------------------
-- Sets the fit height.
-- @param lenfth (Option)Length of the text.
-- @param maxHeight (Option)maxHeight of the text.
-- @param padding (Option)padding of the text.
--------------------------------------------------------------------------------
function Label:fitHeight(length, maxHeight, padding)
    self:fitSize(length, self:getWidth(), maxHeight, padding)
end

--------------------------------------------------------------------------------
-- Sets the fit height.
-- @param lenfth (Option)Length of the text.
-- @param maxWidth (Option)maxWidth of the text.
-- @param padding (Option)padding of the text.
--------------------------------------------------------------------------------
function Label:fitWidth(length, maxWidth, padding)
    self:fitSize(length, maxWidth, self:getHeight(), padding)
end

----------------------------------------------------------------------------------------------------
-- @type Rect
--
-- Class to fill a rectangle. <br>
-- NOTE: This uses immediate mode drawing and so has a high performance impact when
-- used on mobile devices.  You may wish to use a 1-pixel high Image instead if you
-- wish to minimize draw calls.
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
        local w, h, d = self:getSize()

        MOAIGfxDevice.setPenColor(self:getColor())
        MOAIDraw.fillRect(0, 0, w, h)
    end
    )
end

--------------------------------------------------------------------------------
-- Sets the size.
-- @param width Width
-- @param height Height
--------------------------------------------------------------------------------
function Rect:setSize(width, height)
    self.deck:setRect(0, 0, width, height)
end

----------------------------------------------------------------------------------------------------
-- @type Texture
--
-- Texture class.
----------------------------------------------------------------------------------------------------
Texture = class()
Texture.__index = MOAITextureInterface
Texture.__moai_class = MOAITexture
M.Texture = Texture

--- Default Texture filter
Texture.DEFAULT_FILTER = MOAITexture.GL_LINEAR

--------------------------------------------------------------------------------
-- Constructor.
-- @param path Texture path
--------------------------------------------------------------------------------
function Texture:init(path)
    self:load(path)
    self.path = path

    if Texture.DEFAULT_FILTER then
        self:setFilter(Texture.DEFAULT_FILTER)
    end
end

----------------------------------------------------------------------------------------------------
-- @type Font
--
-- Font class.
----------------------------------------------------------------------------------------------------
Font = class()
Font.__index = MOAIFontInterface
Font.__moai_class = MOAIFont
M.Font = Font

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
-- @type TouchHandler
--
-- Class to perform the handling of touch events emitted from a layer.
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
        prop2 = nil
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
        if e.stopFlag then
            break
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
