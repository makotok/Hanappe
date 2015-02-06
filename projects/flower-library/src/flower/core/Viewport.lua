----------------------------------------------------------------------------------------------------
-- @type Viewport
--
-- This is flower's idea of a Layer, which is a superclass of the MOAI concept of Layer.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Config = require "flower.core.Config"
local Window = require "flower.core.Window"
local Event = require "flower.core.Event"
local EventDispatcher = require "flower.core.EventDispatcher"

-- class
local Viewport = class(EventDispatcher)
Viewport.__index = MOAIViewport.getInterfaceTable()
Viewport.__moai_class = MOAIViewport

-- static variables
local DEFAULT_VIEWPORT = nil

---
-- Returns the defalut viewport.
-- @return default viewport
function Viewport.getDefaultViewport()
    if not DEFAULT_VIEWPORT then
        DEFAULT_VIEWPORT = Viewport()
        DEFAULT_VIEWPORT:setAutoResizeEnabled(true)
    end
    return DEFAULT_VIEWPORT
end

---
-- Constructor.
function Viewport:init()
    Viewport.__super.init(self)

    self:updateViewSize(Config.WINDOW_WIDTH, Config.WINDOW_HEIGHT, Config.VIEWPORT_SCALE, Config.VIEWPORT_YFLIP)
    self:setAutoResizeEnabled(true)
end

---
-- Set the auto resize when resize window.
function Viewport:setAutoResizeEnabled(value)
    if self.autoResizeEnabled == value then
        return
    end

    if self.autoResizeEnabled then
        Window:removeEventListener(Event.RESIZE, self.onWindowResize, self)
    end

    self.autoResizeEnabled = value

    if self.autoResizeEnabled then
        Window:addEventListener(Event.RESIZE, self.onWindowResize, self)
    end
end

---
-- Update the size and scale and offset.
function Viewport:updateViewSize(width, height, viewScale, yFlip)
    self.width = width or self.width
    self.height = height or self.height

    self.viewScale = viewScale or self.viewScale
    self.viewWidth = self.width / self.viewScale
    self.viewHeight = self.height / self.viewScale
    self.yFlip = yFlip or self.yFlip

    self:setSize(self.width, self.height)

    if self.yFlip then
        self:setScale(self.viewWidth, self.viewHeight)
        self:setOffset(-1, -1)
    else
        self:setScale(self.viewWidth, -self.viewHeight)
        self:setOffset(-1, 1)
    end

    local e = Event(Event.RESIZE)
    e.width = self.width
    e.height = self.height
    e.viewWidth = self.viewWidth
    e.viewHeight = self.viewHeight
    e.viewScale = self.viewScale
    
    self:dispatchEvent(e)
end

function Viewport:onWindowResize(e)
    self:updateViewSize(e.width, e.height)
end

return Viewport
