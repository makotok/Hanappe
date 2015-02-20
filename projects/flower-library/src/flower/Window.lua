----------------------------------------------------------------------------------------------------
-- TODO:LDoc
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.EventDispatcher.html">EventDispatcher</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Config = require "flower.Config"
local Runtime = require "flower.Runtime"
local Devices = require "flower.Devices"
local Event = require "flower.Event"
local EventDispatcher = require "flower.EventDispatcher"

-- singleton class
local Window = EventDispatcher()

---
-- Open the window.
-- Initializes the library.
-- @param title (Option)Title of the window
-- @param width (Option)Width of the window
-- @param height (Option)Height of the window
-- @param scale (Option)Scale of the Viewport to the Screen
function Window:openWindow(title, width, height, scale)
    self.title = title or Config.WINDOW_TITLE
    self.width = width or Config.WINDOW_WIDTH
    self.height = height or Config.WINDOW_HEIGHT
    self.scale = scale or Config.VIEWPORT_SCALE

    self:updateWindowSize(self.width, self.height, self.scale)

    MOAIGfxDevice.setListener(MOAIGfxDevice.EVENT_RESIZE, function(w, h) self:onResize(w, h) end)
    MOAISim.openWindow(self.title, self.width, self.height)
end

---
-- Set the size of the assumed device.
function Window:setDefaultWindowSize(targetDevice, landscape, scaleMode)
    assert(targetDevice)

    -- mobile
    if Runtime.isMobile() then
        Config.WINDOW_WIDTH = MOAIEnvironment.horizontalResolution
        Config.WINDOW_HEIGHT = MOAIEnvironment.verticalResolution
        Config.VIEWPORT_SCALE = math.max(Config.WINDOW_WIDTH, Config.WINDOW_HEIGHT) > 960 and 2 or 1
        return
    end

    -- desktop
    local device = type(targetDevice) == "string" and assert(Devices[targetDevice]) or targetDevice
    local displayWidth = landscape and math.max(device.displayWidth, device.displayHeight) or math.min(device.displayWidth, device.displayHeight)
    local displayHeight = landscape and math.min(device.displayWidth, device.displayHeight) or math.max(device.displayWidth, device.displayHeight)
    local viewportScale = 1

    if device.retinaDisplay then
        if scaleMode then
            viewportScale = 2
        else
            displayWidth = displayWidth / 2
            displayHeight = displayHeight / 2
        end
    end

    Config.WINDOW_WIDTH = displayWidth
    Config.WINDOW_HEIGHT = displayHeight
    Config.VIEWPORT_SCALE = viewportScale
end

---
-- Update the screen and view size.
-- Please call if you have to recalculate.
-- @param width Width of the screen
-- @param height Height of the screen
-- @param scale (Option)Scale of the Viewport to the Screen
function Window:updateWindowSize(width, height, scale)
    self.width = assert(width)
    self.height = assert(height)
    self.scale = scale or self.scale

    Config.WINDOW_WIDTH = self.width
    Config.WINDOW_HEIGHT = self.height
    Config.VIEWPORT_SCALE = self.scale

    local e = Event(Event.RESIZE)
    e.width = self.width
    e.height = self.height

    self:dispatchEvent(e)
    Runtime:dispatchEvent(e)
end

---
-- Event handler that is called when resizing Window.
-- @param width Width of window.
-- @param height Height of window.
function Window:onResize(width, height)
    self:updateWindowSize(width, height)
end

return Window